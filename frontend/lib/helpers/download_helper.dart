import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin DownloadCooldownMixin<T extends StatefulWidget> on State<T> {
  bool isCooldown = false;
  int cooldownSeconds = 15;
  Timer? _cooldownTimer;

  void startCooldown() {
    setState(() {
      isCooldown = true;
    });

    _cooldownTimer = Timer(Duration(seconds: cooldownSeconds), () {
      if (mounted) {
        setState(() {
          isCooldown = false;
        });
      }
    });
  }

  void showCooldownMessage() {
    Get.snackbar(
      "Tunggu sebentar",
      "Silakan tunggu $cooldownSeconds detik sebelum mengunduh lagi.",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
}
