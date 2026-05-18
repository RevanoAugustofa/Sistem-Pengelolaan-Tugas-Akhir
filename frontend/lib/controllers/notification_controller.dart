import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final response = await _notificationService.getNotifications();
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'];
        notifications.value = data.map((json) => NotificationModel.fromJson(json)).toList();
        _updateUnreadCount();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(int id) async {
    try {
      final response = await _notificationService.markAsRead(id);
      if (response['status'] == 'success') {
        int index = notifications.indexWhere((n) => n.id == id);
        if (index != -1) {
          // Update local state
          var oldNotif = notifications[index];
          notifications[index] = NotificationModel(
            id: oldNotif.id,
            idUser: oldNotif.idUser,
            namaNotif: oldNotif.namaNotif,
            isiNotif: oldNotif.isiNotif,
            isRead: true,
            tglNotif: oldNotif.tglNotif,
            createdAt: oldNotif.createdAt,
            updatedAt: oldNotif.updatedAt,
          );
          _updateUnreadCount();
        }
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _notificationService.markAllAsRead();
      if (response['status'] == 'success') {
        // Update all locally
        notifications.value = notifications.map((n) {
          return NotificationModel(
            id: n.id,
            idUser: n.idUser,
            namaNotif: n.namaNotif,
            isiNotif: n.isiNotif,
            isRead: true,
            tglNotif: n.tglNotif,
            createdAt: n.createdAt,
            updatedAt: n.updatedAt,
          );
        }).toList();
        _updateUnreadCount();
        Get.snackbar("Sukses", "Semua notifikasi ditandai sudah dibaca");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menandai semua sudah dibaca: $e");
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final response = await _notificationService.deleteNotification(id);
      if (response['status'] == 'success') {
        notifications.removeWhere((n) => n.id == id);
        _updateUnreadCount();
        Get.snackbar("Sukses", "Notifikasi berhasil dihapus");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus notifikasi: $e");
    }
  }
}
