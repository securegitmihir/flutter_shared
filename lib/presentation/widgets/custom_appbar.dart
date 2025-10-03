import 'package:assisted_living/responsive/responsive.dart';
import 'package:assisted_living/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// A widget to display before the toolbar's [title].
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  final bool automaticallyImplyLeading;
  final Widget? title;

  /// A list of Widgets to display in a row after the [title] widget.
  final List<Widget>? actions;

  /// The fill color to use for an app bar's [Material].
  final Color? backgroundColor;

  /// The default color for [Text] and [Icon]s within the app bar.
  final Color? foregroundColor;

  /// The color, opacity, and size to use for the icons that appear in the app
  /// bar's [actions].
  final IconThemeData? actionsIconTheme;

  /// Whether this app bar is being displayed at the top of the screen.
  final bool primary;

  /// Whether the title should be centered.
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final double? titleSpacing;
  final Gradient? gradient;

  const CustomAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle = false,
    this.bottom,
    this.titleSpacing,
    this.gradient
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      title: title,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: gradient != null
          ? Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
      )
          : null,
      actions: actions
          ?.map(
            (w) => Padding(
              // padding: EdgeInsets.only(right: 20.w),
              padding: EdgeInsets.only(right: r.space(20)),
              child: w,
            ),
          )
          .toList(),
      actionsIconTheme:
          actionsIconTheme ??
          // IconThemeData(size: 24.sp, color: AppColors.btnTextColor),
          IconThemeData(size: r.font(24), color: AppColors.btnTextColor),
    );
  }
}
