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
          style: TextStyle(color: Color(0xFF283D70), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() => controller.unreadCount.value > 0 
            ? IconButton(
                tooltip: "Tandai semua dibaca",
                icon: const Icon(Icons.done_all, color: Color(0xFF283D70), ),
                onPressed: () => controller.markAllAsRead(),
              )
            : const SizedBox.shrink()
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF283D70)),
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
                          : const Color(0xFF283D70).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notification.isRead ? Icons.notifications_none : Icons.notifications, 
                      color: notification.isRead ? Colors.grey : const Color(0xFF283D70), 
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
