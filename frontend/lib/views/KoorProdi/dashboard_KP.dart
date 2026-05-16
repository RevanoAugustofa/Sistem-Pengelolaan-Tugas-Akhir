import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/koorprodi_controller.dart';

class DashboardKp extends StatefulWidget {
  const DashboardKp({super.key});

  @override
  State<DashboardKp> createState() => _DashboardKpState();
}

class _DashboardKpState extends State<DashboardKp> {
  final ProfileController profileController = Get.put(ProfileController());
  final KoorProdiController koorProdiController = Get.put(KoorProdiController());

  // Fungsi untuk menampilkan Modal Bottom Sheet "Lainnya"
  void _showMoreMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Text(
              "Menu Lainnya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3475)),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                _buildMenuItem(Icons.people_outline, 'User', onTap: () =>  Get.toNamed('/dataUserKp')),
                _buildMenuItem(Icons.settings_outlined, 'Ruangan', onTap: () =>  Get.toNamed('/dataRuanganKp')),
                _buildMenuItem(Icons.settings_outlined, 'Pendaftaran Sidang', onTap: () =>  Get.toNamed('/pendaftaranSidangKp')),
                _buildMenuItem(Icons.settings_outlined, 'Hasil Akhir', onTap: () =>  Get.toNamed('/hasilKp')),
                _buildMenuItem(Icons.settings_outlined, 'Rekap Pembimbing & Penguji', onTap: () =>  Get.toNamed('/rekapPembimbingPengujiKp')),
                _buildMenuItem(Icons.settings_outlined, 'Profil', onTap: () =>  Get.toNamed('/profil', arguments: {'activeRole': 'koorprodi'})),
                
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 1. Background Biru
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 149, 255),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),

            // 2. Konten Utama
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo & Notifikasi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/img/logo2_putih.png',
                          height: 50,
                          errorBuilder: (context, error, stackTrace) => const Text(
                            'SIPTA',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        _AnimatedScaleButton(
                          onTap: () => Get.toNamed('/notifikasi'),
                          child: Stack(
                            children: [
                              const Icon(Icons.notifications, color: Colors.white, size: 30),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.orange, 
                                    shape: BoxShape.circle
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Area Konten
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Obx(() => Text("Halo ${profileController.userName.value.split(' ').first} !",
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 4),
                        const Text("Kelola Data Mahasiswa dan Dosen Disini.",
                            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14)),
                        
                        const SizedBox(height: 10),

                        // 3. Kartu Profil Koor Prodi
                        _AnimatedScaleButton(
                          onTap: () => Get.toNamed('/profil', arguments: {'activeRole': 'koorprodi'}), 
                          child: _buildProfileCard()
                        ),

                        const SizedBox(height: 25),

                        // 4. Menu Grid Koor Prodi
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85, 
                          children: [
                            _buildMenuItem(Icons.people_outline, 'Mahasiswa', onTap: () => Get.toNamed('/dataMahasiswaKp')),
                            _buildMenuItem(Icons.supervisor_account, 'Dosen', onTap: () => Get.toNamed('/dataDosenKp')),
                            _buildMenuItem(Icons.list_alt, 'Rubrik Nilai', onTap: () => Get.toNamed('/dataRubrikNilaiKp')),
                            _buildMenuItem(Icons.calendar_month, 'Jadwal', onTap: () => Get.toNamed('/jadwalKp')),
                            _buildMenuItem(Icons.history_edu_outlined, 'Logbook', onTap: () => Get.toNamed('/logbookKp')),
                            _buildMenuItem(Icons.verified_user_outlined, 'Validasi Pembimbing', onTap: () => Get.toNamed('/pengajuanpembimbing_KP')),
                            _buildMenuItem(Icons.assignment_turned_in_outlined, 'Proposal', onTap: () => Get.toNamed('/proposalKp')),
                            _buildMenuItem(Icons.more_horiz, 'Lainnya', color: const Color(0xFFEFE0FB), onTap: _showMoreMenu),
                          ],
                        ),
                        
                        const SizedBox(height: 30),

                        // 5. Card Rekap Verifikasi
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 98, 184, 254),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Rekap Verifikasi Pembimbing Mahasiswa",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildRekapItem("12", "Belum Terverifikasi", Colors.red),
                                  _buildRekapItem("12", "Sudah Terverifikasi", Colors.green),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),

                        // Footer Versi
                        const Center(
                          child: Text(
                            "V 0.01",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(profileController.userName.value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 58, 58, 58)))),
                const SizedBox(height: 4),
                Obx(() => Text(profileController.userId.value, 
                    style: const TextStyle(color: Color.fromARGB(255, 74, 74, 74), fontWeight: FontWeight.bold, fontSize: 14))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color? color, VoidCallback? onTap}) {
    Color bgColor = color ?? const Color(0xFFE5F1FB); 
    
    return _AnimatedScaleButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bgColor == const Color(0xFFE5F1FB) ? const Color(0xFFCDE2F5) : const Color(0xFFDCC8ED), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color.fromRGBO(16, 168, 229, 1), size: 22),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11, 
                fontWeight: FontWeight.w600, 
                color: Colors.black87,
                height: 1.2
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRekapItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black87),
        ),
      ],
    );
  }
}

// Widget Internal untuk Animasi Scale
class _AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _AnimatedScaleButton({required this.child, this.onTap});

  @override
  State<_AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<_AnimatedScaleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}