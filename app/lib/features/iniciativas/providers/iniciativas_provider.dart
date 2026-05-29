import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/iniciativa_model.dart';

final iniciativasProvider =
    AsyncNotifierProvider<IniciativasNotifier, List<Iniciativa>>(
        IniciativasNotifier.new);

class IniciativasNotifier extends AsyncNotifier<List<Iniciativa>> {
  final _db = Supabase.instance.client;

  @override
  Future<List<Iniciativa>> build() => _fetch();

  Future<List<Iniciativa>> _fetch() async {
    final res = await _db
        .from('iniciativas')
        .select()
        .eq('archivada', false)
        .order('created_at', ascending: false);
    return (res as List).map((e) => Iniciativa.fromMap(e)).toList();
  }

  Future<void> agregar(Iniciativa ini) async {
    await _db.from('iniciativas').insert(ini.toMap());
    ref.invalidateSelf();
  }

  Future<void> archivar(String id) async {
    await _db.from('iniciativas').update({'archivada': true}).eq('id', id);
    ref.invalidateSelf();
  }

  Future<void> actualizar(String id, int importancia, int gobernabilidad) async {
    await _db.from('iniciativas').update({
      'importancia':    importancia,
      'gobernabilidad': gobernabilidad,
    }).eq('id', id);
    ref.invalidateSelf();
  }
}
