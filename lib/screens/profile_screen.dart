import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/run_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

import 'onboarding_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // FOTO PROFILE
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  // LOAD FOTO SAAT HALAMAN DIBUKA
  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // AMBIL FOTO DARI STORAGE
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  // PILIH FOTO DARI GALERI
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();

      // SIMPAN PATH FOTO
      await prefs.setString('profile_image', pickedFile.path);

      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // LOGOUT
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Keluar Akun',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Apakah kamu yakin ingin logout dari aplikasi?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('BATAL', style: TextStyle(color: Colors.grey)),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await context.read<AuthViewModel>().logout(context);

                if (context.mounted) {
                  Navigator.pop(dialogContext);
                }

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text('KELUAR'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    final runVM = context.watch<RunViewModel>();

    // TOTAL RUN
    final int totalRuns = runVM.runs.length;

    // TOTAL DISTANCE
    final double totalDistance = runVM.runs.fold(
      0.0,
      (sum, run) => sum + run.distance,
    );

    // HITUNG AVG PACE
    double totalMinutes = 0;

    for (var run in runVM.runs) {
      final parts = run.duration.split(':');

      if (parts.length == 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        final seconds = int.tryParse(parts[2]) ?? 0;

        totalMinutes += (hours * 60) + minutes + (seconds / 60);
      }
    }

    String avgPace = "0'00";

    if (totalDistance > 0) {
      final pace = totalMinutes / totalDistance;

      final paceMinutes = pace.floor();

      final paceSeconds = ((pace - paceMinutes) * 60).round();

      avgPace = "${paceMinutes}'${paceSeconds.toString().padLeft(2, '0')}";
    }

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),

          child: Column(
            children: [
              // FOTO PROFILE
              GestureDetector(
                onTap: _pickImage,

                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: const Color(0xFFCCFF00),
                          width: 3,
                        ),

                        image: DecorationImage(
                          image: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const NetworkImage(
                                      'https://i.pravatar.cc/150?img=3',
                                    )
                                    as ImageProvider,

                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // ICON CAMERA
                    Positioned(
                      bottom: 0,
                      right: 0,

                      child: Container(
                        padding: const EdgeInsets.all(6),

                        decoration: const BoxDecoration(
                          color: Color(0xFFCCFF00),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // NAMA
              Text(
                profileVM.userName,

                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              // LOKASI
              Text(
                'Bergabung sejak 2026 • ${profileVM.location}',

                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),

              const SizedBox(height: 32),

              // TOTAL DISTANCE
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
                      'TOTAL DISTANCE',

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
                          '${totalDistance.toInt()}',

                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCCFF00),
                          ),
                        ),

                        const SizedBox(width: 4),

                        const Text(
                          'km',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCCFF00),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // RUNS & AVG PACE
              Row(
                children: [
                  // RUNS
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'RUNS',

                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '$totalRuns',

                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // AVG PACE
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'AVG. PACE',

                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            avgPace,

                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // EDIT PROFILE
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),

                    foregroundColor: Colors.black,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: const Text(
                    'EDIT PROFILE',

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // LOGOUT
              SizedBox(
                width: double.infinity,
                height: 50,

                child: OutlinedButton(
                  onPressed: () => _logout(context),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,

                    side: BorderSide(color: Colors.grey[700]!),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: const Text(
                    'LOGOUT',

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
