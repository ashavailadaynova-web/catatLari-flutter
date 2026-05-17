import 'package:flutter/material.dart';
import '../models/database_helper.dart';
import '../models/run_model.dart';

class RunViewModel extends ChangeNotifier {
  List<RunModel> _runs = [];
  List<RunModel> get runs => _runs;

  // Menyimpan email user aktif di dalam ViewModel agar fungsi add/update/delete tahu milik siapa data tersebut
  String? _currentUserEmail;

  // Tarik data dari SQLite KHUSUS milik user yang sedang aktif login
  Future<void> fetchRuns(String? userEmail) async {
    try {
      _currentUserEmail = userEmail; // Simpan email aktif ke state variabel lokal
      
      // Memanggil DatabaseHelper versi baru yang mengembalikan data ter-filter email
      _runs = await DatabaseHelper.instance.readAllRuns(userEmail);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetch runs: $e");
    }
  }

  // Tambah data baru terikat dengan email user aktif
  Future<void> addRun(RunModel run) async {
    try {
      // Memanggil DatabaseHelper versi baru dengan menyertakan email aktif
      await DatabaseHelper.instance.create(run, _currentUserEmail);
      await fetchRuns(_currentUserEmail); // Refresh data spesifik user ini langsung di UI
    } catch (e) {
      debugPrint("Error add run: $e");
    }
  }

  // Update data lama
  Future<void> updateRun(RunModel run) async {
    if (run.id == null) return;
    try {
      await DatabaseHelper.instance.update(run);
      await fetchRuns(_currentUserEmail); // Refresh data setelah update
    } catch (e) {
      debugPrint("Error update run: $e");
    }
  }

  // Hapus data lari
  Future<void> deleteRun(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);
      await fetchRuns(_currentUserEmail); // Refresh data setelah dihapus
    } catch (e) {
      debugPrint("Error delete run: $e");
    }
  }

  // Bersihkan data riwayat di UI saat logout dilakukan
  void clearRuns() {
    _runs = [];
    _currentUserEmail = null;
    notifyListeners();
  }

  // Hitung total jarak untuk tampilan di Box Hijau Home
  double get totalDistance {
    return _runs.fold(0.0, (sum, item) => sum + item.distance);
  }
}