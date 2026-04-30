import 'package:flutter/material.dart';

class UbahInformasiProfilPage extends StatelessWidget {
  const UbahInformasiProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Informasi Profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF283D70),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 150, width: 150, color: Colors.grey.shade300), // Placeholder foto besar
            const SizedBox(height: 20),
            const Text("Informasi Profil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Perbarui informasi akun dan alamat email Anda.", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 25),
            _buildInputField("Nama Pengguna Saat Ini", "Revano Augustofa", enabled: false),
            _buildInputField("Nama Pengguna Baru", "Nama Pengguna"),
            _buildInputField("Email Saat Ini", "revano****@gmail.com", enabled: false),
            _buildInputField("Email Baru", "Alamat Email"),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A89FF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("SIMPAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(text: label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500), children: const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))])),
          const SizedBox(height: 8),
          TextField(
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        ],
      ),
    );
  }
}