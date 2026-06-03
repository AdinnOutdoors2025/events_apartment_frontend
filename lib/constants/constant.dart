import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String tokenKey = "jwt_token";
  static const String idKey = "jwt_token";

  /// Save Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  /// Get Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(tokenKey);
  }

  /// Remove Token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<void> saveId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(idKey, id);
  }

  static Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(idKey);
  }

  static Future<void> clearId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(idKey);
  }

  /// Clear All Storage
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}

class AppToast {
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}

class Validator {
  static String? validate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is Required";
    }
    return null;
  }
}

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return 'GOOD MORNING';
  } else if (hour >= 12 && hour < 17) {
    return 'GOOD AFTERNOON';
  } else if (hour >= 17 && hour < 21) {
    return 'GOOD EVENING';
  } else {
    return 'GOOD NIGHT';
  }
}

String formatIndianNumber(int number, {bool isCurrency = false}) {
  String numStr = number.toString();
  if (numStr.length <= 3) return isCurrency ? '₹$numStr' : numStr;

  String otherNumbers = numStr.substring(0, numStr.length - 3);
  if (otherNumbers.isNotEmpty) {
    otherNumbers = otherNumbers.replaceAllMapped(
      RegExp(r'.{1,2}(?=(.{2})+(?!.))'),
      (Match m) => '${m[0]},',
    );
    // Fix leading comma if it happens
    if (!otherNumbers.contains(',')) {
      // simple case like 1840 -> 1 and 840 -> no comma needed in otherNumbers, wait, wait...
      otherNumbers = otherNumbers.replaceAllMapped(
        RegExp(r'(\\d+)(?=(\\d{2})+(?!\\d))'),
        (Match m) => '${m[1]},',
      );
    } else {
      otherNumbers = otherNumbers.replaceAllMapped(
        RegExp(r'(\\d{1,2})(?=(\\d{2})+(?!\\d))'),
        (Match m) => '${m[1]},',
      );
    }
  }

  // Easier alternative for Indian format:
  String result = "";
  int count = 0;
  for (int i = numStr.length - 1; i >= 0; i--) {
    result = numStr[i] + result;
    count++;
    if (count == 3 && i != 0) {
      result = ',$result';
    } else if (count > 3 && (count - 3) % 2 == 0 && i != 0) {
      result = ',$result';
    }
  }
  return isCurrency ? '₹$result' : result;
}
