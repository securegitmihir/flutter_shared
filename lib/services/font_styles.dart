import 'package:flutter/material.dart';

import 'app_colors.dart';

const fontKohinoorBold = "KohinoorDevanagari-Bold";
const fontKohinoorLight = "KohinoorDevanagari-Light";
const fontKohinoorMedium = "KohinoorDevanagari-Medium";
const fontKohinoorRegular = "KohinoorDevanagari-Regular";
const fontKohinoorSemiBold = "KohinoorDevanagari-Semibold";

const kohinoorBold = TextStyle(
  fontFamily: fontKohinoorBold,
);

const kohinoorMedium = TextStyle(
  fontFamily: fontKohinoorMedium,
);

const kohinoorRegular = TextStyle(
  fontFamily: fontKohinoorRegular,
);

const kohinoorLight = TextStyle(
  fontFamily: fontKohinoorLight,
);

const kohinoorSemiBold = TextStyle(
  fontFamily: fontKohinoorSemiBold,
);

TextStyle hintStyle = kohinoorRegular.copyWith(
  // fontSize: 14.sp,
  color: AppColors.hintTextColor,
);

// TextStyle textStyle = kohinoorMedium.copyWith(fontSize: 16.sp, color: AppColors.textColor);
TextStyle textStyle = kohinoorMedium.copyWith(
    // fontSize: 16.sp,
    color: AppColors.textColor);
TextStyle darkTextStyle = kohinoorSemiBold.copyWith(
    // fontSize: 16.sp,
    color: AppColors.darkTextColor);
TextStyle btnTextStyle = kohinoorRegular.copyWith(
    // fontSize: 24.sp,
    fontWeight: FontWeight.w400, color: AppColors.darkTextColor);

TextStyle errorStyle = kohinoorRegular.copyWith(
  color: AppColors.errorColor,
  // fontSize: 12.sp,
  fontWeight: FontWeight.w400,
);

TextStyle labelStyle = kohinoorRegular.copyWith(
  color: AppColors.primaryColor,
  fontSize: 14.sp,
);
OutlineInputBorder errorBorder = OutlineInputBorder(borderSide: BorderSide(color: AppColors.errorColor,
    // width: 1.8.w
));
