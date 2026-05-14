import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Import provider
import '../viewmodels/main_viewmodel.dart'; // 2. Import ViewModel
import 'home_screen.dart';
import 'profile_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Ambil data dari ViewModel
    final mainVM = context.watch<MainViewModel>();
    final screens = [const HomeScreen(), const ProfileScreen()];

    return Scaffold(
      body: screens[mainVM.currentIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        currentIndex: mainVM.currentIndex,
        onTap: (index) {
          // 4. Update index via ViewModel
          context.read<MainViewModel>().setIndex(index);
        },
        selectedItemColor: const Color(0xFFCCFF00),
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
