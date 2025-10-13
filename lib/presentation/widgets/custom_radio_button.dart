import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'custom_text_widget.dart';

class RadioOption<T> {
  final T value;
  final String label;
  const RadioOption({required this.value, required this.label});
}

class CustomRadioGroup<T> extends StatelessWidget {
  /// Header (top-left) text, optional
  final String? labelText;

  /// Show a red * if required
  final bool isRequired;

  /// Optional widget on the right side of the header row (e.g., "Edit")
  final Widget? rightLabelWidget;

  /// Spacing around the whole control
  final double padding;

  /// When false, disables interaction
  final bool enabled;

  /// Error message shown below radios
  final String? errorText;

  /// Layout direction of radio options
  final Axis direction;

  /// Space between options
  final double gap;

  /// Options to render
  final List<RadioOption<T>> options;

  /// Currently selected value
  final T? groupValue;

  /// Called when selection changes
  final ValueChanged<T?> onChanged;

  /// Optional height for each radio tile (only used in vertical mode)
  final double? itemHeight;

  const CustomRadioGroup({
    super.key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.labelText,
    this.isRequired = false,
    this.rightLabelWidget,
    this.padding = 8,
    this.enabled = true,
    this.errorText,
    this.direction = Axis.horizontal,
    this.gap = 12,
    this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    
    final radios = options.map((o) {
      final tile = _RadioChip<T>(
        label: o.label,
        value: o.value,
        groupValue: groupValue,
        enabled: enabled,
        onChanged: onChanged,
      );

      if (direction == Axis.horizontal) {
        return Padding(
          // padding: EdgeInsets.only(right: gap.w),
          padding: EdgeInsets.only(right: r.space(gap)),
          child: tile,
        );
      }
      return Padding(
        // padding: EdgeInsets.only(bottom: gap.h),
        padding: EdgeInsets.only(bottom: r.space(gap)),
        child: SizedBox(height: itemHeight, child: Align(alignment: Alignment.centerLeft, child: tile)),
      );
    }).toList();

    return Padding(
      // padding: EdgeInsets.all(padding.r),
      padding: EdgeInsets.all(r.space(padding)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            Padding(
              // padding: EdgeInsets.only(bottom: 5.h),
              padding: EdgeInsets.only(bottom: r.space(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    // CustomTextWidget(labelText!, style: labelStyle),
                    CustomTextWidget(labelText!, style: Theme.of(context).textTheme
        .rLabelMedium(context)!),
                    // if (isRequired) CustomTextWidget(' *', style: errorStyle),
                    if (isRequired) CustomTextWidget('*', style: Theme.of(context).textTheme
        .rError(context)!.copyWith(fontSize: r.font(20))),
                  ]),
                  rightLabelWidget ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ],
          if (direction == Axis.horizontal)
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              // spacing: gap.w,
              spacing: r.space(gap),
              // runSpacing: (gap / 2).h,
              runSpacing: r.space(gap/2),
              children: radios,
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: radios,
            ),
          if (errorText != null && errorText!.isNotEmpty)
            Padding(
              // padding: EdgeInsets.only(top: 6.h),
              padding: EdgeInsets.only(top: r.space(6)),
              // child: CustomTextWidget(errorText!, style: errorStyle),
              child: CustomTextWidget(errorText!, style: Theme.of(context).textTheme
        .rError(context)!),
            ),
        ],
      ),
    );
  }
}

/// A compact radio + label that looks good in rows or columns.
/// Uses Theme radio, but with a touch target and disabled styling.
class _RadioChip<T> extends StatelessWidget {
  final String label;
  final T value;
  final T? groupValue;
  final bool enabled;
  final ValueChanged<T?> onChanged;

  const _RadioChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final selected = value == groupValue;

    return InkWell(
      onTap: enabled ? () => onChanged(value) : null,
      // borderRadius: BorderRadius.circular(8.r),
      borderRadius: BorderRadius.circular(r.px(8)),
      child: Padding(
        // padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: r.space(6), vertical: r.space(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: enabled ? onChanged : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            // SizedBox(width: 4.w),
            SizedBox(width: r.px(4)),
            Opacity(
              opacity: enabled ? 1.0 : 0.5,
              child: CustomTextWidget(
                label,
                style: Theme.of(context).textTheme
                    .rLabelMedium(context)!.copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w400)
                // labelStyle.copyWith(
                //   fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
