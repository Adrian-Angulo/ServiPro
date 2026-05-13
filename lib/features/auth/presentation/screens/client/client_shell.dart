import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/client/perfil_cliente.dart';
import 'package:servi_pro/features/auth/presentation/screens/client/trabajadores_screen.dart';
import 'package:servi_pro/features/auth/presentation/screens/client/worker_perfil_simple_view.dart';
import 'package:servi_pro/features/auth/presentation/widgets/cards/worker_card.dart';
import 'package:servi_pro/features/requests/presentation/screens/client/create_request_screen.dart';
import 'package:servi_pro/features/requests/presentation/screens/client/mis_solicitudes_screen.dart';

class ClientShell extends ConsumerStatefulWidget {
  const ClientShell({super.key});

  @override
  ConsumerState<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends ConsumerState<ClientShell> {
  int _selectedIndex = 0;
  late final PageController _pageController = PageController(initialPage: 0);

  late final List<Widget> _pages = [
    HomeClientScreen(onTabTapped: _onTabTapped),
    MisSolicitudesScreen(),
    TrabajadoresScreen(),
    PerfilCliente(),
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Solicitudes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Trabajadores",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}

class HomeClientScreen extends ConsumerWidget {
  final Function(int)? onTabTapped;

  const HomeClientScreen({super.key, this.onTabTapped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedWorkers = ref.watch(recommendedWorkersProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.screenHorizontal),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text("ServiPro", style: AppTypography.headlineLarge),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  "Encuentra al profesional ideal para tu hogar",
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "Rápido, seguro y cerca de ti 📍",
                  style: AppTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            CardWidgetRequest(
              icon: Icons.accessibility_outlined,
              iconBackgroundColor: const Color.fromARGB(255, 240, 150, 97),
              cardColor: AppColors.accent,
              title: 'Solicitar un servicio',
              subtitle: 'Publica tu necesidad ahora',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateRequestScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.xs),
            CardWidgetRequest(
              icon: Icons.group,
              iconBackgroundColor: const Color.fromARGB(255, 105, 164, 160),
              cardColor: AppColors.primary,
              title: 'Ver trabajadores',
              subtitle: 'Explora los expertos locales',
              onTap: () {
                onTabTapped?.call(2);
              },
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              "Trabajadores recomendados",
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.15,
                color: Colors.black,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Expanded(
              child: recommendedWorkers.when(
                // Estado: Cargando
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Cargando trabajadores...',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                          letterSpacing: 0.15,
                        ),
                      ),
                    ],
                  ),
                ),

                // Estado: Error
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Error al cargar trabajadores',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        error.toString(),
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                          letterSpacing: 0.15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Estado: Datos cargados
                data: (workers) {
                  // Lista vacía
                  if (workers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No hay trabajadores disponibles',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 0.15,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Vuelve más tarde',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey[600],
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Lista con trabajadores
                  return ListView.separated(
                    itemCount: workers.length,
                    itemBuilder: (context, index) {
                      final worker = workers[index];
                      return WorkerCard(
                        trabajador: worker,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkerPerfilSimpleView(workerId: worker.id),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.xs),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidgetRequest extends StatelessWidget {
  const CardWidgetRequest({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.cardColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color cardColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: const Color.fromARGB(255, 244, 176, 137),
      elevation: 4,
      surfaceTintColor: Colors.orange,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          title: Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.15,
              color: AppColors.surface,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.nunito(
              fontSize: 14,
              letterSpacing: 0.15,
              color: AppColors.grey100,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
