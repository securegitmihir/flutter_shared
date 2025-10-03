import 'dart:io';
import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/app_update_model.dart';

class UpdatePrompter {
  static Future<void> show(
    BuildContext context,
    UpdateDecision decision, {
    String? iosAppId,
  }) async {
    if (decision.type == UpdateType.none) return;

    final mandatory = decision.type == UpdateType.mandatory;

    await showDialog<void>(
      context: context,
      barrierDismissible: !mandatory,
      builder: (ctx) => AlertDialog(
        title: CustomTextWidget(
          mandatory ? 'Update required' : 'Update available',
        ),
        content: CustomTextWidget(
          mandatory
              ? "updatePopup.mandatoryUpdateText".tr()
              : "updatePopup.flexibleUpdateText".tr(),
        ),
        // mandatory
        actions: <Widget>[
          if (!mandatory)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const CustomTextWidget('Not now'),
            ),
          TextButton(
            onPressed: () async {
              await _openStore(iosAppId: iosAppId);
            },
            child: const CustomTextWidget('Update'),
          ),
        ],
      ),
    );
  }

  static Future<void> _openStore({String? iosAppId}) async {
    if (Platform.isAndroid) {
      final pkg = (await PackageInfo.fromPlatform()).packageName;
      print('Package: $pkg');
      final market = Uri.parse('market://details?id=$pkg');
      final web = Uri.parse(
        'https://play.google.com/store/apps/details?id=$pkg',
      );

      // try Play app first, then browser
      if (!await launchUrl(market, mode: LaunchMode.externalApplication)) {
        await launchUrl(web, mode: LaunchMode.externalApplication);
      }
    } else {
      // Supply your App Store id
      final id = iosAppId ?? '';
      final uri = Uri.parse('itms-apps://itunes.apple.com/app/id$id');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
