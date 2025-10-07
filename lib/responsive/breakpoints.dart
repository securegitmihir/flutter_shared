import 'package:flutter/widgets.dart';

class AppBreakpoints {
  AppBreakpoints._();
  static const double xtraShortMax = 399;
  static const double shortMin = 440;
  static const double mediumMin = 640;
  static const double largeMin = 820;
  static const double xtraLargeMin = 1080;
}

enum DisplaySize { compact, medium, large, largest }

enum DeviceType { phone, tablet }

enum TextSize { small, normal, large, xlarge, largest }

enum DeviceSize { xxs, xs, s, m, l, xl, xxl, xxxl }

enum ScreenOrient { portrait, landscape }

@immutable
class BreakpointSnapshot {
  const BreakpointSnapshot({
    required this.size,
    required this.dpr,
    required this.textScale,
    required this.device,
    required this.text,
    required this.orientation,
    required this.deviceType,
  });

  final Size size;
  final double dpr;
  final double textScale;
  final DeviceSize device;
  final DeviceType deviceType;
  final TextSize text;
  final ScreenOrient orientation;
}

extension BreakpointRead on BuildContext {
  BreakpointSnapshot get breakpoints {
    final mq = MediaQuery.of(this);

    // width → device bucket
    final w = mq.size.width;

    bool isTablet = (w >= 600) && (mq.size.shortestSide >= 600);
    final DeviceType deviceType = isTablet
        ? DeviceType.tablet
        : DeviceType.phone;

    final DisplaySize displaySize;
    if (w >= AppBreakpoints.xtraLargeMin) {
      displaySize = DisplaySize.largest;
    } else if (w >= AppBreakpoints.largeMin) {
      displaySize = DisplaySize.large;
    } else if (w >= AppBreakpoints.mediumMin) {
      displaySize = DisplaySize.medium;
    } else {
      displaySize = DisplaySize.compact;
    }

    // textScale → text bucket
    final ts = mq.textScaleFactor;
    final TextSize text;
    if (ts <= 0.85) {
      text = TextSize.small;
    } else if (ts <= 1.15) {
      text = TextSize.normal;
    } else if (ts <= 1.35) {
      text = TextSize.large;
    } else if (ts <= 1.75) {
      text = TextSize.xlarge;
    } else {
      text = TextSize.largest;
    }

    final DeviceSize deviceSize = _generateDeviceSize(displaySize, text);

    final ScreenOrient o = mq.orientation == Orientation.portrait
        ? ScreenOrient.portrait
        : ScreenOrient.landscape;

    return BreakpointSnapshot(
      size: mq.size,
      dpr: mq.devicePixelRatio,
      textScale: ts,
      device: deviceSize,
      text: text,
      orientation: o,
      deviceType: deviceType,
    );
  }

  DeviceSize _generateDeviceSize(DisplaySize displaySize, TextSize textSize) {
    if (displaySize == DisplaySize.compact) {
      if (textSize == TextSize.small) return DeviceSize.xl;
      if (textSize == TextSize.normal) return DeviceSize.l;
      if (textSize == TextSize.large) return DeviceSize.s;
      if (textSize == TextSize.xlarge) return DeviceSize.xs;
      return DeviceSize.xxs; // largest text
    }

    if (displaySize == DisplaySize.medium) {
      if (textSize == TextSize.small) return DeviceSize.xl;
      if (textSize == TextSize.normal) return DeviceSize.xl;
      if (textSize == TextSize.large) return DeviceSize.m;
      if (textSize == TextSize.xlarge) return DeviceSize.s;
      return DeviceSize.xs;
    }

    if (displaySize == DisplaySize.large) {
      if (textSize == TextSize.small) return DeviceSize.xxl;
      if (textSize == TextSize.normal) return DeviceSize.xl;
      if (textSize == TextSize.large) return DeviceSize.l;
      if (textSize == TextSize.xlarge) return DeviceSize.m;
      return DeviceSize.s;
    }

    // DisplaySize.largest
    if (textSize == TextSize.small) return DeviceSize.xxxl;
    if (textSize == TextSize.normal) return DeviceSize.xxl;
    if (textSize == TextSize.large) return DeviceSize.xl;
    if (textSize == TextSize.xlarge) return DeviceSize.l;
    return DeviceSize.m;
  }
}
