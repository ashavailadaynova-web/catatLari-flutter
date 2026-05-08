import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:catat_lari/models/run_model.dart';

class EditRunScreen extends StatefulWidget {
  final RunModel run; // Data lari yg dikirim dari Home
  const EditRunScreen({super.key, required this.run});

  @override
  State<EditRunScreen> createState() => _EditRunScreenState();
}

class _EditRunScreenState extends State<EditRunScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _distanceController;
  late TextEditingController _durationController;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Convert "dd/MM/yyyy" ke DateTime
    _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.run.date);
    _dateController = TextEditingController(text: widget.run.date);
    _distanceController = TextEditingController(
      text: widget.run.distance.toString(),
    );
    _durationController = TextEditingController(text: widget.run.duration);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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

  // Style input dengan floating label
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[500]),
      floatingLabelStyle: const TextStyle(color: Color(0xFFCCFF00)),
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

  void _updateRun() {
    if (_formKey.currentState!.validate()) {
      // Tahap 3 baru update ke DB. Sekarang balik ke Home aja
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data lari berhasil diupdate!'),
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

              // Tanggal Lari
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
                  onPressed: _updateRun,
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
