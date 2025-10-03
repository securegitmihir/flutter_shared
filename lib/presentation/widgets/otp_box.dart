import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/app_colors.dart';

class OtpBox extends StatelessWidget {
  const OtpBox({
    super.key,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.prevFocus,
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FocusNode? prevFocus;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return SizedBox(
      // width: 56.w,
      width: r.px(56),
      // height: 56.h,
      height: r.px(56),
      child: DecoratedBox(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8.r),
          borderRadius: BorderRadius.circular(r.px(8)),
          border: Border.all(color: AppColors.otpBoxColor),
          color: Colors.white,
        ),
        child: Center(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            // style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            style: Theme.of(context).textTheme
                .rBodyMedium(context)!.copyWith(fontSize: r.font(20)),
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
            onChanged: (val) {
              onChanged?.call(val);
              if (val.isNotEmpty) {
                nextFocus?.requestFocus();
              } else {
                prevFocus?.requestFocus();
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
          ),
        ),
      ),
    );
  }
}
