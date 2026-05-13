import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';

/// Widget que muestra el avatar del cliente con iniciales y botón de cámara
class ClientAvatarWidget extends StatelessWidget {
  final String nombre;
  final VoidCallback? onCameraPressed;

  const ClientAvatarWidget({
    super.key,
    required this.nombre,
    this.onCameraPressed,
  });

  /// Obtiene las iniciales del nombre del cliente
  String _getInitials(String nombre) {
    final parts = nombre.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nombre.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar circular con iniciales
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _getInitials(nombre),
              style: GoogleFonts.nunito(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 0.15,
              ),
            ),
          ),
        ),

        // Botón de cámara (opcional)
        if (onCameraPressed != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onCameraPressed,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
