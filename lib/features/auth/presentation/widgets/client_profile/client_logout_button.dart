import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';

/// Widget que muestra el botón de cerrar sesión con estado de carga
class ClientLogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const ClientLogoutButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red[700],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red[700], size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Cerrar sesión',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
