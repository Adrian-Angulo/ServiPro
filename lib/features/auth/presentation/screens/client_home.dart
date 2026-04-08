import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/requests/presentation/screens/create_request_screen.dart';

class ClientHome extends ConsumerStatefulWidget {
  const ClientHome({super.key});

  @override
  ConsumerState<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends ConsumerState<ClientHome> {
  int _selectedIndex = 0;
  late final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = const [
    Center(child: HomeClientScreen()),
    Center(child: Text("Solicitudes")),
    Center(child: Text("Trabajadores")),
    Center(child: Text("Perfil")),
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

class HomeClientScreen extends StatelessWidget {
  const HomeClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: ListView.separated(
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(49, 155, 148, 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "MD",
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.15,
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Marta Rosero",
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.15,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Electricista experto",
                                style: GoogleFonts.nunito(
                                  fontSize: 14,

                                  letterSpacing: 0.15,
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    130,
                                    130,
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Icon(
                                    size: 20,
                                    Icons.star_rate_rounded,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    "4.9",
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.15,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.md),
                                  Text(
                                    "49 trabajos",
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,

                                      letterSpacing: 0.15,
                                      color: const Color.fromARGB(
                                        255,
                                        130,
                                        130,
                                        130,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(158, 158, 158, 0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.messenger,
                            color: const Color.fromARGB(255, 20, 142, 243),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSpacing.xs),
                itemCount: 5,
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
