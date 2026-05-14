import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // 1. Import provider
import '../viewmodels/run_viewmodel.dart'; // 2. Import ViewModel
import '../models/run_model.dart'; // 3. Import Model

class AddRunScreen extends StatefulWidget {
  const AddRunScreen({super.key});

  @override
  State<AddRunScreen> createState() => _AddRunScreenState();
}

class _AddRunScreenState extends State<AddRunScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _dateController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // Fungsi buat munculin kalender
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFCCFF00),
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: const Color(0xFFCCFF00), size: 20),
      filled: true,
      fillColor: Colors.black,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCCFF00), width: 1.5),
      ),
    );
  }

  // 4. UBAH FUNGSI INI
  void _saveRun() {
    if (_formKey.currentState!.validate()) {
      // 1. Ambil data dari controller dan pastikan formatnya benar
      final newRun = RunModel(
        // id dikosongkan karena akan diisi otomatis oleh Database (AUTOINCREMENT)
        date: _dateController.text,
        distance: double.tryParse(_distanceController.text) ?? 0.0,
        duration: _durationController.text,
        notes: "", // Kasih string kosong biar nggak null
      );

      // 2. Panggil fungsi addRun dari ViewModel
      context.read<RunViewModel>().addRun(newRun);

      // 3. Kembali ke halaman utama
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lari berhasil dicatat!'),
          backgroundColor: Color(0xFFCCFF00),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFCCFF00)),
          onPressed: () => Navigator.pop(context), // Balik ke Home
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Let\'s Share',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFCCFF00),
                ),
              ),
              Text(
                'your journey!',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Tanggal Lari - pake GestureDetector biar bisa klik
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      'Tanggal Lari',
                      Icons.calendar_month_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Pilih tanggal lari';
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Jarak Lari
              TextFormField(
                controller: _distanceController,
                style: const TextStyle(color: Colors.white),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _inputDecoration(
                  'Jarak Lari (KM)',
                  Icons.route_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Isi jarak lari';
                  if (double.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Durasi
              TextFormField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.datetime,
                decoration: _inputDecoration(
                  'Durasi (hh:mm:ss)',
                  Icons.timer_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Isi durasi lari';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Teks PASTIKAN DATA SUDAH SESUAI
              Center(
                child: Text(
                  'PASTIKAN DATA SUDAH SESUAI',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Tombol CATAT LARI
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveRun,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CATAT LARI',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
