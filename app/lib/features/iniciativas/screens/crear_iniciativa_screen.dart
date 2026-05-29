import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../models/iniciativa_model.dart';
import '../providers/iniciativas_provider.dart';

class CrearIniciativaScreen extends ConsumerStatefulWidget {
  const CrearIniciativaScreen({super.key});
  @override
  ConsumerState<CrearIniciativaScreen> createState() => _CrearIniciativaScreenState();
}

class _CrearIniciativaScreenState extends ConsumerState<CrearIniciativaScreen> {
  final _tituloCtrl = TextEditingController();
  final _descCtrl   = TextEditingController();
  int _importancia    = 5;
  int _gobernabilidad = 5;
  bool _loading = false;

  String get _cuadrante {
    if (_importancia >= 5 && _gobernabilidad >= 5) return 'HACER_YA';
    if (_importancia >= 5 && _gobernabilidad < 5)  return 'ESTRATEGICO';
    if (_importancia < 5  && _gobernabilidad >= 5) return 'RUTINA';
    return 'DESCARTE';
  }

  String get _cuadranteLabel => switch (_cuadrante) {
    'HACER_YA'    => '¡Hacer ya!',
    'ESTRATEGICO' => 'Estratégico / Aliados',
    'RUTINA'      => 'Rutina — Delegar',
    _             => 'Descarte — Archivar',
  };

  Color get _cuadranteColor => switch (_cuadrante) {
    'HACER_YA'    => AppColors.indigoL,
    'ESTRATEGICO' => AppColors.tealL,
    'RUTINA'      => AppColors.text2,
    _             => AppColors.coralL,
  };

  Future<void> _guardar() async {
    if (_tituloCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final userId = Supabase.instance.client.auth.currentUser!.id;
    await ref.read(iniciativasProvider.notifier).agregar(Iniciativa(
      id:             '',
      userId:         userId,
      titulo:         _tituloCtrl.text.trim(),
      descripcion:    _descCtrl.text.trim(),
      importancia:    _importancia,
      gobernabilidad: _gobernabilidad,
      cuadrante:      _cuadrante,
      archivada:      false,
      createdAt:      DateTime.now(),
    ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Nueva iniciativa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.text2, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloCtrl,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Título de la iniciativa'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
            ),
            const SizedBox(height: 24),
            const Text('Importancia (eje Y)',
              style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(child: Slider(
                value: _importancia.toDouble(),
                min: 1, max: 10, divisions: 9,
                activeColor: AppColors.indigo,
                inactiveColor: AppColors.border2,
                onChanged: (v) => setState(() => _importancia = v.round()),
              )),
              SizedBox(width: 32,
                child: Text('$_importancia',
                  style: const TextStyle(color: AppColors.indigoL, fontSize: 16, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center)),
            ]),
            const SizedBox(height: 8),
            const Text('Gobernabilidad (eje X)',
              style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(child: Slider(
                value: _gobernabilidad.toDouble(),
                min: 1, max: 10, divisions: 9,
                activeColor: AppColors.indigo,
                inactiveColor: AppColors.border2,
                onChanged: (v) => setState(() => _gobernabilidad = v.round()),
              )),
              SizedBox(width: 32,
                child: Text('$_gobernabilidad',
                  style: const TextStyle(color: AppColors.indigoL, fontSize: 16, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center)),
            ]),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border2, width: 0.5),
              ),
              child: Column(children: [
                const Text('Cuadrante asignado',
                  style: TextStyle(color: AppColors.text3, fontSize: 11)),
                const SizedBox(height: 4),
                Text(_cuadranteLabel,
                  style: TextStyle(color: _cuadranteColor, fontSize: 15, fontWeight: FontWeight.w700)),
              ]),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _loading ? null : _guardar,
              child: _loading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Guardar iniciativa'),
            ),
          ],
        ),
      ),
    );
  }
}
