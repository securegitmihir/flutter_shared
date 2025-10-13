import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/app_colors.dart';
import 'custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final bool isValid;
  final Function onClick;
  final bool isLoading;
  final bool isBorderedButton;
  final IconData? icon;
  final double? verticalPadding;
  final double? horizontalPadding;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.isValid,
    required this.onClick,
    required this.isLoading,
    this.isBorderedButton = false,
    this.icon,
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 17.w),
      margin: EdgeInsets.symmetric(horizontal: r.space(17)),
      width: r.px(398),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // fixedSize: Size(398.w, 48.h),
          // fixedSize: Size(r.px(398), r.px(48)),
          backgroundColor: isBorderedButton
              ? AppColors.primaryColor
              : Colors.white,
          foregroundColor: isBorderedButton ? Colors.white : Colors.purple[800],
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(6.r),
            borderRadius: BorderRadius.circular(r.px(6)),
            side: BorderSide(
              color: isBorderedButton
                  ? AppColors.primaryColor
                  : Colors.transparent,
            ),
          ),
          // padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 36.w),
          padding: EdgeInsets.symmetric(vertical: r.space(7), horizontal: r.space(36)),
        ),

        // to use it as a bordered button
        onPressed: isValid && !isLoading
            ? () {
                onClick();
              }
            : null,
        child: isLoading
            ? const CupertinoActivityIndicator(color: AppColors.primaryColor)
            : FittedBox(
          fit: BoxFit.scaleDown,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon != null
                        ? Padding(
                            // padding: EdgeInsets.only(right: 15.w),
                            padding: EdgeInsets.only(right: r.space(15)),
                            child: Icon(
                              icon,
                              color: isBorderedButton
                                  ? AppColors.primaryColor
                                  : Colors.white,
                            ),
                          )
                        : const SizedBox.shrink(),
                    CustomTextWidget(
                      buttonText,
                      style: Theme.of(context).textTheme
        .rBtn(context)!,
                      // kohinoorRegular.copyWith(
                      //   fontSize: 24.sp,
                      //   fontWeight: FontWeight.w400,
                      // ),
                      textAlign: TextAlign.center,
                      maxLines: 1,                // <-- keep it on one line
                      overflow: TextOverflow.ellipsis, // <-- avoid spill
                    ),
                  ],
                ),
            ),
      ),
    );
  }
}
