import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email:    _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      if (mounted) context.go('/iniciativas');
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: AppColors.violet,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.violet.withOpacity(0.18),
                      blurRadius: 12,
                      offset: Offset(0,6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('I', style: TextStyle(color: Colors.white, fontSiz
e: 26, fontWeight: FontWeight.w800)),
                ),
              ),
                  child: Text('I', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Bienvenido',
                style: TextStyle(color: AppColors.text, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Inicia sesión para continuar',
                style: TextStyle(color: AppColors.text2, fontSize: 14)),
              const SizedBox(height: 36),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.text),
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.mail_outline, color: AppColors.text3, size: 20),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                style: const TextStyle(color: AppColors.text),
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.text3, size: 20),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.coral.withOpacity(0.3), width: 0.5),
                  ),
                  child: Text(_error!,
                    style: const TextStyle(color: AppColors.coralL, fontSize: 13)),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: AppColors.mint, stro
keWidth: 2))
                  : const Text('Iniciar sesión'),
              ),
                  : const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () => context.go('/register'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: AppColors.text,
                  side: const BorderSide(color: AppColors.border2, width: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
