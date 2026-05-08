import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_run_screen.dart';
import 'edit_run_screen.dart';
import 'package:catat_lari/models/run_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RunModel> runs = RunModel.dummyData; // Data dummy
    final bool hasData = runs.isNotEmpty; // true = ada data, false = kosong
    final userEmail = "rania@gmail.com"; // Nanti ambil dari SharedPrefs Tahap 3

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
                  // Email User
                  Text(
                    userEmail,
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

                  // Card JARAK TEMPUH MINGGU INI
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
                          'JARAK TEMPUH MINGGU INI',
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
                              hasData ? '12.5' : '0',
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
                              ? 'Bagus! Kamu sudah lari 3 kali\nminggu ini.'
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
                      if (hasData)
                        Text(
                          'LIHAT SEMUA',
                          style: TextStyle(
                            color: const Color(0xFFCCFF00),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tampilan kalo ada data VS kosong
                  hasData
                      ? _buildRunCard(context, runs.first)
                      : _buildEmptyState(),
                ],
              ),
            ),
            // Floating Action Button +
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

  // Widget kalo ada data
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
                '14/05/2026',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              // Tombol Hapus
              GestureDetector(
                onTap: () => _showDeleteDialog(context),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Jarak Lari
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jarak Lari',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '3 M',
                    style: TextStyle(
                      color: const Color(0xFFCCFF00),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              // Durasi
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Durasi',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '2:16:10',
                    style: TextStyle(
                      color: const Color(0xFFCCFF00),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Tombol EDIT
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

  // Widget kalo kosong
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

  // Dialog konfirmasi hapus - TAHAP 1 & 2 CUMA FAKE
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Hapus Aktivitas?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Data lari ini akan dihapus permanen.',
            style: TextStyle(color: Colors.grey[400]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Tutup dialog
              child: Text('BATAL', style: TextStyle(color: Colors.grey[500])),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog dulu
                // Kasih feedback kalo ini baru UI doang
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur hapus data aktif di Tahap 3'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
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
