import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class DashboardAdm extends StatefulWidget {
  const DashboardAdm({super.key});

  @override
  State<DashboardAdm> createState() => _DashboardAdmState();
}

class _DashboardAdmState extends State<DashboardAdm> {
  final ProfileController profileController = Get.put(ProfileController());

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
                _buildMenuItem(Icons.history_edu_outlined, 'Logbook', onTap: () => Get.toNamed('/logbookAdm')),
                _buildMenuItem(Icons.how_to_reg_outlined, 'Sidang', onTap: () => Get.toNamed('/pendaftaranSidangAdm')),
                _buildMenuItem(Icons.verified_user_outlined, 'Rekap Pembimbing & Penguji', onTap: () => Get.toNamed('/rekapPembimbingPengujiAdm')),
                _buildMenuItem(Icons.verified_user_outlined, 'Dosen Prodi', onTap: () => Get.toNamed('/dosenProdiAdm')),
                _buildMenuItem(Icons.upload_file_outlined, 'Imp. Mahasiswa', onTap: () => Get.toNamed('/importDataMahasiswaAdm')),
                _buildMenuItem(Icons.upload_file_rounded, 'Imp. Dosen', onTap: () => Get.toNamed('/importDataDosenAdm')),
                _buildMenuItem(Icons.settings_outlined, 'Profil', onTap: () =>  Get.toNamed('/profil', arguments: {'activeRole': 'admin'})),
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
              height: 200, // Tinggi disesuaikan agar menutupi area welcome
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
                        const Text("Kelola Progres Tugas Akhir Mahasiswa Disini.",
                            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14)),
                        
                        const SizedBox(height: 10),

                        // 3. Kartu Profil Admin 
                        _AnimatedScaleButton(
                          onTap: () {}, 
                          child: _buildProfileCard()
                        ),

                        const SizedBox(height: 25),

                        // 4. Menu Grid Admin
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85, 
                          children: [
                            _buildMenuItem(Icons.person_outline, 'User', onTap: () => Get.toNamed('/dataUserAdm')),
                            _buildMenuItem(Icons.people_outline, 'Mahasiswa', onTap: () => Get.toNamed('/dataMahasiswaAdm')),
                            _buildMenuItem(Icons.supervisor_account, 'Dosen', onTap: () => Get.toNamed('/dataDosenAdm')),
                            _buildMenuItem(Icons.account_tree_outlined, 'Prodi', onTap: () => Get.toNamed('/dataProdiAdm')),
                            _buildMenuItem(Icons.meeting_room_outlined, 'Ruangan Sidang', onTap: () => Get.toNamed('/dataRuanganAdm')),
                            _buildMenuItem(Icons.calendar_today, 'Tahun Ajaran', onTap: () => Get.toNamed('/tahunAjaranAdm')),
                            _buildMenuItem(Icons.list_alt, 'Rubrik Nilai', onTap: () => Get.toNamed('/rubrikAdm')),
                            _buildMenuItem(Icons.calendar_month, 'Jadwal', onTap: () => Get.toNamed('/jadwalAdm')),
                            _buildMenuItem(Icons.assignment_turned_in_outlined, 'Hasil Akhir', onTap: () => Get.toNamed('/hasilAdm')),
                            _buildMenuItem(Icons.analytics_outlined, 'Rekap Nilai', onTap: () => Get.toNamed('/rekapAdm')),
                            _buildMenuItem(Icons.description_outlined, 'Proposal', onTap: () => Get.toNamed('/proposalAdm')),
                            _buildMenuItem(Icons.more_horiz, 'Lainnya', color: const Color(0xFFEFE0FB), onTap: _showMoreMenu),
                          ],
                        ),
                        
                        const SizedBox(height: 30),

                        // 5. Section Informasi
                        const Text("Informasi", 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                        const SizedBox(height: 15),
                        _buildInformasiSection(),
                        
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
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(10),
            ),
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

  Widget _buildInformasiSection() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _AnimatedScaleButton(onTap: () {}, child: _buildInfoCard("Jumlah User", "10 User")),
          const SizedBox(width: 15),
          _AnimatedScaleButton(onTap: () {}, child: _buildInfoCard("Jumlah Mahasiswa", "5 Mahasiswa")),
          const SizedBox(width: 15),
          _AnimatedScaleButton(onTap: () {}, child: _buildInfoCard("Jumlah Program", "8 Program")),
          const SizedBox(width: 15),
          _AnimatedScaleButton(onTap: () {}, child: _buildInfoCard("Jumlah Dosen", "8 Dosen")),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title, 
            style: const TextStyle(
              color: Color.fromRGBO(74, 74, 74, 1), 
              fontSize: 12,
              fontWeight: FontWeight.w500
            )
          ),
          const SizedBox(height: 8),
          Text(
            value, 
            style: const TextStyle(
              color: Color.fromRGBO(16, 168, 229, 1), 
              fontSize: 18, 
              fontWeight: FontWeight.bold
            )
          ),
        ],
      ),
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
