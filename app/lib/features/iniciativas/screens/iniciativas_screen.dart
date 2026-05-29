import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../models/iniciativa_model.dart';
import '../providers/iniciativas_provider.dart';
import 'crear_iniciativa_screen.dart';

class IniciativasScreen extends ConsumerWidget {
  const IniciativasScreen({super.key});

  Color _accentColor(String cuadrante) => switch (cuadrante) {
    'HACER_YA'    => AppColors.indigo,
    'ESTRATEGICO' => AppColors.teal,
    'RUTINA'      => AppColors.gray,
    _             => AppColors.coral,
  };

  Color _tagBg(String cuadrante) => switch (cuadrante) {
    'HACER_YA'    => AppColors.indigo.withOpacity(0.13),
    'ESTRATEGICO' => AppColors.teal.withOpacity(0.12),
    'RUTINA'      => Colors.white.withOpacity(0.06),
    _             => AppColors.coral.withOpacity(0.13),
  };

  Color _tagColor(String cuadrante) => switch (cuadrante) {
    'HACER_YA'    => AppColors.indigoL,
    'ESTRATEGICO' => AppColors.tealL,
    'RUTINA'      => AppColors.text2,
    _             => AppColors.coralL,
  };

  String _tagLabel(String cuadrante) => switch (cuadrante) {
    'HACER_YA'    => '¡Hacer ya!',
    'ESTRATEGICO' => 'Estratégico',
    'RUTINA'      => 'Rutina',
    _             => 'Descarte',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(iniciativasProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Mis iniciativas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: AppColors.text2, size: 20),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const CrearIniciativaScreen())),
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.indigo, strokeWidth: 2)),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: AppColors.coralL))),
        data: (lista) {
          if (lista.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.text3, size: 48),
                  const SizedBox(height: 16),
                  const Text('Sin iniciativas aún',
                    style: TextStyle(color: AppColors.text2, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('Toca + para agregar tu primera idea',
                    style: TextStyle(color: AppColors.text3, fontSize: 13)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (_, i) => _IniCard(
              ini: lista[i],
              accentColor: _accentColor(lista[i].cuadrante),
              tagBg:       _tagBg(lista[i].cuadrante),
              tagColor:    _tagColor(lista[i].cuadrante),
              tagLabel:    _tagLabel(lista[i].cuadrante),
              onArchivar: () => ref.read(iniciativasProvider.notifier).archivar(lista[i].id),
            ),
          );
        },
      ),
    );
  }
}

class _IniCard extends StatelessWidget {
  final Iniciativa ini;
  final Color accentColor, tagBg, tagColor;
  final String tagLabel;
  final VoidCallback onArchivar;

  const _IniCard({
    required this.ini,
    required this.accentColor,
    required this.tagBg,
    required this.tagColor,
    required this.tagLabel,
    required this.onArchivar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 3, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ini.titulo,
                      style: const TextStyle(
                        color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('Imp: ${ini.importancia} · Gob: ${ini.gobernabilidad}',
                      style: const TextStyle(color: AppColors.text3, fontSize: 12)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(tagLabel,
                        style: TextStyle(color: tagColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.archive_outlined, color: AppColors.text3, size: 18),
              onPressed: onArchivar,
            ),
          ],
        ),
      ),
    );
  }
}
