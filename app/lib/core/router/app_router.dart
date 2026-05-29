import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/profile_screen.dart';
import '../../features/home/home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuth  = session != null;
      final isAuthRoute = ['/', '/login', '/register'].contains(state.matchedLocation);
      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth  && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/',         builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/login',    builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/profile',  builder: (c, s) => const ProfileScreen()),
      GoRoute(path: '/home',     builder: (c, s) => const HomeScreen()),
    ],
  );
});
