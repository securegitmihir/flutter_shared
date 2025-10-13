import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/app_colors.dart';
import 'custom_text_widget.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final Function(String?) onChanged;
  final String? errorText;
  final bool? enabled;
  final String? hintText;
  final String? initialValue;
  final bool? numericKeyboard;
  final bool? allowPasting;
  final bool isLoading;
  final double padding;
  final TextInputAction
  textInputAction; // so that in multi step forms i can add the desired next action
  final TextInputType
  textInputType; // so that i can reduce the further validations by  limiting the user on input
  final TextCapitalization
  textCapitalization; // so that i can handle the text capitalization as the user enter the value in the text field
  final int maxLines;
  final List<TextInputFormatter>?
  inputFormatter; // same as above - to limit the
  final Icon? suffixIcon;
  final bool isRequired;
  final Widget? rightLabelWidget;
  final bool autoFocus;
  final int? maxLength;
  final InputDecoration? textDecoration;
  final TextAlign? textAlign;
  final VoidCallback? onTap;
  final double? height;

  const CustomTextField({
    super.key,
    this.labelText,
    this.controller,
    required this.onChanged,
    this.errorText,
    this.enabled,
    this.hintText,
    this.initialValue,
    this.numericKeyboard,
    this.allowPasting,
    this.isLoading = false,
    this.padding = 8,
    this.maxLines = 1,
    this.inputFormatter,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.isRequired = false,
    this.rightLabelWidget,
    this.autoFocus = false, // to handle the asterisk sign
    this.maxLength,
    this.textDecoration,
    this.textAlign,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    if (initialValue != null) controller?.text = initialValue!;
    return Padding(
      // padding: EdgeInsets.all(padding.r),
      padding: EdgeInsets.all(r.space(padding)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText != null
              ? Padding(
                  // padding: EdgeInsets.only(bottom: 5.h),
                  padding: EdgeInsets.only(bottom: r.space(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // CustomTextWidget(labelText!, style: labelStyle),
                          CustomTextWidget(labelText!, style: Theme.of(context).textTheme
                              .rLabelMedium(context)!),
                          isRequired
                              // ? CustomTextWidget(' *', style: errorStyle)
                              ? CustomTextWidget('*', style: Theme.of(context).textTheme
                              .rError(context)!.copyWith(fontSize: r.font(20)))
                              : const SizedBox.shrink(),
                        ],
                      ),
                      rightLabelWidget ?? const SizedBox.shrink(),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          // MediaQuery(
          //   data: MediaQueryData.fromView(
          //     View.of(context),
          //   ).copyWith(textScaler: TextScaler.noScaling),
          //   child:
            height != null
                ? SizedBox(
                    height: height,
                    child: TextFormField(
                      autofocus: autoFocus,
                      readOnly: onTap != null,
                      maxLength: maxLength,
                      maxLines: maxLines,
                      initialValue: initialValue,
                      textCapitalization: textCapitalization,
                      textAlign: textAlign ?? TextAlign.left,
                      inputFormatters: inputFormatter,
                      textInputAction: textInputAction,
                      keyboardType: numericKeyboard ?? false
                          ? const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            )
                          : textInputType,
                      enabled: enabled ?? false,
                      // style: textStyle,
                      style: Theme.of(context).textTheme
                          .rBodyMedium(context)!,
                      enableInteractiveSelection: allowPasting ?? true,
                      onChanged: (value) {
                        onChanged(value);
                      },
                      onTap: onTap,
                      controller: controller,
                      decoration:
                          textDecoration ??
                          InputDecoration(
                            suffixIcon: isLoading
                                ? const CupertinoActivityIndicator(
                                    color: AppColors.primaryColor,
                                  )
                                : suffixIcon ?? const SizedBox.shrink(),
                            // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: r.space(1),
                              ),
                            ),
                            errorMaxLines: 2,
                            hintText: hintText,
                            // hintStyle: hintStyle,
                            hintStyle: Theme.of(context).textTheme
                                .rHint(context)!,
                            // errorStyle: errorStyle,
                            errorStyle: Theme.of(context).textTheme
                                .rError(context)!,
                            // border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.textBoxColor, width: 1.w)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderColor,
                                width: r.space(1),
                              ),
                            ),
                            // contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: r.space(15),
                              vertical: r.space(10),
                            ),
                            // errorText: errorText,
                          ),
                    ),
                  )
                : TextFormField(
                    autofocus: autoFocus,
                    readOnly: onTap != null,
                    maxLength: maxLength,
                    maxLines: maxLines,
                    initialValue: initialValue,
                    textCapitalization: textCapitalization,
                    textAlign: textAlign ?? TextAlign.left,
                    inputFormatters: inputFormatter,
                    textInputAction: textInputAction,
                    keyboardType: numericKeyboard ?? false
                        ? const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          )
                        : textInputType,
                    enabled: enabled ?? false,
                    // style: textStyle,
                    style: Theme.of(context).textTheme
                        .rBodyMedium(context)!,
                    enableInteractiveSelection: allowPasting ?? true,
                    onChanged: (value) {
                      onChanged(value);
                    },
                    onTap: onTap,
                    controller: controller,
                    decoration:
                        textDecoration ??
                        InputDecoration(
                          suffixIcon: isLoading
                              ? const CupertinoActivityIndicator(
                                  color: AppColors.primaryColor,
                                )
                              : suffixIcon ?? const SizedBox.shrink(),
                          // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: r.space(1),
                            ),
                          ),
                          errorMaxLines: 2,
                          hintText: hintText,
                          // hintStyle: hintStyle,
                          hintStyle: Theme.of(context).textTheme
                              .rHint(context)!,
                          // errorStyle: errorStyle,
                          errorStyle: Theme.of(context).textTheme
                              .rError(context)!,
                          // border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.textBoxColor, width: 1.w)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                              width: r.space(1),
                            ),
                          ),
                          // contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: r.space(15),
                            vertical: r.space(10),
                          ),
                          errorText: errorText,
                        ),
                  ),
          // ),
          if (errorText != null && errorText!.isNotEmpty)
            // MediaQuery(
            //   data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            //   child:
            Padding(
              // padding: EdgeInsets.only(top: 3.h, left: 4.w),
              padding: EdgeInsets.only(top: r.space(3), left: r.space(4)),
              // child: Text(errorText!, style: errorStyle),
              child: Text(errorText!, style: Theme.of(context).textTheme
                  .rError(context)!),
            ),
          // ),
        ],
      ),
    );
  }
}
