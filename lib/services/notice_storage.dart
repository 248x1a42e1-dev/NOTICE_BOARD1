import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeStorage {
  static const String storageKey = 'notices';

  // Save notices
  static Future<void> saveNotices(List<Map<String, String>> notices) async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(notices);

    await prefs.setString(storageKey, encodedData);
  }

  // Load notices
  static Future<List<Map<String, String>>> loadNotices() async {
    final prefs = await SharedPreferences.getInstance();

    final String? savedData = prefs.getString(storageKey);

    if (savedData == null) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(savedData);

    return decodedData.map((notice) {
      return Map<String, String>.from(notice);
    }).toList();
  }
}
