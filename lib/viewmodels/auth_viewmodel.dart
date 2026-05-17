import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'profile_viewmodel.dart';

class AuthViewModel extends ChangeNotifier {
  String? currentUserEmail;

  // LOGIN
  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      // AMBIL NAMA DARI EMAIL
      String loggedInUserName = email.split('@')[0];

      // SHARED PREFERENCES
      final prefs = await SharedPreferences.getInstance();

      // HAPUS DATA USER SEBELUMNYA
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('location');
      await prefs.remove('profile_image');

      // SIMPAN DATA USER BARU
      await prefs.setString('user_name', loggedInUserName);
      await prefs.setString('user_email', email);

      // STATUS LOGIN
      await prefs.setBool('is_logged_in', true);

      currentUserEmail = email;

      // REFRESH PROFILE VIEWMODEL
      if (context.mounted) {
        await Provider.of<ProfileViewModel>(
          context,
          listen: false,
        ).loadProfile();
      }

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("Login Error: $e");

      return false;
    }
  }

  // LOGOUT
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // HAPUS SEMUA DATA USER
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('location');
    await prefs.remove('profile_image');
    await prefs.remove('is_logged_in');

    currentUserEmail = null;

    // REFRESH PROFILE VIEWMODEL
    if (context.mounted) {
      await Provider.of<ProfileViewModel>(
        context,
        listen: false,
      ).loadProfile();
    }

    notifyListeners();
  }
}