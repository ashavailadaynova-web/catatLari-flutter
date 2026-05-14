import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Import provider
import '../viewmodels/profile_viewmodel.dart'; // 2. Import Profile ViewModel

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
    // 3. Ambil data dari ViewModel buat ditampilin di form
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
        title: const Text("Edit Profile"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: Color(0xFFD4FF00)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _locationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Location",
                labelStyle: TextStyle(color: Color(0xFFD4FF00)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4FF00),
                ),
                onPressed: () {
                  // 4. Update data profil ke ViewModel
                  context.read<ProfileViewModel>().updateProfile(
                    _nameController.text,
                    _locationController.text,
                  );

                  Navigator.pop(context);

                  // Opsional: Kasih feedback snackbar
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
                },
                child: const Text(
                  "SAVE CHANGES",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
