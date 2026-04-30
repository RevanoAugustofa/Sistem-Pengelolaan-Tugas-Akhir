import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  // Variabel untuk kontrol visibilitas password
  bool _obsOld = true;
  bool _obsNew = true;
  bool _obsConf = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF283D70), // Biru Navy PNC
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder Gambar Besar di Atas
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              "Perbarui Kata Sandi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Pastikan akun Anda menggunakan kata sandi yang panjang dan acak untuk tetap aman.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 30),

            // Field Input Password
            _buildPasswordField("Kata Sandi Saat Ini", _obsOld, () {
              setState(() => _obsOld = !_obsOld);
            }),
            _buildPasswordField("Kata Sandi Baru", _obsNew, () {
              setState(() => _obsNew = !_obsNew);
            }),
            _buildPasswordField("Konfirmasi Kata Sandi", _obsConf, () {
              setState(() => _obsConf = !_obsConf);
            }),

            const SizedBox(height: 40),
            
            const Center(
              child: Text(
                "Password minimal terdiri dari 8 karakter dan berisi kombinasi\nhuruf kapital, huruf kecil, angka dan simbol.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ),
            
            const SizedBox(height: 20),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logika Simpan ke API Laravel
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A89FF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Password Field
  Widget _buildPasswordField(String label, bool obscure, VoidCallback toggle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              children: const [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: toggle,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}