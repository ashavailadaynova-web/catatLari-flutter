import 'package:flutter/material.dart';
import '../models/database_helper.dart';
import '../models/run_model.dart';

class RunViewModel extends ChangeNotifier {
  List<RunModel> _runs = [];
  List<RunModel> get runs => _runs;

  RunViewModel() {
    fetchRuns();
  }

  // Tarik data dari SQLite
  Future<void> fetchRuns() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'runs',
        orderBy: 'id DESC',
      );

      _runs = maps.map((map) => RunModel.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetch runs: $e");
    }
  }

  // Tambah data baru
  Future<void> addRun(RunModel run) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('runs', run.toMap());
    await fetchRuns(); // Langsung update list di UI
  }

  // Update data lama
  Future<void> updateRun(RunModel run) async {
    if (run.id == null) return;
    final db = await DatabaseHelper.instance.database;
    await db.update('runs', run.toMap(), where: 'id = ?', whereArgs: [run.id]);
    await fetchRuns();
  }

  // Hapus data
  Future<void> deleteRun(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('runs', where: 'id = ?', whereArgs: [id]);
    await fetchRuns();
  }

  // Bonus: Hitung total jarak untuk tampilan di Box Hijau Home
  double get totalDistance {
    return _runs.fold(0.0, (sum, item) => sum + item.distance);
  }
}
