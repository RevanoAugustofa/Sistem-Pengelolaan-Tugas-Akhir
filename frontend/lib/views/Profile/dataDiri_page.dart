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
                    controller: controller.emailController,
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

                  Obx(() => _buildSignatureField(
                    label: controller.userRole.value == 'mahasiswa' ? "Tanda Tangan Mahasiswa" : "Tanda Tangan Dosen",
                    initialValue: controller.userSignature.value,
                    selectedPath: controller.selectedImagePath.value,
                    onTap: () => controller.pickImage(),
                  )),

                  // Tambahan Field Berdasarkan Role
                  Obx(() {
                    if (controller.userRole.value == 'mahasiswa') {
                      return Column(
                        children: [
                          _buildInputField(
                            label: "Program Studi",
                            initialValue: controller.prodiName.value,
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
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 149, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
              )),
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
    TextEditingController? controller,
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
            initialValue: controller == null ? initialValue : null,
            controller: controller,
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

  // Helper untuk membuat Signature Field (Editable/Upload mockup)
  Widget _buildSignatureField({
    required String label,
    required String initialValue,
    required String selectedPath,
    required VoidCallback onTap,
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
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              child: selectedPath.isNotEmpty
                ? Center(
                    child: Text("Gambar terpilih:\n${selectedPath.split('/').last}", 
                      style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : (initialValue.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade400, size: 40),
                          const SizedBox(height: 8),
                          Text("Klik untuk unggah tanda tangan", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.green, size: 30),
                          const SizedBox(height: 4),
                          Text("Tanda Tangan Tersimpan", style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                          Text("(Ketuk untuk mengganti)", style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                        ],
                      ),
                    )),
            ),
          ),
        ],
      ),
    );
  }
}

