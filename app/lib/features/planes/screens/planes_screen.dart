import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../iniciativas/models/iniciativa_model.dart';
import '../models/plan_model.dart';
import '../providers/planes_provider.dart';

class PlanesScreen extends ConsumerStatefulWidget {
  final Iniciativa? iniciativa;
  const PlanesScreen({super.key, this.iniciativa});
  @override
  ConsumerState<PlanesScreen> createState() => _PlanesScreenState();
}

class _PlanesScreenState extends ConsumerState<PlanesScreen> {
  final _aliadosCtrl      = TextEditingController();
  final _presupuestoCtrl  = TextEditingController();
  DateTime? _fechaLimite;
  String _estado = 'Pendiente';
  bool _loading  = false;

  static const _estados = ['Pendiente', 'En Proceso', 'Terminado', 'Abortado'];

  Color _estadoColor(String e) => switch (e) {
    'Terminado'  => AppColors.teal,
    'En Proceso' => AppColors.indigo,
    'Abortado'   => AppColors.coral,
    _            => AppColors.gray,
  };

  Future<void> _pickFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.indigo,
            surface: AppColors.bg2,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _fechaLimite = picked);
  }

  Future<void> _guardar() async {
    setState(() => _loading = true);
    final userId = Supabase.instance.client.auth.currentUser!.id;
    await ref.read(planesProvider.notifier).agregar(Plan(
      id:           '',
      iniciativaId: widget.iniciativa!.id,
      userId:       userId,
      fechaLimite:  _fechaLimite,
      presupuesto:  double.tryParse(_presupuestoCtrl.text),
      aliados:      _aliadosCtrl.text.trim(),
      estado:       _estado,
      createdAt:    DateTime.now(),
    ));
    if (mounted) Navigator.pop(context);
  }

  int get _progreso {
    final planes = ref.watch(planesProvider).asData?.value ?? [];
    if (planes.isEmpty) return 0;
    final terminados = planes.where((p) => p.estado == 'Terminado').length;
    return ((terminados / planes.length) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.iniciativa != null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(esNuevo ? 'Crear plan' : 'Mis planes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.text2, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: esNuevo ? _buildForm() : _buildLista(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.indigo.withOpacity(0.3), width: 0.5),
            ),
            child: Row(children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.indigoL, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.iniciativa!.titulo,
                style: const TextStyle(color: AppColors.indigoL, fontSize: 13, fontWeight: FontWeight.w600))),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Fecha límite',
            style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickFecha,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border2, width: 0.5),
              ),
              child: Row(children: [
                const Icon(Icons.calendar_today_outlined, color: AppColors.indigoL, size: 18),
                const SizedBox(width: 10),
                Text(
                  _fechaLimite != null
                    ? '${_fechaLimite!.day}/${_fechaLimite!.month}/${_fechaLimite!.year}'
                    : 'Seleccionar fecha',
                  style: TextStyle(
                    color: _fechaLimite != null ? AppColors.text : AppColors.text3,
                    fontSize: 14),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _presupuestoCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.text),
            decoration: const InputDecoration(
              labelText: 'Presupuesto estimado (COP)',
              prefixIcon: Icon(Icons.attach_money, color: AppColors.text3, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _aliadosCtrl,
            style: const TextStyle(color: AppColors.text),
            decoration: const InputDecoration(
              labelText: 'Aliados / responsables',
              prefixIcon: Icon(Icons.people_outline, color: AppColors.text3, size: 20),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Estado inicial',
            style: TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _estados.map((e) {
              final selected = _estado == e;
              final color = _estadoColor(e);
              return GestureDetector(
                onTap: () => setState(() => _estado = e),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? color.withOpacity(0.15) : AppColors.surface,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: selected ? color.withOpacity(0.5) : AppColors.border2,
                      width: selected ? 1 : 0.5),
                  ),
                  child: Text(e,
                    style: TextStyle(
                      color: selected ? color : AppColors.text2,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _loading ? null : _guardar,
            child: _loading
              ? const SizedBox(height: 20, width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Guardar plan'),
          ),
        ],
      ),
    );
  }

  Widget _buildLista() {
    final state = ref.watch(planesProvider);
    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.indigo, strokeWidth: 2)),
      error: (e, _) => Center(
        child: Text('Error: $e', style: const TextStyle(color: AppColors.coralL))),
      data: (planes) {
        if (planes.isEmpty) {
          return const Center(
            child: Text('Sin planes aún',
              style: TextStyle(color: AppColors.text2)));
        }
        final progreso = planes.isEmpty ? 0
          : ((planes.where((p) => p.estado == 'Terminado').length / planes.length) * 100).round();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Progreso global',
                    style: TextStyle(color: AppColors.text2, fontSize: 13)),
                  Text('$progreso%',
                    style: const TextStyle(color: AppColors.indigoL, fontSize: 13, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progreso / 100,
                    backgroundColor: AppColors.surface2,
                    valueColor: const AlwaysStoppedAnimation(AppColors.indigo),
                    minHeight: 6,
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: planes.length,
                itemBuilder: (_, i) {
                  final p = planes[i];
                  final color = _estadoColor(p.estado);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: Text(p.iniciativaId,
                            style: const TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(p.estado,
                              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                        if (p.fechaLimite != null) ...[
                          const SizedBox(height: 4),
                          Text('Vence: ${p.fechaLimite!.day}/${p.fechaLimite!.month}/${p.fechaLimite!.year}',
                            style: const TextStyle(color: AppColors.text3, fontSize: 11)),
                        ],
                        const SizedBox(height: 10),
                        Wrap(spacing: 6, children: _estados.map((e) {
                          final sel = p.estado == e;
                          final c = _estadoColor(e);
                          return GestureDetector(
                            onTap: () => ref.read(planesProvider.notifier).actualizarEstado(p.id, e),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: sel ? c.withOpacity(0.15) : AppColors.surface2,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: sel ? c.withOpacity(0.4) : AppColors.border2, width: 0.5),
                              ),
                              child: Text(e,
                                style: TextStyle(color: sel ? c : AppColors.text3, fontSize: 10)),
                            ),
                          );
                        }).toList()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
