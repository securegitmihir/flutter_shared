import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nav_observer..dart';

/// Locks orientations while this screen is top-most; restores when covered/popped.
class TopOfStackOrientationLock extends StatefulWidget {
  const TopOfStackOrientationLock({
    super.key,
    required this.orientations,
    required this.child,
  });

  final List<DeviceOrientation> orientations;
  final Widget child;

  @override
  State<TopOfStackOrientationLock> createState() =>
      _TopOfStackOrientationLockState();
}

class _TopOfStackOrientationLockState extends State<TopOfStackOrientationLock>
    with RouteAware {
  PageRoute<dynamic>? _route;

  // Set this to your true app-wide default orientations.
  static const List<DeviceOrientation> _appDefault = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      _route = route;
      appRouteObserver.subscribe(this, route); // 👈 subscribe
    }
  }

  @override
  void dispose() {
    if (_route != null) {
      appRouteObserver.unsubscribe(this); // 👈 unsubscribe
    }
    super.dispose();
  }

  // === This page becomes visible (on top) ===
  @override
  void didPush() => _apply();
  @override
  void didPopNext() => _apply();

  // === Another page covers this OR we leave ===
  @override
  void didPushNext() => _restore();
  @override
  void didPop() => _restore();

  Future<void> _apply() =>
      SystemChrome.setPreferredOrientations(widget.orientations);

  Future<void> _restore() =>
      SystemChrome.setPreferredOrientations(_appDefault);

  @override
  Widget build(BuildContext context) => widget.child;
}
