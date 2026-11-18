import 'package:flutter/services.dart';

class UsageMonitoring {
  static const MethodChannel _channel = MethodChannel('com.flowtime.deepwork/usage');

  static Future<bool> hasUsageStatsPermission() async {
    try {
      final bool hasPermission = await _channel.invokeMethod('checkUsagePermission');
      return hasPermission;
    } on PlatformException catch (e) {
      print("Failed to check permission: '${e.message}'.");
      return false;
    }
  }

  static Future<void> requestUsageStatsPermission() async {
    try {
      await _channel.invokeMethod('requestUsagePermission');
    } on PlatformException catch (e) {
      print("Failed to request permission: '${e.message}'.");
    }
  }

  static Future<String?> getActiveApp() async {
    try {
      final String? activeApp = await _channel.invokeMethod('getActiveApp');
      return activeApp;
    } on PlatformException catch (e) {
      print("Failed to get active app: '${e.message}'.");
      return null;
    }
  }
}
