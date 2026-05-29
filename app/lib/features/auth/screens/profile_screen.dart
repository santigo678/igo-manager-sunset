import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _empresaCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();

  String? _sector;
  String? _tamano;
  String? _edad;
  String? _genero;
  bool _aceptaHabeas = false;
  bool _loading = false;
  String? _error;

  static const _sectores = [
    'Agro','Calzado/Moda','Tecnología','Servicios',
    'Comercio','Salud','Turismo','Educación','Otro'
  ];
  static const _tamanos = ['Idea','Micro','Pequeña','Mediana','Grande'];
  static const _edades  = ['18-25','26-35','36-45','46-55','+56'];
  static const _generos = ['Masculino','Femenino','Otro'];

  Future<void> _guardar() async {
    if (!_aceptaHabeas) {
      setState(() => _error = 'Debes aceptar la política de tratamiento de datos.');
      return;
    }
    if (_sector == null || _tamano == null || _edad == null || _genero == null) {
      setState(() => _error = 'Por favor completa todos los campos.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final user = Supabase.instance.client.auth.currentUser!;
      await Supabase.instance.client.from('profiles').upsert({
        'id':               user.id,
        'nombre':           user.userMetadata?['nombre'] ?? '',
        'nombre_empresa':   _empresaCtrl.text.trim(),
        'celular':          _celularCtrl.text.trim(),
        'sector':           _sector,
        'tamano_empresa':   _tamano,
        'rango_edad':       _edad,
        'genero':           _genero,
        'acepta_habeas_data': _aceptaHabeas,
      });
      if (mounted) context.go('/iniciativas');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _dropdown(String label, List<String> opciones, String? valor, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.text2, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: valor,
          dropdownColor: AppColors.bg2,
          style: const TextStyle(color: AppColors.text, fontSize: 14, fontFamily: 'Sora'),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border2, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border2, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.indigo, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          hint: Text('Seleccionar', style: TextStyle(color: AppColors.text3, fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.text2),
          items: opciones.map((o) => DropdownMenuItem(
            value: o,
            child: Text(o),
          )).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.text2, size: 18),
          onPressed: () => context.go('/register'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Perfil empresarial',
                style: TextStyle(color: AppColors.text, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Paso 2 de 2 — Solo lo pedimos una vez',
                style: TextStyle(color: AppColors.text2, fontSize: 13)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: Container(height: 3,
                  decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(width: 6),
                Expanded(child: Container(height: 3,
                  decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(2)))),
              ]),
              const SizedBox(height: 28),
              TextField(
                controller: _empresaCtrl,
                style: const TextStyle(color: AppColors.text),
                decoration: const InputDecoration(labelText: 'Nombre empresa / idea'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _celularCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.text),
                decoration: const InputDecoration(labelText: 'Celular'),
              ),
              const SizedBox(height: 16),
              _dropdown('Sector económico', _sectores, _sector,
                (v) => setState(() => _sector = v)),
              _dropdown('Tamaño de empresa', _tamanos, _tamano,
                (v) => setState(() => _tamano = v)),
              _dropdown('Rango de edad', _edades, _edad,
                (v) => setState(() => _edad = v)),
              _dropdown('Género', _generos, _genero,
                (v) => setState(() => _genero = v)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _aceptaHabeas,
                    activeColor: AppColors.indigo,
                    onChanged: (v) => setState(() => _aceptaHabeas = v ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Acepto la política de tratamiento de datos personales (Habeas Data) de Dinámica del Oriente S.A.S.',
                        style: const TextStyle(color: AppColors.text2, fontSize: 12, height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.coral.withOpacity(0.3), width: 0.5),
                  ),
                  child: Text(_error!,
                    style: const TextStyle(color: AppColors.coralL, fontSize: 13)),
                ),
              ],
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _loading ? null : _guardar,
                child: _loading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Comenzar →'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
