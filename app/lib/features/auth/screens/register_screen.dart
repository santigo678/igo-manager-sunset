import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nombreCtrl   = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    setState(() { _loading = true; _error = null; });
    try {
      await Supabase.instance.client.auth.signUp(
        email:    _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        data:     {'nombre': _nombreCtrl.text.trim()},
      );
      if (mounted) context.go('/profile');
    } on AuthException catch (e) {
      setState(() { _error = e.message; });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.text2, size: 18),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Crear cuenta',
                style: TextStyle(color: AppColors.text, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Paso 1 de 2 — Datos personales',
                style: TextStyle(color: AppColors.text2, fontSize: 13)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: Container(height: 4,
                  decoration: BoxDecoration(color: AppColors.violetL.withOpacity(0.9), borderRadius: BorderRadius.circular(4)))),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 4,
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)))),
              ]),
              const SizedBox(height: 28),
              TextField(
                controller: _nombreCtrl,
                style: const TextStyle(color: AppColors.text),
                decoration: const InputDecoration(labelText: 'Nombre completo'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.text),
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                style: const TextStyle(color: AppColors.text),
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.sunset.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.sunset.withOpacity(0.28), width: 0.6),
                  ),
                  child: Text(_error!, style: const TextStyle(color: AppColors.coralL, fontSize: 13)),
                ),
              ],
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _loading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violet,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: _loading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: AppColors.mint, strokeWidth: 2))
                  : const Text('Siguiente →'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
