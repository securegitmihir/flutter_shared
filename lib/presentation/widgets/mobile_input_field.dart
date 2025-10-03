import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/app_colors.dart';
import '../../services/enum.dart';
import '../../services/font_styles.dart';
import 'custom_text_widget.dart';

class MobileInputField extends StatefulWidget {
  final List<String> mobileCodes;
  // final String mobileCode;
  final Function(String) onCountryCodeSelected;
  final Function(String?) mobileNoChanged;
  final String? selectedCode;
  final String? errorText;
  final bool? enabled;
  final ApiStatus countryCodeStatus;
  final int allowedLength;
  final TextInputAction? textInputAction;

  final TextEditingController? controller;
  final String? initialValue;
  final bool autofocus;

  const MobileInputField({
    super.key,
    required this.mobileCodes,
    required this.onCountryCodeSelected,
    required this.selectedCode,
    required this.mobileNoChanged,
    required this.errorText,
    required this.enabled,
    this.textInputAction,
    this.countryCodeStatus = ApiStatus.idle,
    this.allowedLength = 10,
    this.controller,
    this.initialValue,
    this.autofocus = false,
  });

  @override
  State<MobileInputField> createState() => _MobileInputFieldState();
}

class _MobileInputFieldState extends State<MobileInputField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null && widget.initialValue != null) {
      widget.controller!.text = widget.initialValue!;
      widget.controller!.selection = TextSelection.collapsed(
        offset: widget.initialValue!.length,
      );
    // if (widget.initialValue != null) {
    //   widget.controller?.text = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(covariant MobileInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null) return;

    // If new initialValue is not null, update controller
    if (widget.initialValue != null &&
        widget.initialValue != oldWidget.initialValue) {
      widget.controller!.text = widget.initialValue!;
      widget.controller!.selection = TextSelection.collapsed(
        offset: widget.initialValue!.length,
      );
    }

