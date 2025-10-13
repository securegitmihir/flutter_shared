import 'package:flutter/material.dart';
import '../presentation/widgets/custom_text_widget.dart';
import 'app_colors.dart';

class SnackBarService {
  ////  Get the Scaffold
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static void showErrorSnackBar({required String content, required BuildContext context}) {
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: CustomTextWidget(
          content,
          style: Theme.of(context).textTheme.titleLarge
          // kohinoorRegular.copyWith(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }
}