import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plan_model.dart';

final planesProvider =
    AsyncNotifierProvider<PlanesNotifier, List<Plan>>(PlanesNotifier.new);

class PlanesNotifier extends AsyncNotifier<List<Plan>> {
  final _db = Supabase.instance.client;

  @override
  Future<List<Plan>> build() => _fetch();

  Future<List<Plan>> _fetch() async {
    final res = await _db
        .from('planes')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((e) => Plan.fromMap(e)).toList();
  }

  Future<void> agregar(Plan plan) async {
    await _db.from('planes').insert(plan.toMap());
    ref.invalidateSelf();
  }

  Future<void> actualizarEstado(String id, String estado) async {
    await _db.from('planes').update({'estado': estado}).eq('id', id);
    ref.invalidateSelf();
  }
}
