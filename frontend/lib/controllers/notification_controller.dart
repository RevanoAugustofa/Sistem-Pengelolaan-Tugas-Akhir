import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

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
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final response = await _notificationService.deleteNotification(id);
      if (response['status'] == 'success') {
        notifications.removeWhere((n) => n.id == id);
        Get.snackbar("Sukses", "Notifikasi berhasil dihapus");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus notifikasi: $e");
    }
  }
}
