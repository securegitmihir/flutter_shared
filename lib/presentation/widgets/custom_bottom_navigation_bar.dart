import 'package:assisted_living/responsive/responsive.dart';
import 'package:assisted_living/services/app_colors.dart';
import 'package:flutter/material.dart';


/// One tab item (icon + label + optional badge)
class NavBarItem {
  final IconData icon;
  final IconData? activeIcon; // optional override for active state
  final String label;
  final int? badgeCount; // null = no badge

  const NavBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}

/// A simple, modern bottom nav that supports 2–4 tabs.
/// Controlled: you pass [currentIndex] and [onTap].
class CustomBottomNavBar extends StatelessWidget {
  final List<NavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final double height;
  final double iconSize;
  final double activeIconSize;
  final double elevation;

  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color indicatorColor; // small top indicator color
  final bool showTopIndicator; // tiny active line on top

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 68,
    this.iconSize = 22,
    this.activeIconSize = 24,
    this.elevation = 8,
    this.backgroundColor = AppColors.whiteColor,
    this.activeColor = AppColors.activeNavBarColor,
    this.inactiveColor = AppColors.inactiveNavBarColor,
    this.indicatorColor = AppColors.activeNavBarColor,
    this.showTopIndicator = true,
  }) : assert(
         items.length >= 2 && items.length <= 4,
         'CustomBottomNavBar supports 2, 3, or 4 items only.',
       );

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final h = r.px(height);

    return Material(
      elevation: elevation,
      color: backgroundColor,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: h,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = index == currentIndex;

              return Expanded(
                child: InkWell(
                  splashColor: Colors.black12,
                  onTap: () => onTap(index),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (showTopIndicator)
                        Positioned(
                          top: 0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            height: r.px(3),
                            width: selected ? r.px(28) : 0,
                            decoration: BoxDecoration(
                              color: selected
                                  ? indicatorColor
                                  : Colors.transparent,
                              // borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                      // Icon + label
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected
                                ? (item.activeIcon ?? item.icon)
                                : item.icon,
                            color: selected ? activeColor : inactiveColor,
                            size: r.px((selected ? activeIconSize : iconSize)),
                          ),
                          SizedBox(height: r.px(4)),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: selected
                                ? Theme.of(context).textTheme
                                      .rHeadlineMedium(context)!
                                      .copyWith(fontSize: r.font(18), color: activeColor)
                                : Theme.of(context).textTheme
                                      .rTitleMedium(context)!
                                      .copyWith(fontSize: r.font(18), color: inactiveColor),
                            // kohinoorMedium.copyWith(
                            //   fontSize: selected ? 16.sp : 13.sp,
                            //   fontWeight: FontWeight.w500,
                            //   color: selected ? activeColor : inactiveColor,
                            // ),
                          ),
                        ],
                      ),

                      // Badge
                      if ((item.badgeCount ?? 0) > 0)
                        Positioned(
                          top: 8,
                          right:
                              MediaQuery.of(context).size.width /
                              (items.length * 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${item.badgeCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: r.font(10),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
