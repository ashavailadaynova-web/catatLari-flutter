import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'main_viewmodel.dart'; 
import '../models/database_helper.dart'; 
import 'profile_viewmodel.dart';
import 'run_viewmodel.dart'; 

class AuthViewModel extends ChangeNotifier {
  String? currentUserEmail;

  // 1. FUNGSI REGISTRASI
  Future<bool> register(String name, String email, String password) async {
    try {
      await DatabaseHelper.registerUser(name, email, password);
      return true;
    } catch (e) {
      debugPrint("Register Error: $e");
      return false;
    }
  }

  // 2. FUNGSI LOGIN
  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final user = await DatabaseHelper.checkLogin(email, password);

      if (user == null) {
        return false; 
      }

      String loggedInUserName = user['name'] ?? email.split('@')[0];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', loggedInUserName);
      await prefs.setString('user_email', email);
      await prefs.setBool('is_logged_in', true);

      currentUserEmail = email;

      // SINKRONISASI PROFILE SAAT LOGIN
      if (context.mounted) {
        await Provider.of<ProfileViewModel>(context, listen: false).loadProfile(currentUserEmail);  
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Login Error: $e");
      return false;
    }
  }

  // 3. FUNGSI LOGOUT
  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('is_logged_in', false);
      await prefs.remove('user_email');
      await prefs.remove('user_name');

      currentUserEmail = null;

      if (context.mounted) {
        // Bersihkan data profil (diisi null agar siap untuk user baru)
        await Provider.of<ProfileViewModel>(context, listen: false).loadProfile(null);
        
        // Bersihkan data riwayat lari di state management
        Provider.of<RunViewModel>(context, listen: false).clearRuns();
        
        // Reset navigasi halaman utama ke index 0 (Halaman Home)
        Provider.of<MainViewModel>(context, listen: false).setIndex(0);
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }
}