import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/routes/app_router.dart';
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
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: "ServiPro",
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );

    /*     return MaterialApp(
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
    ); */
  }
}
