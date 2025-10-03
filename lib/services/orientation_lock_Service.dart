import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class OrientationLock extends StatefulWidget {
  const OrientationLock({
    super.key,
    required this.orientations,
    required this.child,
  });

  /// Allowed orientations while this widget is in the tree
  final List<DeviceOrientation> orientations;
  final Widget child;

  @override
  State<OrientationLock> createState() => _OrientationLockState();
}

class _OrientationLockState extends State<OrientationLock> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(widget.orientations);
  }

  @override
  void dispose() {
    // Restore to "allow all" (or your app’s global default)
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
