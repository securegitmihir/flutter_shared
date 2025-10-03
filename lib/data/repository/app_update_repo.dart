import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

import '../data_provider/app_update_dp.dart';
import '../models/app_update_model.dart';

class AppUpdateRepository {
  AppUpdateRepository(this._dp);
  final AppUpdateDataProvider _dp;

  Future<UpdateDecision> checkForUpdate() async {
    try {
      // 1) Installed app version
      final pkg = await PackageInfo.fromPlatform();
      print('Package: $pkg');
      final installed = pkg.version;

      // 2) Fetch remote config (JSON list)
      final raw = await _dp.fetchAppVersions();

      // 3) Parse -> List<UpdateInfo>
      final infos = _parseToUpdateInfoList(raw);

      // 4) Pick entry for this platform (android / ios)
      final info = infos.firstWhere(
            (x) => x.isForThisPlatform,
        orElse: () => throw Exception('No version config for ${Platform.operatingSystem}'),
      );

      // 5) Decide type
      final type = _getUpdateType(installed, info.minVersion, info.maxVersion);

      return UpdateDecision(
        type: type,
        installedVersion: installed,
        minVersion: info.minVersion,
        maxVersion: info.maxVersion,
      );
      // return UpdateDecision(
      //   type: UpdateType.mandatory,
      //   installedVersion: installed,
      //   minVersion: '1.0.0.0',
      //   maxVersion: '1.0.0.1',
      // );
    } catch (_) {
      // On any failure, don’t block the user
      return const UpdateDecision(
        type: UpdateType.none,
        installedVersion: '0.0.0',
        minVersion: '0.0.0',
        maxVersion: '0.0.0',
      );
    }
  }

  // --- helpers -------------------------------------------------------------

  List<UpdateInfo> _parseToUpdateInfoList(dynamic raw) {
    if (raw is List) {
      // If DP already decoded JSON → build models
      return raw.map((e) {
        if (e is UpdateInfo) return e;
        return UpdateInfo.fromJson(Map<String, dynamic>.from(e as Map));
      }).toList();
    }
    throw Exception('Unexpected response shape for update config');
  }

  UpdateType _getUpdateType(String installed, String min, String max) {
    // Mandatory: installed < min
    if (_isLower(installed, min)) return UpdateType.mandatory;

    // Flexible: min <= installed < max
    if (!_isLower(installed, min) && _isLower(installed, max)) {
      return UpdateType.flexible;
    }

    // None: installed >= max
    return UpdateType.none;
  }

  bool _isLower(String a, String b) => _compare(a, b) < 0;

  /// Robust dotted version compare: "1.2.3" vs "1.10.0", ignores "-beta"/"+build"
  int _compare(String a, String b) {
    String clean(String v) => v.split(RegExp(r'[\+\-]')).first;
    final aa = clean(a).split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final bb = clean(b).split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final len = aa.length > bb.length ? aa.length : bb.length;
    for (var i = 0; i < len; i++) {
      final x = i < aa.length ? aa[i] : 0;
      final y = i < bb.length ? bb[i] : 0;
      if (x != y) return x.compareTo(y);
    }
    return 0;
  }
}
