import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:servi_pro/core/domain/enums/rol.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/client/client_shell.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/auth/presentation/screens/restar_password/forgot_password_screen.dart';
import 'package:servi_pro/features/auth/presentation/screens/worker/worker_shell.dart';
import 'package:servi_pro/features/onboarding/onboarding_provider.dart';
import 'package:servi_pro/features/onboarding/onboarding_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingNotifier).value;
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
     redirect: (context, state) {
      if (onboardingState == false) {
        return '/onboarding';
      }
      if (auth.isLoading) return '/splash';
      if (auth.value == null) return '/login';

      if (auth.value!.rol == Rol.trabajador) return '/worker';
      if (auth.value!.rol == Rol.cliente) return '/cliente';

      return '/login';
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/worker', builder: (context, state) => WorkerShell()),
      GoRoute(path: '/cliente', builder: (context, state) => ClientShell()),
      GoRoute(path: '/reset-password', builder: (context, state) => ForgotPasswordScreen()),
      GoRoute(
        path: '/splash',
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(color: AppColors.background),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/logo.png", width: 120, height: 120),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Servi',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pro',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.xxl),
                  CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
});
