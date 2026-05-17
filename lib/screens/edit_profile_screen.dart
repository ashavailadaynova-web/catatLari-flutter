import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();

    // AMBIL DATA DARI VIEWMODEL
    final profile = context.read<ProfileViewModel>();

    _nameController = TextEditingController(text: profile.userName);

    _locationController = TextEditingController(text: profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),

        backgroundColor: Colors.black,

        iconTheme: const IconThemeData(color: Color(0xFFD4FF00)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          children: [
            // INPUT NAMA
            TextField(
              controller: _nameController,

              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: "Full Name",

                labelStyle: TextStyle(color: Color(0xFFD4FF00)),

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD4FF00)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INPUT LOKASI
            TextField(
              controller: _locationController,

              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: "Location",

                labelStyle: TextStyle(color: Color(0xFFD4FF00)),

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD4FF00)),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // BUTTON SAVE
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4FF00),

                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),

               // MASUKKAN KODE INI PADA ONPRESSED BUTTON SAVE CHANGES KAMU
                onPressed: () async {
                  // 1. Ambil email user yang sedang aktif dari AuthViewModel
                  final authVM = context.read<AuthViewModel>();
                  final activeEmail = authVM.currentUserEmail;
                  final profileVM = context.read<ProfileViewModel>();

                  // 2. Kirim email beserta data baru ke ProfileViewModel (Sertakan profileVM.photoPath jika ada)
                  await profileVM.updateProfile(
                    activeEmail,
                    _nameController.text,
                    _locationController.text,
                    profileVM.photoPath, // <--- Parameter ke-4 untuk mencegah foto ter-reset jadi null saat save nama
                  );

                  // KEMBALI KE PROFILE
                  if (context.mounted) {
                    Navigator.pop(context);

                    // SNACKBAR
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profil berhasil diperbarui!',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Color(0xFFD4FF00),
                      ),
                    );
                  }
                },
                child: const Text(
                  "SAVE CHANGES",

                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
