import 'dart:io';

enum UpdateType { mandatory, flexible, none }

class UpdateInfo {
  final String appType;     // "android" | "ios"
  final String minVersion;  // mandatory below this
  final String maxVersion;  // flexible below this, none at/above

  UpdateInfo({
    required this.appType,
    required this.minVersion,
    required this.maxVersion,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      appType: (json['apptype'] as String).toLowerCase(),
      minVersion: json['minversion']?.toString() ?? '0.0.0',
      maxVersion: json['maxversion']?.toString() ?? '0.0.0',
    );
  }

  bool get isForThisPlatform =>
      (Platform.isAndroid && appType == 'android') ||
          (Platform.isIOS && appType == 'ios');
}

class UpdateDecision {
  final UpdateType type;
  final String installedVersion;
  final String minVersion;
  final String maxVersion;

  /// Optionally helpful if you want to show a target version in the dialog
  String? get targetVersion =>
      type == UpdateType.mandatory ? minVersion
          : type == UpdateType.flexible ? maxVersion
          : null;

  const UpdateDecision({
    required this.type,
    required this.installedVersion,
    required this.minVersion,
    required this.maxVersion,
  });

  factory UpdateDecision.none(String installed, String min, String max) =>
      UpdateDecision(
        type: UpdateType.none,
        installedVersion: installed,
        minVersion: min,
        maxVersion: max,
      );
}
