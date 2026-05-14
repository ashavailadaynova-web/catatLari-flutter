import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'profile_viewmodel.dart'; // Pastikan import ini benar sesuai folder kamu

class AuthViewModel extends ChangeNotifier {
  String? currentUserEmail;

  // Fungsi Login yang sudah diperbaiki
  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    // 1. Simulasi: Anggap login berhasil dan kita dapat data nama dari "database"
    // Karena ini simulasi, kita ambil nama dari depan email saja
    String loggedInUserName = email.split('@')[0];

    try {
      // 2. SIMPAN KE SHARED PREFERENCES (Biar awet gak hilang pas restart)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', loggedInUserName);
      await prefs.setString('user_email', email);

      currentUserEmail = email;

      // 3. UPDATE PROFILE VIEW MODEL SEKARANG JUGA
      // Ini kuncinya supaya Home langsung berubah namanya tanpa nunggu restart
      if (context.mounted) {
        Provider.of<ProfileViewModel>(context, listen: false).loadProfile();
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Login Error: $e");
      return false;
    }
  }

  // Tambahkan fungsi Logout sekalian biar lengkap
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data
    currentUserEmail = null;

    if (context.mounted) {
      Provider.of<ProfileViewModel>(context, listen: false).loadProfile();
    }
    notifyListeners();
  }
}
