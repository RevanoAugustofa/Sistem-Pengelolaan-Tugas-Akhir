import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification_controller.dart';
import '../../models/notification_model.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notifikasi",
          style: TextStyle(color: Color.fromARGB(255, 89, 89, 89), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color.fromARGB(255, 88, 88, 88)),
            onPressed: () => controller.fetchNotifications(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  "Tidak ada notifikasi",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationItem(notification, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, NotificationController controller) {
    // Format tanggal
    String formattedDate = "";
    if (notification.createdAt != null) {
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(notification.createdAt!);
    } else if (notification.tglNotif != null) {
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(notification.tglNotif!);
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        controller.deleteNotification(notification.id);
      },
      child: InkWell(
        onTap: () {
          // Aksi saat notifikasi diklik, misalnya navigasi berdasarkan isi atau nama
          _handleNotificationClick(notification);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 149, 255).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications, color: Color.fromARGB(255, 0, 149, 255), size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.namaNotif ?? "Pemberitahuan",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.isiNotif ?? "",
                      style: TextStyle(color: Colors.grey[800], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationClick(NotificationModel notification) {
    // Logika navigasi berdasarkan tipe notifikasi bisa ditambahkan di sini
    // Contoh sederhana: tunjukkan dialog detail
    Get.defaultDialog(
      title: notification.namaNotif ?? "Detail Notifikasi",
      middleText: notification.isiNotif ?? "",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF283D70),
      onConfirm: () => Get.back(),
    );
  }
}
