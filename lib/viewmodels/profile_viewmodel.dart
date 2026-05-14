import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  String _userName = "Runner";
  String _location = "Indonesia"; // Tambahkan ini biar error 'location' hilang

  String get userName => _userName;
  String get location => _location; // Getter untuk location

  ProfileViewModel() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? "Runner";
    _location = prefs.getString('location') ?? "Indonesia";
    notifyListeners();
  }

  // Tambahkan fungsi ini biar error 'updateProfile' di Register & Edit Profile hilang
  Future<void> updateProfile(String newName, String newLocation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
    await prefs.setString('location', newLocation);

    _userName = newName;
    _location = newLocation;
    notifyListeners(); // Biar nama di Home langsung berubah
  }
}
