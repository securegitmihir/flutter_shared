import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/app_colors.dart';
import '../../app/configuration/constants.dart';
import '../../services/font_styles.dart';
import '../../utilities/utility_functions.dart';
import 'custom_text_widget.dart';
import 'loading_indicator_widget.dart';

typedef ChangeDropdownCallBack = Function(dynamic value);

class CustomDropdownWidget extends StatefulWidget {
  const CustomDropdownWidget({
    super.key,
    required this.dataList,
    required this.onChange,
    this.borderRadius,
    this.listItemTextStyle,
    this.headerTextStyle,
    required this.hintText,
    this.labelText,
    this.showBorder = true,
    this.enabled,
    this.initialItem,
    required this.error,
    required this.showError,
    this.isRequired = false,
    this.isDataLoading = false,
    this.isDataError = false,
    this.labelStyle,
    this.headerPadding,
    this.customSuffixIcon,
    this.isColored = false,
    this.hideSelectedFieldWhenExpanded = false,
  });

  final List<dynamic> dataList;
  final ChangeDropdownCallBack onChange;
  final TextStyle? headerTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? listItemTextStyle;
  final double? borderRadius;
  final String hintText;
  final String? labelText;
  final bool showBorder;
  final bool? enabled;
  final dynamic initialItem;
  final String? error;
  final bool showError;
  final bool isRequired;
  final bool isDataLoading;
  final bool isDataError;
  final EdgeInsets? headerPadding;
  final Widget? customSuffixIcon;
  final bool isColored;
  final bool hideSelectedFieldWhenExpanded;

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  dynamic selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.dataList.contains(widget.initialItem)
        ? widget.initialItem
        : null;
  }

  @override
  void didUpdateWidget(CustomDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialItem != oldWidget.initialItem) {
      setState(() {
        selectedItem = widget.dataList.contains(widget.initialItem)
            ? widget.initialItem
            : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    OverlayPortalController overlayPortalController = OverlayPortalController();
    return Theme(
      data: ThemeData(
        iconTheme: IconThemeData(
          color: widget.isColored && !overlayPortalController.isShowing
              ? Colors.white
              : AppColors.textColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelText != null
              ? Padding(
                  // padding: EdgeInsets.only(bottom: 5.h),
                  padding: EdgeInsets.only(bottom: r.space(5)),
                  child: Row(
                    children: [
                      CustomTextWidget(
                        widget.labelText!,
                        // style: widget.labelStyle ?? labelStyle,
                        style:
                            widget.labelStyle ??
                            Theme.of(context).textTheme.rLabelMedium(context)!,
                      ),
                      widget.isRequired
                          // ? CustomTextWidget(' *', style: errorStyle)
                          ? CustomTextWidget(
                              '*',
                              style: Theme.of(context).textTheme
                                  .rError(context)!
                                  .copyWith(fontSize: r.font(20)),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          GestureDetector(
            onTap: () {
              UtilityFunctions.closeKeyboard();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MediaQuery(
                //   data: MediaQueryData.fromView(View.of(context))
                //       .copyWith(textScaler: TextScaler.noScaling),
                //   child:
                CustomDropdown<dynamic>(
                  overlayController: overlayPortalController,
                  initialItem: selectedItem,
                  maxlines: 2,
                  hideSelectedFieldWhenExpanded:
                      widget.hideSelectedFieldWhenExpanded,
                  closedHeaderPadding:
                      widget.headerPadding ??
                      // EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      EdgeInsets.symmetric(
                        horizontal: r.space(15),
                        vertical: r.space(10),
                      ),
                  enabled: widget.enabled ?? false,
                  disabledDecoration: CustomDropdownDisabledDecoration(
                    fillColor: AppColors.dropdownBorderColor,
                    suffixIcon: widget.isDataLoading
                        // ? LoadingIndicatorWidget(size: 10.r)
                        ? LoadingIndicatorWidget(size: r.px(10))
                        : widget.isDataError
                        ? const Icon(Icons.error, color: Colors.red)
                        : widget.customSuffixIcon,
                    // hintStyle: widget.headerTextStyle ?? hintStyle,
                    hintStyle:
                        widget.headerTextStyle ??
                        Theme.of(context).textTheme.rHint(context)!,
                    // headerStyle: widget.headerTextStyle ?? textStyle,
                    headerStyle:
                        widget.headerTextStyle ??
                        Theme.of(context).textTheme.rBodyMedium(context)!,
                    borderRadius:
                        // BorderRadius.circular(widget.borderRadius ?? 4.r),
                        BorderRadius.circular(widget.borderRadius ?? r.px(4)),
                    border: Border.all(
                      // width: 1.w,
                      width: r.px(1),
                      color: widget.showBorder
                          ? AppColors.dropdownBorderColor
                          : Colors.transparent,
                    ),
                  ),
                  hintText: widget.hintText,
                  decoration: CustomDropdownDecoration(
                    // hintStyle: hintStyle,
                    hintStyle: Theme.of(context).textTheme.rHint(context)!,
                    expandedSuffixIcon: widget.customSuffixIcon,
                    closedSuffixIcon: widget.isDataLoading
                        // ? LoadingIndicatorWidget(size: 10.r)
                        ? LoadingIndicatorWidget(size: r.px(10))
                        : widget.isDataError
                        ? const Icon(Icons.error, color: Colors.red)
                        : widget.customSuffixIcon,
                    errorStyle: Theme.of(
                      context,
                    ).textTheme.rError(context)!.copyWith(fontSize: r.font(10)),
                    // kohinoorRegular.copyWith(
                    //     // color: AppColors.errorColor, fontSize: 10.sp),
                    //     color: AppColors.errorColor, fontSize: r.font(10)),
                    closedBorder: Border.all(
                      // width: 1.w,
                      width: r.px(1),
                      color: widget.showBorder
                          ? AppColors.dropdownBorderColor
                          : Colors.transparent,
                    ),
                    closedErrorBorder: Border.all(
                      // width: 1.w,
                      width: r.px(1),
                      color: widget.showBorder
                          ? AppColors.dropdownBorderColor
                          : Colors.transparent,
                    ),
                    closedBorderRadius:
                        // BorderRadius.circular(widget.borderRadius ?? 4.r),
                        BorderRadius.circular(widget.borderRadius ?? r.px(4)),
                    expandedBorderRadius:
                        // BorderRadius.circular(widget.borderRadius ?? 4.r),
                        BorderRadius.circular(widget.borderRadius ?? r.px(4)),
                    searchFieldDecoration: SearchFieldDecoration(
                      // hintStyle: widget.headerTextStyle ?? hintStyle,
                      hintStyle:
                          widget.headerTextStyle ??
                          Theme.of(context).textTheme.rHint(context)!,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          // widget.borderRadius ?? 4.r),
                          widget.borderRadius ?? r.px(4),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.dropdownBorderColor,
                        ),
                      ),
                    ),
                    closedFillColor:
                        widget.isColored && !overlayPortalController.isShowing
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    expandedFillColor:
                        widget.isColored && !overlayPortalController.isShowing
                        ? AppColors.primaryColor
                        : Colors.white,
                  ),
                  items: widget.dataList,
                  hintBuilder: (context, hint, enabled) {
                    return CustomTextWidget(
                      hint,
                      // style: widget.headerTextStyle ?? hintStyle,
                      style:
                          widget.headerTextStyle ??
                          Theme.of(context).textTheme.rHint(context)!,
                    );
                  },
                  listItemBuilder: (context, item, isSelected, onItemSelect) {
                    UtilityFunctions.closeKeyboard();
                    return CustomTextWidget(
                      item.toString().trim(),
                      style:
                          widget.isColored && !overlayPortalController.isShowing
                          ? Theme.of(context).textTheme
                                .rBodyMedium(context)!
                                .copyWith(fontSize: r.font(12))
                          // textStyle.copyWith(
                          //     // color: Colors.white, fontSize: 12.sp)
                          //     color: Colors.white, fontSize: r.font(12))
                          : widget.listItemTextStyle?.copyWith(
                                  color: item == Constants.other
                                      ? AppColors.primaryColor
                                      : widget.listItemTextStyle?.color,
                                ) ??
                                Theme.of(context).textTheme
                                    .rBodyMedium(context)!
                                    .copyWith(fontSize: r.font(12)),
                      // textStyle.copyWith(
                      //     color: item == Constants.other
                      //         ? AppColors.primaryColor
                      //         : textStyle.color),
                    );
                  },
                  headerBuilder: (context, item, isSelected) {
                    return CustomTextWidget(
                      overflow: TextOverflow.ellipsis,
                      item.toString().trim(),
                      style:
                          widget.isColored && !overlayPortalController.isShowing
                          ? Theme.of(context).textTheme
                                .rBodyMedium(context)!
                                .copyWith(fontSize: r.font(12))
                          // textStyle.copyWith(
                          //     // color: Colors.white, fontSize: 12.sp)
                          //     color: Colors.white, fontSize: r.font(12))
                          //     : widget.headerTextStyle ?? textStyle,
                          : widget.headerTextStyle ??
                                Theme.of(context).textTheme
                                    .rBodyMedium(context)!
                                    .copyWith(fontSize: r.font(12)),
                    );
                  },
                  onChanged: (value) {
                    UtilityFunctions.closeKeyboard();
                    setState(() {
                      selectedItem = value;
                    });
                    widget.onChange(value);
                  },
                ),
                // ),
                widget.showError && widget.error != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          // horizontal: 4.w, vertical: 4.h),
                          horizontal: r.px(4),
                          vertical: r.px(4),
                        ),
                        child:
                            // CustomTextWidget(widget.error!, style: errorStyle),
                            CustomTextWidget(
                              widget.error!,
                              style: Theme.of(
                                context,
                              ).textTheme.rError(context)!,
                            ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
