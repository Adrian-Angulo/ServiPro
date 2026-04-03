import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/requests/presentation/screens/register_request_screen.dart';
import 'package:servi_pro/features/requests/presentation/screens/solicitudes_screen.dart';

class ClientHome extends ConsumerStatefulWidget {
  const ClientHome({super.key});

  @override
  ConsumerState<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends ConsumerState<ClientHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const Center(child: RegisterRequestScreen()),
      const Center(child: SolicitudesScreen()),
      const Center(child: Text("Trabajadores")),
      Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(authNotifierProvider.notifier).logout();
            Navigator.pushReplacement(
              context,
              DialogRoute(
                context: context,
                builder: (context) => LoginScreen(),
              ),
            );
          },
          child: Text("Cerrar sesion"),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Client Home")),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
