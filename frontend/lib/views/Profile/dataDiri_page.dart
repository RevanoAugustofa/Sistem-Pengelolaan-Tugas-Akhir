import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class DataDiriPage extends StatelessWidget {
  DataDiriPage({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Data Diri",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 149, 255),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
        
            // Form Data Diri
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Obx(() => _buildInputField(
                    label: controller.userRole.value == 'Mahasiswa' ? "Nama Mahasiswa" : "Nama Lengkap",
                    initialValue: controller.userName.value,
                    readOnly: true,
                  )),

                  Obx(() => _buildInputField(
                    label: controller.userRole.value == 'Mahasiswa' ? "NIM" : "NIP / NIDN",
                    initialValue: controller.userId.value,
                    readOnly: true,
                  )),

                  _buildInputField(
                    label: "Email",
                    initialValue: controller.userEmail.value,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: false, // Hanya email yang bisa diedit
                    hint: "Masukkan email baru",
                  ),

                  Obx(() => _buildRadioGenderField(
                    label: "Jenis Kelamin",
                    value: controller.userGender.value,
                  )),

                  Obx(() => _buildInputField(
                    label: "Alamat",
                    initialValue: controller.userAddress.value,
                    maxLines: 3,
                    readOnly: true,
                  )),

                  // Tambahan Field Berdasarkan Role
                  Obx(() {
                    if (controller.userRole.value == 'Mahasiswa') {
                      return Column(
                        children: [
                          _buildInputField(
                            label: "Program Studi",
                            initialValue: controller.prodiName.value,
                            readOnly: true,
                          ),
                        ],
                      );
                    } else if (controller.userRole.value == 'Dosen' || controller.userRole.value == 'KoorProdi') {
                      return Column(
                        children: [
                          _buildInputField(
                            label: "Jabatan",
                            initialValue: "Lektor", // Mockup read-only
                            readOnly: true,
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  }),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar("Sukses", "Perubahan email berhasil disimpan", 
                      backgroundColor: Colors.green, colorText: Colors.white);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 149, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat input field
  Widget _buildInputField({
    required String label,
    String? initialValue,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: const TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w600, 
              color: Colors.black87
            )
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            style: TextStyle(
              fontSize: 14, 
              color: readOnly ? Colors.black54 : Colors.black
            ),
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              filled: true,
              fillColor: readOnly ? const Color(0xFFF0F2F5) : const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: readOnly ? Colors.grey.shade300 : Colors.blue, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat Radio Button Gender (Read-only)
  Widget _buildRadioGenderField({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: const TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w600, 
              color: Colors.black87
            )
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildReadOnlyRadio("Laki-laki", value == "Laki-laki"),
              const SizedBox(width: 20),
              _buildReadOnlyRadio("Perempuan", value == "Perempuan"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyRadio(String label, bool isSelected) {
    return Row(
      children: [
        Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: isSelected ? Colors.blue : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.black : Colors.black54,
          ),
        ),
      ],
    );
  }
}
