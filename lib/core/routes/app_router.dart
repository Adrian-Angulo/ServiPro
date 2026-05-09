import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/onboarding/onboarding_provider.dart';
import 'package:servi_pro/features/onboarding/onboarding_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingNotifier).value;

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      
      if (onboardingState == false) {
        return '/onboarding';
      }

      return '/login';
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.build_circle_outlined,
                    size: 72,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ServiPro',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
});
