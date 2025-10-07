import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:assisted_living/services/constants.dart';
import 'breakpoints.dart';
import 'package:flutter/material.dart';
part 'package:assisted_living/responsive/font/font_responsive.dart';

class Responsive {
  Responsive._(this._bp);

  final BreakpointSnapshot _bp;

  Size get size => _bp.size;
  double get width => _bp.size.width;
  double get height => _bp.size.height;
  double get scale => _bp.textScale;
  DeviceType get deviceType => _bp.deviceType;

  bool get isPortrait => _bp.orientation == ScreenOrient.portrait;
  bool get isLandscape => _bp.orientation == ScreenOrient.landscape;

  DeviceSize get device => _bp.device;
  TextSize get textBucket => _bp.text;

  void allowRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Width-based scaler (base: 390 logical px).
  void setOrientationLocks(String path) {
    if (deviceType == DeviceType.tablet) {
      if (!Constants.restrictedRotationPaths.contains(path)) {
        allowRotation();
        return;
      }
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  double px(num base) {
    base = base.toDouble();
    const baseWidth = 390.0;

    final factor = (width / baseWidth).clamp(0.75, 1.35);
    // var factor = (width / baseWidth) ;
    return base * factor;
  }

  /// Spacing that grows a bit with device + a bit with text size.
  double space(num base) {
    base = base.toDouble(); // make it double

    final sizeCurve = switch (device) {
      DeviceSize.xxs => 0.75,
      DeviceSize.xs => 0.80,
      DeviceSize.s => 0.85,
      DeviceSize.m => 0.90,
      DeviceSize.l => 0.95,
      DeviceSize.xl => 1.00,
      DeviceSize.xxl => 1.10,
      DeviceSize.xxxl => 1.20,
      //   DeviceSize.xxs => 0.95,
      //   DeviceSize.xs => 1.00,
      //   DeviceSize.s => 1.05,
      //   DeviceSize.m => 1.10,
      //   DeviceSize.l => 1.15,
      //   DeviceSize.xl => 1.20,
      //   DeviceSize.xxl => 1.25,
      //   DeviceSize.xxxl => 1.30,
    };

    final textCurve = switch (textBucket) {
      TextSize.small => 0.95,
      TextSize.normal => 1.00,
      TextSize.large => 1.07,
      TextSize.xlarge => 1.12,
      TextSize.largest => 1.17,
    };

    return base * sizeCurve * textCurve;
  }

  /// Font size that respects accessibility.
  double font(num base) {
    base = base.toDouble();
    final deviceBump = switch (device) {
      DeviceSize.xxs => 0.75,
      DeviceSize.xs => 0.80,
      DeviceSize.s => 0.85,
      DeviceSize.m => 0.90,
      DeviceSize.l => 0.95,
      DeviceSize.xl => 1.00,
      DeviceSize.xxl => 1.10,
      DeviceSize.xxxl => 1.20,
    };
    // final deviceBump = switch (device) {
    //   DeviceSize.xxs => 0.98,
    //   DeviceSize.xs => 1.00,
    //   DeviceSize.s => 1.06,
    //   DeviceSize.m => 1.12,
    //   DeviceSize.l => 1.18,
    //   DeviceSize.xl => 1.24,
    //   DeviceSize.xxl => 1.30,
    //   DeviceSize.xxxl => 1.36,
    // };

    final capped = scale.clamp(0.8, 1.6);
    return base * deviceBump * capped;
  }

  /// Pick a value per device bucket.
  T pick<T>({
    T? xxs,
    T? xs,
    T? s,
    T? m,
    T? l,
    T? xl,
    T? xxl,
    T? xxxl,
    required T fallback,
  }) {
    final chain = switch (device) {
      DeviceSize.xxs => [xxs, xs, s, m, l, xl, xxl, xxxl, fallback],
      DeviceSize.xs => [xs, s, m, l, xl, xxl, xxxl, fallback],
      DeviceSize.s => [s, m, l, xl, xxl, xxxl, fallback],
      DeviceSize.m => [m, l, xl, xxl, xxxl, fallback],
      DeviceSize.l => [l, xl, xxl, xxxl, fallback],
      DeviceSize.xl => [xl, xxl, xxxl, fallback],
      DeviceSize.xxl => [xxl, xxxl, fallback],
      DeviceSize.xxxl => [xxxl, fallback],
    };

    for (final v in chain) {
      if (v != null) return v;
    }
    // Practically unreachable because `fallback` is required.
    throw StateError('pick<$T>: all options were null');
  }

  /// Pick with orientation overrides.
  T pickWithOrientation<T>({
    // portrait-only values
    T? xxsPortrait,
    T? xsPortrait,
    T? sPortrait,
    T? mPortrait,
    T? lPortrait,
    T? xlPortrait,
    T? xxlPortrait,
    T? xxxlPortrait,

    // landscape-only values
    T? xxsLandscape,
    T? xsLandscape,
    T? sLandscape,
    T? mLandscape,
    T? lLandscape,
    T? xlLandscape,
    T? xxlLandscape,
    T? xxxlLandscape,

    required T fallback,
  }) {
    if (isPortrait) {
      return pick<T>(
        xxs: xxsPortrait,
        xs: xsPortrait,
        s: sPortrait,
        m: mPortrait,
        l: lPortrait,
        xl: xlPortrait,
        xxl: xxlPortrait,
        xxxl: xxxlPortrait,
        fallback: fallback,
      );
    } else {
      return pick<T>(
        xxs: xxsLandscape,
        xs: xsLandscape,
        s: sLandscape,
        m: mLandscape,
        l: lLandscape,
        xl: xlLandscape,
        xxl: xxlLandscape,
        xxxl: xxxlLandscape,
        fallback: fallback,
      );
    }
  }

  String getPrintable() {
    return '\n\n\n ${jsonEncode(<String, String>{'size': size.toString(), 'height': height.toString(), 'width': width.toString(), 'device': device.toString(), 'text': textBucket.toString()})}\n\n\n';
  }
}

extension ResponsiveRead on BuildContext {
  Responsive get responsive => Responsive._(breakpoints); //this.breakpoints
}
