import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:assisted_living/bloc/auth/auth_bloc.dart';
import 'package:assisted_living/presentation/widgets/custom_button.dart';
import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/app_colors.dart';
import '../../services/font_styles.dart';
import '../../services/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(height: 180.h),
                SizedBox(height: r.px(180)),
                // Image.asset("assets/images/logo.png", height: 42.h, width: 189.w),
                Image.asset("assets/images/logo.png", height: r.px(42), width: r.px(189),),
                // SizedBox(height: 25.h),
                SizedBox(height: r.px(25)),
                CustomTextWidget(
                  Strings.moto,
                  style:
                  Theme.of(context).textTheme
                      .rBodyMedium(context)!.copyWith(fontSize: r.font(32)),
                  // kohinoorRegular.copyWith(
                  //   fontSize: 32.sp,
                  //   color: AppColors.motoColor,
                  //   fontWeight: FontWeight.w400,
                  // ),
                  textAlign: TextAlign.center,
                ),
                // SizedBox(height: 34.h),
                SizedBox(height: r.px(34)),
                // Image.asset("assets/images/splash.png", height: 221.h, width: 299.w),
                Image.asset("assets/images/splash.png", height: r.px(221), width: r.px(299),),
                // SizedBox(height: 34.h),
                SizedBox(height: r.px(34)),
                CustomTextWidget(
                  Strings.tagLine,
                  style:
                  Theme.of(context).textTheme
                      .rBodyMedium(context)!.copyWith(fontSize: r.font(24)),
                  // kohinoorRegular.copyWith(
                  //   fontSize: 24.sp,
                  //   color: AppColors.lightTextColor,
                  //   fontWeight: FontWeight.w400
                  // ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              // padding: EdgeInsets.all(2.w),
              padding: EdgeInsets.all(r.space(2)),
              child:
              CustomButton(
                key: const Key('getStarted'),
                buttonText: Strings.getStarted,
                isValid: true,
                onClick: () {
                  final isLoggedIn = context.read<AuthBloc>().state.isLoggedIn;
                  if (isLoggedIn) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.profileSetup, (_) => false);
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                  // Navigator.pushNamed(context, AppRoutes.login);
                },
                isLoading: false,
              ),
            ),
            // SizedBox(height: 20.h),
            SizedBox(height: r.px(20)),
          ],
        ),
      ),
    );
  }
}
