import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../presentation/widgets/custom_text_widget.dart';
import 'app_colors.dart';
import 'font_styles.dart';

class SnackBarService {
  ////  Get the Scaffold
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static void showErrorSnackBar({required String content}) {
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: CustomTextWidget(
          content,
          style: kohinoorRegular.copyWith(fontSize: 16.sp),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }
}