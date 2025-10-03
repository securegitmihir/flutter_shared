import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class LogService {
  static File? _logFile;
  static late Directory _logDir;
  static String _currentDate = _today();

  static String _today() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// Initializes the logging system
  static Future<void> init() async {
    if (kIsWeb) return; // not supported on web
    try {
      final dir = await getApplicationDocumentsDirectory();
      _logDir = dir;

      // Ensure directory exists (usually already created by path_provider)
      if (!await _logDir.exists()) {
        await _logDir.create(recursive: true);
      }

      _currentDate = _today();
      _logFile = File('${_logDir.path}/log_$_currentDate.txt');
      if (!await _logFile!.exists()) {
        await _logFile!.create(recursive: true);
        print("📂 Created new log file at: ${_logFile!.path}");
      }

      await logActivity("🟢 App Started", type: "SYSTEM");
      await _cleanupOldLogs(retainDays: 5);
    } catch (e) {
      print("⚠️ LogService init error: $e");
    }
  }

  /// Logs activity with proper formatting
  static Future<void> logActivity(
      String message, {
        String type = "USER_ACTION",
        Map<String, dynamic>? data,
      }) async {
    if (kIsWeb || _logFile == null) return;

    try {
      // Rollover if date changed since last write
      final today = _today();
      if (today != _currentDate) {
        _currentDate = today;
        _logFile = File('${_logDir.path}/log_$_currentDate.txt');
        if (!await _logFile!.exists()) {
          await _logFile!.create(recursive: true);
          print("📂 Rolled over log file: ${_logFile!.path}");
        }
      }

      final ts = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
      final buffer = StringBuffer()
        ..write("[ $ts ] [$type] $message");
      if (data != null) buffer.write("\n📦 Data: ${jsonEncode(data)}");
      buffer.write("\n-----------------------------------------\n");

      await _logFile!.writeAsString(buffer.toString(), mode: FileMode.append);
    } catch (e) {
      print("⚠️ Log write error: $e");
    }
  }

  /// Delete logs older than [retainDays].
  static Future<void> _cleanupOldLogs({int retainDays = 5}) async {
    if (kIsWeb) return;
    try {
      final now = DateTime.now();
      final entries = _logDir.listSync(followLinks: false);
      for (final e in entries) {
        if (e is! File) continue;
        final name = e.uri.pathSegments.last;
        if (!name.startsWith('log_') || !name.endsWith('.txt')) continue;

        final dateStr = name.replaceAll(RegExp(r'[^0-9-]'), '');
        final d = DateTime.tryParse(dateStr);
        if (d == null) continue;

        if (now.difference(d).inDays > retainDays) {
          await e.delete();
          print("🗑️ Deleted old log file: ${e.path}");
        }
      }
    } catch (e) {
      print("⚠️ Log cleanup error: $e");
    }
  }

  /// expose current log path for share/debug screens
  static String? get currentLogPath => _logFile?.path;

  /// read current log (for in-app viewer)
  static Future<String> readCurrentLog() async {
    if (_logFile == null || !await _logFile!.exists()) return '';
    return _logFile!.readAsString();
  }
}
