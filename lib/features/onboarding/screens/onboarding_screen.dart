import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/screens/login_screen.dart';
import 'package:servi_pro/features/onboarding/providers/onboarding_provider.dart';
import 'package:servi_pro/features/onboarding/widgets/onboarding_page.dart';
import 'package:servi_pro/features/onboarding/widgets/page_indicator.dart';

const _pages = [
  OnboardingData(
    title: 'Cuando algo se daña,\nsaber a quién llamar',
    titleHighlight: 'lo cambia todo.',
    description: 'Encuentra plomeros, electricistas y expertos\nlocales en ',
    descriptionLink: 'Pasto',
    descriptionEnd: ' de manera rápida y\nsegura.',
    badge1Icon: Icons.verified_rounded,
    badge1Label: 'Garantizado',
    badge2Icon: Icons.location_on_rounded,
    badge2Label: 'Cerca de ti',
  ),
  OnboardingData(
    title: 'Agenda en minutos,\nsin llamadas',
    titleHighlight: 'sin complicaciones.',
    description: 'Solicita el servicio que necesitas y recibe\nconfirmación al instante.',
    descriptionLink: '',
    descriptionEnd: '',
    badge1Icon: Icons.calendar_today_rounded,
    badge1Label: 'Fácil agenda',
    badge2Icon: Icons.flash_on_rounded,
    badge2Label: 'Rápido',
  ),
  OnboardingData(
    title: 'Profesionales\nverificados,',
    titleHighlight: 'resultados reales.',
    description: 'Todos nuestros expertos pasan por un proceso\nde verificación para tu tranquilidad.',
    descriptionLink: '',
    descriptionEnd: '',
    badge1Icon: Icons.star_rounded,
    badge1Label: 'Calificados',
    badge2Icon: Icons.shield_rounded,
    badge2Label: 'Seguros',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(int currentPage) {
    if (currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => ref.read(onboardingProvider.notifier).setPage(i),
                itemBuilder: (_, i) => OnboardingPage(data: _pages[i]),
              ),
            ),
            PageIndicator(count: _pages.length, current: currentPage),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => _next(currentPage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    elevation: 0,
                  ),
                  child: Text(
                    currentPage < _pages.length - 1 ? 'Siguiente →' : 'Empezar →',
                    style: AppTypography.labelLarge.copyWith(color: AppColors.onPrimary, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_rounded, size: 14, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  'PASTO, NARIÑO',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.grey500, letterSpacing: 1.2),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
