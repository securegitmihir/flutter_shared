import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/app_colors.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key, this.size, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      color: color ?? Colors.white,
      child: Center(
        child: CupertinoActivityIndicator(
          color: AppColors.primaryColor,
          // radius: size ?? 12.r,
          radius: size ?? r.px(12),
        ),
      ),
    );
  }
}
