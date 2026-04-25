import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_theme.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/onboarding/providers/onboarding_seen_provider.dart';
import 'package:servi_pro/features/onboarding/screens/onboarding_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirstLaunch = ref.watch(isFirstLaunchProvider);

    return MaterialApp(
      title: 'ServiPro',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: isFirstLaunch.when(
        loading: () => const Scaffold(
          backgroundColor: AppColors.backgroundSoft,
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ),
        error: (_, __) => const LoginScreen(),
        data: (isFirst) =>
            isFirst ? const OnboardingScreen() : const LoginScreen(),
      ),
    );
  }
}

