import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../iniciativas/models/iniciativa_model.dart';
import '../../iniciativas/providers/iniciativas_provider.dart';
import '../../planes/screens/planes_screen.dart';

class MatrixScreen extends ConsumerWidget {
  const MatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(iniciativasProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Matriz IGO')),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.indigo, strokeWidth: 2)),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: AppColors.coralL))),
        data: (lista) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('↑ Alta importancia',
                    style: TextStyle(color: AppColors.text3, fontSize: 11)),
                  const Text('Gobernabilidad →',
                    style: TextStyle(color: AppColors.text3, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _QuadBox(
                      cuadrante: 'ESTRATEGICO',
                      label: 'Estratégico',
                      sublabel: 'Busca aliados',
                      bgColor: const Color(0xFF0D1F1B),
                      borderColor: Color(0xFF1D9E75),
                      nameColor: AppColors.tealL,
                      dotColor: AppColors.teal,
                      items: lista.where((i) => i.cuadrante == 'ESTRATEGICO').toList(),
                      onTap: (ini) => _showDetail(context, ini),
                    ),
                    _QuadBox(
                      cuadrante: 'HACER_YA',
                      label: '¡Hacer ya!',
                      sublabel: 'Crear plan de acción',
                      bgColor: const Color(0xFF1A1B3A),
                      borderColor: AppColors.indigo,
                      nameColor: AppColors.indigoL,
                      dotColor: AppColors.indigo,
                      items: lista.where((i) => i.cuadrante == 'HACER_YA').toList(),
                      onTap: (ini) => _showDetail(context, ini),
                      showPlanBtn: true,
                    ),
                    _QuadBox(
                      cuadrante: 'DESCARTE',
                      label: 'Descarte',
                      sublabel: 'Eliminar / archivar',
                      bgColor: const Color(0xFF1E1208),
                      borderColor: AppColors.coral,
                      nameColor: AppColors.coralL,
                      dotColor: AppColors.coral,
                      items: lista.where((i) => i.cuadrante == 'DESCARTE').toList(),
                      onTap: (ini) => _showDetail(context, ini),
                    ),
                    _QuadBox(
                      cuadrante: 'RUTINA',
                      label: 'Rutina',
                      sublabel: 'Delegar',
                      bgColor: const Color(0xFF141414),
                      borderColor: AppColors.gray,
                      nameColor: AppColors.grayL,
                      dotColor: AppColors.gray,
                      items: lista.where((i) => i.cuadrante == 'RUTINA').toList(),
                      onTap: (ini) => _showDetail(context, ini),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('↓ Baja importancia',
                style: TextStyle(color: AppColors.text3, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Iniciativa ini) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ini.titulo,
              style: const TextStyle(
                color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700)),
            if (ini.descripcion != null && ini.descripcion!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(ini.descripcion!,
                style: const TextStyle(color: AppColors.text2, fontSize: 14)),
            ],
            const SizedBox(height: 16),
            Row(children: [
              _StatChip('Importancia', '${ini.importancia}', AppColors.indigoL),
              const SizedBox(width: 8),
              _StatChip('Gobernabilidad', '${ini.gobernabilidad}', AppColors.tealL),
            ]),
            const SizedBox(height: 20),
            if (ini.cuadrante == 'HACER_YA' || ini.cuadrante == 'ESTRATEGICO')
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PlanesScreen(iniciativa: ini)));
                },
                child: const Text('Crear plan de acción'),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuadBox extends StatelessWidget {
  final String cuadrante, label, sublabel;
  final Color bgColor, borderColor, nameColor, dotColor;
  final List<Iniciativa> items;
  final void Function(Iniciativa) onTap;
  final bool showPlanBtn;

  const _QuadBox({
    required this.cuadrante,
    required this.label,
    required this.sublabel,
    required this.bgColor,
    required this.borderColor,
    required this.nameColor,
    required this.dotColor,
    required this.items,
    required this.onTap,
    this.showPlanBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.4), width: 0.5),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: TextStyle(color: nameColor, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(sublabel,
            style: TextStyle(color: nameColor.withOpacity(0.6), fontSize: 10)),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
              ? Center(child: Text('Sin iniciativas',
                  style: TextStyle(color: dotColor.withOpacity(0.3), fontSize: 10)))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => onTap(items[i]),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: dotColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(items[i].titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: nameColor, fontSize: 10, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Column(children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
