import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  String _userName = "Runner";
  String _location = "Indonesia";
  String? _photoPath; // Menampung path foto dalam bentuk String path lokal

  String get userName => _userName;
  String get location => _location;
  String? get photoPath => _photoPath; 

  // Mengambil data berdasarkan email user aktif
  Future<void> loadProfile(String? email) async {
    if (email == null || email.isEmpty) {
      clearProfile();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    
    _userName = prefs.getString('${email}_user_name') ?? email.split('@')[0];
    _location = prefs.getString('${email}_location') ?? "Indonesia";
    _photoPath = prefs.getString('${email}_photo_path'); // Ambil path foto akun ini
    
    notifyListeners(); 
  }

  // Memperbarui data (Nama, Lokasi, & Foto)
  Future<void> updateProfile(String? email, String newName, String newLocation, String? newPhotoPath) async {
    if (email == null || email.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('${email}_user_name', newName);
    await prefs.setString('${email}_location', newLocation);
    if (newPhotoPath != null) {
      await prefs.setString('${email}_photo_path', newPhotoPath);
    }

    _userName = newName;
    _location = newLocation;
    _photoPath = newPhotoPath ?? _photoPath;

    notifyListeners(); 
  }

  // Reset UI saat logout
  void clearProfile() {
    _userName = "Runner";
    _location = "Indonesia";
    _photoPath = null;
    notifyListeners();
  }
}