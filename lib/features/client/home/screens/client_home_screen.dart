import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/features/client/home/widgets/home_action_cards.dart';
import 'package:servi_pro/features/client/home/widgets/home_header.dart';
import 'package:servi_pro/features/client/home/widgets/recommended_workers_section.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Header con ubicación y avatar
              HomeHeader(userName: 'Alejandro'),
              SizedBox(height: 24),

              // Saludo
              Text(
                '¡Hola, Alejandro! 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '¿Qué servicio necesitas hoy?',
                style: TextStyle(fontSize: 14, color: AppColors.grey500),
              ),
              SizedBox(height: 24),

              // Tarjetas de acción
              HomeActionCards(),
              SizedBox(height: 28),

              // Trabajadores recomendados
              RecommendedWorkersSection(),
            ],
          ),
        ),
      ),

      // Bottom nav
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Mis solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline_rounded), label: 'Trabajadores'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}
