import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientHome extends ConsumerStatefulWidget {
  const ClientHome({super.key});

  @override
  ConsumerState<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends ConsumerState<ClientHome> {
  int _selectedIndex = 0;
  late final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = const [
    Center(child: Text("Home")),
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
