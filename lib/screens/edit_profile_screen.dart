import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller buat ambil teks dari inputan
  final _nameController = TextEditingController(text: "Lee Jeno");
  final _locationController = TextEditingController(text: "Surabaya");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Samain temanya
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Contoh Input Nama
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: Color(0xFFD4FF00)), // Warna lime
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),
            // Contoh Input Lokasi
            TextField(
              controller: _locationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Location",
                labelStyle: TextStyle(color: Color(0xFFD4FF00)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4FF00)),
                onPressed: () {
                  // Logika simpan di sini
                  Navigator.pop(context); 
                },
                child: const Text("SAVE CHANGES", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}