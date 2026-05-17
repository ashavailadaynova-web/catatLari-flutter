import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  int _currentIndex = 0; // Pastikan nilai awalnya 0

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Kamu bisa panggil fungsi ini saat logout jika memilih cara manual
  void resetIndex() {
    _currentIndex = 0;
    notifyListeners();
  }
}
