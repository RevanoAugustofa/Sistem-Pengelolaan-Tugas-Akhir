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
          style: TextStyle(color:Color.fromARGB(255, 4, 52, 87), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() => controller.unreadCount.value > 0 
            ? IconButton(
                tooltip: "Tandai semua dibaca",
                icon: const Icon(Icons.done_all, color:Color.fromARGB(255, 68, 68, 68), ),
                onPressed: () => controller.markAllAsRead(),
              )
            : const SizedBox.shrink()
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color.fromARGB(255, 95, 95, 95)),
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
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
          _handleNotificationClick(notification);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xFFF0F7FF),
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: notification.isRead 
                          ? Colors.grey.withOpacity(0.1) 
                          : Color.fromARGB(255, 0, 149, 255).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notification.isRead ? Icons.notifications_none : Icons.notifications, 
                      color: notification.isRead ? Colors.grey : Color.fromARGB(255, 0, 149, 255), 
                      size: 24
                    ),
                  ),
                  if (!notification.isRead)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.namaNotif ?? "Pemberitahuan",
                      style: TextStyle(
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold, 
                        fontSize: 15,
                        color: notification.isRead ? Colors.grey[700] : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.isiNotif ?? "",
                      style: TextStyle(
                        color: notification.isRead ? Colors.grey[600] : Colors.grey[800], 
                        fontSize: 13
                      ),
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
  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Color.fromARGB(255, 0, 149, 255),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    notification.namaNotif ?? "Detail Notifikasi",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              notification.isiNotif ?? "-",
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 149, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "Tutup",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