    // If new initialValue is null but old had a value, clear the field
    if (widget.initialValue == null && oldWidget.initialValue != null) {
      widget.controller!.clear();
      widget.controller!.selection = const TextSelection.collapsed(offset: 0);
    }
    // if(widget.controller != null){
    //   if (widget.controller!.text != widget.initialValue) {
    //     widget.controller!.text = widget.initialValue!;
    //     widget.controller!.selection = TextSelection.collapsed(
    //       offset: widget.initialValue!.length,
    //     );
    //   }
    // }
    if (widget.countryCodeStatus != oldWidget.countryCodeStatus) {}
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: 36.h,
          // height: 48.h,
          height: r.px(48),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(4.r),
            borderRadius: BorderRadius.circular(r.px(4)),
            border: Border.all(color: AppColors.whiteColor),
          ),
          child: Row(
            children: [
              // Country code box
              Container(
                // width: 44.89.w,
                // width: 95.w,
                width: r.px(95),
                // height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.dropdownBorderColor),
                  // borderRadius: BorderRadius.circular(4.r),
                  borderRadius: BorderRadius.circular(r.px(4)),
                ),
                child: widget.countryCodeStatus == ApiStatus.loading
                    ? CupertinoActivityIndicator(
                  color: AppColors.primaryColor,
                  // radius: 10.r,
                  radius: r.px(10),
                )
                    : widget.countryCodeStatus == ApiStatus.failure
                    ? const Icon(
                  Icons.error,
                  color: Colors.red,
                )
                    : DropdownButton<String>(
                  dropdownColor: Colors.white,
                  // padding: EdgeInsets.only(left: 8.w, right: 3.0.w, top: 0, bottom: 0),
                  padding: EdgeInsets.only(left: r.space(8), right: r.space(3), top: r.space(0), bottom: r.space(0)),
                  isExpanded: true,
                  alignment: Alignment.center,
                  isDense: false,
                  // style: textStyle,
                  style: Theme.of(context).textTheme
        .rBodyMedium(context)!.copyWith(fontSize: r.font(14)),
                  value: widget.selectedCode,
                  onChanged: widget.enabled == true
                      ? (String? newValue) {
                    widget.onCountryCodeSelected(newValue!);
                  }
                      : null,
                  underline: const SizedBox.shrink(),
                  items: widget.mobileCodes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomTextWidget(
                        value,
                        overflow: TextOverflow.ellipsis,
                        // style: textStyle,
                        style: Theme.of(context).textTheme
                            .rBodyMedium(context)!.copyWith(fontSize: r.font(14)),
                      ),
                    );
                  }).toList(),
                ),
                // CustomTextWidget(
                //   widget.mobileCodes,
                //   style: TextStyle(color: AppColors.countryCodeTextColor),
                // ),
                // // widget.countryCodeStatus == ApiStatus.loading
                // //     ? CupertinoActivityIndicator(
                // //   color: AppColors.primaryColor,
                // //   radius: 10.r,
                // // )
                // //     : CustomTextWidget(
                // //   widget.mobileCode,
                // //   style: textStyle.copyWith(
                // //     color: AppColors.dropdownBorderColor,
                // //   ),
                // // ),
              ),

              // Gap
              // SizedBox(width: 12.w),
              SizedBox(width: r.px(12)),

              // Mobile Number Box
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dropdownBorderColor),
                    // borderRadius: BorderRadius.circular(4.r),
                    borderRadius: BorderRadius.circular(r.px(4)),
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: widget.controller,
                    initialValue: widget.controller == null ? widget.initialValue : null,
                    keyboardType: TextInputType.phone,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      // contentPadding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                      contentPadding: EdgeInsets.symmetric(vertical: r.space(6), horizontal: r.space(12)),
                    ),
                    enabled: widget.enabled,
                    style: Theme.of(context).textTheme
        .rBodyMedium(context)!.copyWith(fontSize: r.font(16)),
                    // TextStyle(
                    //   color: AppColors.hintTextColor,
                    //   fontSize: 16.sp,
                    // ),
                    textInputAction: widget.textInputAction,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(widget.allowedLength),
                    ],
                    onChanged: (value) => widget.mobileNoChanged(value),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
                  //   child: MediaQuery(
                  //     data: MediaQueryData.fromView(View.of(context)).copyWith(textScaler: TextScaler.noScaling),
                  //     child: TextFormField(
                  //       controller: widget.controller,
                  //       keyboardType: TextInputType.phone,
                  //       textAlignVertical: TextAlignVertical.center,
                  //       decoration: InputDecoration(
                  //         prefixIcon: Container(
                  //           margin: EdgeInsets.only(left: 17.w),
                  //           width: 44.89.w,
                  //           decoration: BoxDecoration(
                  //             border: Border.all(color: AppColors.dropdownBorderColor),
                  //           ),
                  //           child: Text(widget.mobileCode, style: TextStyle(color: AppColors.dropdownBorderColor),)
                  //           // widget.countryCodeStatus == ApiStatus.loading
                  //           //     ? CupertinoActivityIndicator(
                  //           //   color: AppColors.primaryColor,
                  //           //   radius: 10.r,
                  //           // )
                  //           //     : widget.countryCodeStatus == ApiStatus.failure
                  //           //     ? const Icon(
                  //           //   Icons.error,
                  //           //   color: Colors.red,
                  //           // )
                  //           //     : DropdownButton<String>(
                  //           //   dropdownColor: Colors.white,
                  //           //   padding: EdgeInsets.only(left: 8.w, right: 3.0.w, top: 0, bottom: 0),
                  //           //   isExpanded: true,
                  //           //   alignment: Alignment.center,
                  //           //   isDense: false,
                  //           //   style: textStyle,
                  //           //   value: widget.selectedCode,
                  //           //   onChanged: widget.enabled == true
                  //           //       ? (String? newValue) {
                  //           //     widget.onCountryCodeSelected(newValue!);
                  //           //   }
                  //           //       : null,
                  //           //   underline: const SizedBox.shrink(),
                  //           //   items: widget.mobileCodes.map((String value) {
                  //           //     return DropdownMenuItem<String>(
                  //           //       value: value,
                  //           //       child: CustomTextWidget(
                  //           //         value,
                  //           //         overflow: TextOverflow.ellipsis,
                  //           //         style: textStyle,
                  //           //       ),
                  //           //     );
                  //           //   }).toList(),
                  //           // ),
                  //         ),
                  //         alignLabelWithHint: true,
                  //         labelStyle: labelStyle,
                  //         border: InputBorder.none,
                  //         floatingLabelBehavior: FloatingLabelBehavior.never,
                  //       ),
                  //       enabled: widget.enabled,
                  //       style: textStyle,
                  //       textInputAction: widget.textInputAction,
                  //       enableInteractiveSelection: true,
                  //       autofocus: false,
                  //       inputFormatters: [
                  //         FilteringTextInputFormatter.digitsOnly,
                  //         LengthLimitingTextInputFormatter(widget.allowedLength),
                  //       ],
                  //       onChanged: (value) => widget.mobileNoChanged(value),
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            // padding: EdgeInsets.all(4.r),
            padding: EdgeInsets.all(r.space(4)),
            // child: CustomTextWidget(widget.errorText!, style: errorStyle),
            child: CustomTextWidget(widget.errorText!,
    style: Theme.of(context).textTheme
        .rError(context)!),
          ),
      ],
    );
  }
}
