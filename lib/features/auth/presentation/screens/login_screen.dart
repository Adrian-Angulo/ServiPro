import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/widgets/login/login_footer.dart';
import 'package:servi_pro/features/auth/presentation/widgets/login/login_form.dart';
import 'package:servi_pro/features/auth/presentation/widgets/login/login_header.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              LoginHeader(),
              SizedBox(height: 32),
              LoginForm(),
              SizedBox(height: 24),
              LoginFooter(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
