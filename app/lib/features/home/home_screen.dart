import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../iniciativas/screens/iniciativas_screen.dart';
import '../matrix/screens/matrix_screen.dart';
import '../planes/screens/planes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    IniciativasScreen(),
    MatrixScreen(),
    PlanesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: _screens[_index],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          backgroundColor: AppColors.bg,
          selectedItemColor: AppColors.indigoL,
          unselectedItemColor: AppColors.text3,
          selectedLabelStyle: const TextStyle(fontFamily: 'Sora', fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Sora', fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline, size: 22),
              activeIcon: Icon(Icons.lightbulb, size: 22),
              label: 'Iniciativas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined, size: 22),
              activeIcon: Icon(Icons.grid_view, size: 22),
              label: 'Matriz IGO',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined, size: 22),
              activeIcon: Icon(Icons.task_alt, size: 22),
              label: 'Planes',
            ),
          ],
        ),
      ),
    );
  }
}
