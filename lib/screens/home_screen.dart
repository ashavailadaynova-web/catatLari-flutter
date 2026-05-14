import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/run_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'add_run_screen.dart';
import 'edit_run_screen.dart';
import '../models/run_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan data secara real-time
    final runProvider = context.watch<RunViewModel>();
    final profileProvider = context.watch<ProfileViewModel>();

    final List<RunModel> runs = runProvider.runs;
    final bool hasData = runs.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama User Dinamis dari ProfileViewModel
                  Text(
                    profileProvider.userName,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ini ringkasan larimu minggu ini.',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Card JARAK TEMPUH (Dinamis menggunakan getter totalDistance)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL JARAK TEMPUH',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              runProvider.totalDistance.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'KM',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFCCFF00),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hasData
                              ? 'Bagus! Kamu sudah lari ${runs.length} kali.'
                              : 'Yuk mulai lari pertamamu!',
                          style: TextStyle(
                            color: Colors.grey[400],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // AKTIVITAS TERBARU
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AKTIVITAS TERBARU',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // List Aktivitas (Dinamis: Jika ada data, tampilkan semua pakai ListView)
                  hasData
                      ? ListView.builder(
                          shrinkWrap:
                              true, // Biar gak error di dalam ScrollView
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: runs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildRunCard(context, runs[index]),
                            );
                          },
                        )
                      : _buildEmptyState(),
                ],
              ),
            ),

            // FAB (Floating Action Button)
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddRunScreen()),
                  );
                },
                backgroundColor: const Color(0xFFCCFF00),
                child: const Icon(Icons.add, color: Colors.black, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Card Lari Dinamis
  Widget _buildRunCard(BuildContext context, RunModel run) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                run.date, // DATA ASLI DARI DB
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              GestureDetector(
                onTap: () => _showDeleteDialog(context, run),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red[300], // Merah biar jelas itu tombol hapus
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jarak Lari',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${run.distance} KM', // DATA ASLI DARI DB
                    style: const TextStyle(
                      color: Color(0xFFCCFF00),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Durasi',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    run.duration, // DATA ASLI DARI DB
                    style: const TextStyle(
                      color: Color(0xFFCCFF00),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditRunScreen(run: run)),
                  );
                },
                child: const Text(
                  'EDIT',
                  style: TextStyle(
                    color: Color(0xFFCCFF00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.directions_run, size: 48, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'Belum ada aktivitas',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Klik tombol + untuk catat lari pertamamu',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, RunModel run) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Hapus Aktivitas?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Data lari tanggal ${run.date} akan dihapus permanen.',
            style: TextStyle(color: Colors.grey[400]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('BATAL', style: TextStyle(color: Colors.grey[500])),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // PASTIKAN ID TIDAK NULL
                if (run.id != null) {
                  context.read<RunViewModel>().deleteRun(run.id!);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aktivitas berhasil dihapus!'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
