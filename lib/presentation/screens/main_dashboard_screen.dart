import 'dart:io';
import 'dart:math' as math;

import 'package:assisted_living/presentation/widgets/custom_appbar.dart';
import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/routes/app_routes.dart';
import '../../services/app_colors.dart';
import '../../services/strings.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/image_picker_helper.dart';
import '../widgets/text_fit.dart';
import 'contact_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  final String username;
  final String gender;
  const MainDashboardScreen({
    super.key,
    required this.username,
    required this.gender,
  });

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _index = 0;
  File? _avatarFile;
  String _versionLabel = '';

  final _pages = const [
    Center(child: CustomTextWidget('Home')),
    Center(child: CustomTextWidget('Reminder')),
    Center(child: CustomTextWidget('Schedule')),
    Center(child: CustomTextWidget('Insights')),
  ];

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _versionLabel = '${info.version}.${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          top: true,
          bottom: false, // we pin the footer ourselves
          child: Stack(
            children: [
              // ===== Scrollable content =====
              Positioned.fill(
                child: ListView(
                  padding: EdgeInsets.only(bottom: r.px(56)),
                  children: [
                    // ---- Header ----
                    DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(r.space(12)),
                        child: Row(
                          children: [
                            AvatarPicker(
                              radius: r.px(40),
                              file: _avatarFile,
                              onTap: () async {
                                final f =
                                    await ImagePickerHelper.pickImageWithSheet(
                                      context,
                                      allowEdit: true,
                                    );
                                if (!mounted) return;
                                if (f != null) setState(() => _avatarFile = f);
                              },
                            ),
                            SizedBox(width: r.px(16)),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final style = Theme.of(context).textTheme
                                      .rBodyMedium(context)!
                                      .copyWith(fontSize: r.font(20));

                                  final editIconSize = r.px(18);
                                  final gap = r.px(6);
                                  final nameMaxWidth =
                                      (constraints.maxWidth -
                                              editIconSize -
                                              gap)
                                          .clamp(0.0, constraints.maxWidth);

                                  final display = truncateToFit(
                                    text: widget.username,
                                    style: style,
                                    // maxWidth: constraints.maxWidth,
                                    maxWidth: nameMaxWidth,
                                    textDirection: Directionality.of(context),
                                  );
                                  // return CustomTextWidget(
                                  //   display,
                                  //   style: style,
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.clip,
                                  //   softWrap: false,
                                  return Row(
                                    children: [
                                      // name (trimmed to fit)
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: nameMaxWidth,
                                        ),
                                        child: CustomTextWidget(
                                          display,
                                          style: style,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                        ),
                                      ),
                                      SizedBox(width: gap),
                                      // pencil
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.profileSetup,
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(
                                          r.px(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(r.px(4)),
                                          child: Icon(
                                            Icons.edit,
                                            size: editIconSize,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ---- Sections ----
                    _SectionTitle('General'),
                    _NavTile(
                      icon: Icons.add,
                      label: Strings.addMember,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.addMember);
                      },
                    ),
                    _NavTile(
                      icon: Icons.note_alt_sharp,
                      label: Strings.diary,
                      onTap: () => Navigator.pop(context),
                    ),
                    _NavTile(
                      icon: Icons.settings,
                      label: Strings.settings,
                      onTap: () => Navigator.pop(context),
                    ),
                    _NavTile(
                      icon: Icons.language,
                      label: Strings.language,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.language),
                    ),
                    const Divider(height: 16),

                    _SectionTitle('Support'),
                    _NavTile(
                      icon: Icons.feedback,
                      label: Strings.feedback,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.feedback);
                      },
                    ),
                    _NavTile(
                      icon: Icons.phone,
                      label: Strings.contactUs,
                      onTap: () {
                        Navigator.pop(context);
                        PhoneDialer.dial(context, '9166005226');
                      },
                    ),
                    _NavTile(
                      icon: Icons.help,
                      label: Strings.helpAndSupport,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.help);
                      },
                    ),
                    const Divider(height: 16),

                    _SectionTitle('About'),
                    _NavTile(
                      icon: Icons.info,
                      label: Strings.about,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.about);
                      },
                    ),
                    const Divider(height: 16),

                    _SectionTitle('Account'),
                    _NavTile(
                      icon: Icons.edit,
                      label: 'Edit Profile',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.profileSetup);
                      },
                    ),
                    _NavTile(
                      icon: Icons.logout,
                      label: Strings.logOut,
                      onTap: () async {
                        // TODO: logout
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              // ===== Pinned bottom-left version label =====
              Positioned(
                left: r.space(16),
                bottom: 0,
                child: SafeArea(
                  top: false,
                  minimum: EdgeInsets.only(bottom: r.space(10)),
                  child: CustomTextWidget(
                    _versionLabel.isEmpty
                        ? 'Version'
                        : 'Version $_versionLabel',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Drawer(
      //   child: SafeArea(
      //     top: true,
      //     bottom: false, // we'll pin our own footer
      //     child: Stack(
      //       children: [
      //         // ===== Scrollable content =====
      //         Positioned.fill(
      //           child: ListView(
      //             // add space so last item won't be hidden behind the footer
      //             padding: EdgeInsets.only(bottom: context.responsive.px(48)),
      //             children: [
      //               DrawerHeader(
      //                 padding: EdgeInsets.zero,
      //                 child: Container(
      //                   color: Colors.white,
      //                   padding: EdgeInsets.all(r.space(5)),
      //                   child: Row(
      //                     children: [
      //                       AvatarPicker(
      //                         radius: r.px(40),
      //                         file: _avatarFile,
      //                         onTap: () async {
      //                           final f = await ImagePickerHelper.pickImageWithSheet(context);
      //                           if (!mounted) return;
      //                           if (f != null) setState(() => _avatarFile = f);
      //                         },
      //                       ),
      //                       SizedBox(width: r.px(20)),
      //                       Expanded(
      //                         child: LayoutBuilder(
      //                           builder: (context, constraints) {
      //                             final style = Theme.of(context)
      //                                 .textTheme
      //                                 .rBodyMedium(context)!
      //                                 .copyWith(fontSize: r.font(20));
      //                             final display = truncateToFit(
      //                               text: widget.username,
      //                               style: style,
      //                               maxWidth: constraints.maxWidth,
      //                               textDirection: Directionality.of(context),
      //                             );
      //                             return CustomTextWidget(
      //                               display,
      //                               style: style,
      //                               maxLines: 1,
      //                               overflow: TextOverflow.clip,
      //                               softWrap: false,
      //                             );
      //                           },
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //
      //               ListTile(
      //                 leading: const Icon(Icons.add),
      //                 title: InkWell(
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                     Navigator.pushNamed(context, AppRoutes.addMember);
      //                   },
      //                   child: CustomTextWidget(Strings.addMember),
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.note_alt_sharp),
      //                 title: InkWell(
      //                   onTap: () => Navigator.pop(context),
      //                   child: CustomTextWidget(Strings.diary),
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.settings),
      //                 title: InkWell(
      //                   onTap: () => Navigator.pop(context),
      //                   child: CustomTextWidget(Strings.settings),
      //                 ),
      //               ),
      //               const Divider(),
      //               ListTile(
      //                 leading: const Icon(Icons.feedback),
      //                 title: InkWell(
      //                   onTap: () => Navigator.pushNamed(context, AppRoutes.feedback),
      //                   child: CustomTextWidget(Strings.feedback),
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.phone),
      //                 title: InkWell(
      //                   onTap: () => Navigator.pushNamed(context, AppRoutes.contactUs),
      //                   child: CustomTextWidget(Strings.contactUs),
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.info),
      //                 title: InkWell(
      //                   onTap: () => Navigator.pushNamed(context, AppRoutes.about),
      //                   child: CustomTextWidget(Strings.about),
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.help),
      //                 title: InkWell(
      //                   onTap: () => Navigator.pushNamed(context, AppRoutes.help),
      //                   child: CustomTextWidget(Strings.helpAndSupport),
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: InkWell(
      //                   onTap: () async {
      //                     // final prefs = await SharedPreferences.getInstance();
      //                     // await prefs.remove('token');
      //                     // await prefs.remove('userID');
      //                     // await prefs.remove('username');
      //                     // if (!context.mounted) return;
      //                     // Navigator.pushNamed(context, AppRoutes.login);
      //                   },
      //                   child: Icon(Icons.logout),
      //                 ),
      //                 title: CustomTextWidget(Strings.logOut),
      //               ),
      //               const Divider(height: 0),
      //             ],
      //           ),
      //         ),
      //
      //         // ===== Pinned bottom-left version label =====
      //         Positioned(
      //           left: context.responsive.space(16),
      //           bottom: 0,
      //           child: SafeArea(
      //               top: false,
      //               minimum: EdgeInsets.only(bottom: context.responsive.space(10)),
      //               child: CustomTextWidget(
      //                 _versionLabel.isEmpty ? 'Version' : 'Version $_versionLabel',
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .labelMedium
      //                     ?.copyWith(color: Colors.grey[700]),
      //               ),
      //             ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // Drawer(
      //   child: Container(
      //     // color: Colors.green[200],
      //     child: ListView(
      //       children: [
      //         DrawerHeader(
      //           padding: EdgeInsets.zero,
      //           child: Container(
      //             color: Colors.white,
      //             padding: EdgeInsets.all(r.space(5)),
      //             child: Row(
      //               children: [
      //                 AvatarPicker(
      //                   radius: r.px(40),
      //                   file: _avatarFile,
      //                   onTap: () async {
      //                     final f = await ImagePickerHelper.pickImageWithSheet(
      //                       context,
      //                     );
      //                     if (!mounted) return;
      //                     if (f != null) setState(() => _avatarFile = f);
      //                   },
      //                 ),
      //                 // CircleAvatar(
      //                 //   radius: r.px(40),
      //                 //   backgroundColor: const Color(0xFFE6ECE9),
      //                 //   backgroundImage:
      //                 //   _avatarFile != null ? FileImage(_avatarFile!) : null,
      //                 //   child: _avatarFile == null
      //                 //       ? Icon(Icons.person,
      //                 //       size: r.px(52),
      //                 //       color: const Color(0xFF9BB0A8))
      //                 //       : null,
      //                 // ),
      //                 SizedBox(width: r.px(20)),
      //                 Expanded(
      //                   child: LayoutBuilder(
      //                     builder: (context, constraints) {
      //                       final style = Theme.of(context)
      //                           .textTheme
      //                           .rBodyMedium(context)!
      //                           .copyWith(fontSize: r.font(20));
      //                       final display = truncateToFit(
      //                         text: widget.username,
      //                         style: style,
      //                         maxWidth: constraints.maxWidth,
      //                         textDirection: Directionality.of(context),
      //                       );
      //                       return CustomTextWidget(
      //                         display,
      //                         style: style,
      //                         maxLines: 1,
      //                         overflow: TextOverflow.clip, // no ellipsis, no wrap
      //                         softWrap: false,
      //                       );
      //                     }
      //                     // child: Column(
      //                     //   crossAxisAlignment: CrossAxisAlignment.start,
      //                     //   mainAxisAlignment: MainAxisAlignment.center,
      //                     //   children: [
      //                     //     CustomTextWidget(
      //                     //       widget.username,
      //                     //       style: Theme.of(context).textTheme
      //                     //           .rBodyMedium(context)!
      //                     //           .copyWith(fontSize: r.font(20)),
      //                     //     ),
      //                     //     // CustomTextWidget(
      //                     //     //   'Working Professional',
      //                     //     //   style: TextStyle(fontSize: r.font(15)),
      //                     //     // ),
      //                     //   ],
      //                     // ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.add),
      //           title: InkWell(
      //             onTap: () {
      //               Navigator.pop(context);
      //               Navigator.pushNamed(context, AppRoutes.addMember);
      //             },
      //             child: CustomTextWidget(Strings.addMember),
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.note_alt_sharp),
      //           title: InkWell(
      //             onTap: () {
      //               Navigator.pop(context);
      //             },
      //             child: CustomTextWidget(Strings.diary),
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.settings),
      //           title: InkWell(
      //             onTap: () {
      //               Navigator.pop(context);
      //             },
      //             child: CustomTextWidget(Strings.settings),
      //           ),
      //         ),
      //         Divider(),
      //         ListTile(
      //           leading: Icon(Icons.feedback),
      //           title: InkWell(
      //             onTap: () {
      //               Navigator.pushNamed(context, AppRoutes.feedback);
      //             },
      //             child: CustomTextWidget(Strings.feedback),
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.phone),
      //           title: InkWell(onTap: () {
      //             Navigator.pushNamed(context, AppRoutes.contactUs);
      //           }, child: CustomTextWidget(Strings.contactUs)),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.info),
      //           title: InkWell(
      //             onTap: () {
      //               Navigator.pushNamed(context, AppRoutes.about);
      //             },
      //             child: CustomTextWidget(Strings.about),
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.help),
      //           title: InkWell(
      //             onTap: () {
      //               Navigator.pushNamed(context, AppRoutes.help);
      //             },
      //             child: CustomTextWidget(Strings.helpAndSupport),
      //           ),
      //         ),
      //         ListTile(
      //           leading: InkWell(
      //             onTap: () async {
      //               // final prefs = await SharedPreferences.getInstance();
      //               // await prefs.remove('token');
      //               // await prefs.remove('userID');
      //               // await prefs.remove('username');
      //               // if (!context.mounted) return;
      //               // Navigator.pushNamed(context, AppRoutes.login);
      //             },
      //             child: Icon(Icons.logout),
      //           ),
      //           title: CustomTextWidget(Strings.logOut),
      //         ),
      //         const Divider(height: 0),
      //         Padding(
      //           padding: EdgeInsets.symmetric(
      //             horizontal: context.responsive.space(16),
      //             vertical: context.responsive.space(10),
      //           ),
      //           child:
      //           Row(
      //             children: [
      //               // Icon(Icons.info_outline,
      //               //     size: context.responsive.font(16), color: Colors.grey),
      //               // SizedBox(width: context.responsive.px(8)),
      //               // const Spacer(),
      //               CustomTextWidget(
      //                 _versionLabel.isEmpty ? 'Version' : 'Version $_versionLabel',
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .labelMedium
      //                     ?.copyWith(color: Colors.grey[700]),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // appBar: CustomAppBar(
      //   title: LayoutBuilder(
      //     builder: (context, constraints) {
      //       final style = Theme.of(context)
      //           .textTheme
      //           .rTitleMedium(context)!
      //           .copyWith(color: Colors.white);
      //       final display = truncateToFit(
      //         text: widget.username,
      //         style: style,
      //         maxWidth: constraints.maxWidth,
      //         textDirection: Directionality.of(context),
      //       );
      //       return CustomTextWidget(
      //         display,
      //         style: style,
      //         maxLines: 1,
      //         overflow: TextOverflow.clip,
      //         softWrap: false,
      //       );
      //     },
      //   ),
      //   // CustomTextWidget(
      //   //   widget.username,
      //   //   style: Theme.of(
      //   //     context,
      //   //   ).textTheme.rTitleMedium(context)!.copyWith(color: Colors.white),
      //   //   // kohinoorMedium.copyWith(
      //   //   //   fontSize: 24.sp,
      //   //   //   fontWeight: FontWeight.w500,
      //   //   //   color: AppColors.btnTextColor,
      //   //   // ),
      //   // ),
      //   // backgroundColor: AppColors.appBarColor,
      //   foregroundColor: AppColors.btnTextColor,
      //   gradient: const LinearGradient(
      //     colors: [AppColors.appBarColor, AppColors.appBarDarkColor],
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //   ),
      //   centerTitle: false,
      //   actions: [Icon(Icons.notifications_none, size: r.font(24),)],
      // ),
      appBar: CustomAppBar(
        titleSpacing: 0, // no extra gap before title
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Visual constants that must match your row widgets:
            final avatarRadius = r.px(18);
            final avatarDiameter = avatarRadius * 2;
            final spaceAfterAvatar = r.px(8);
            final spaceBeforeChevron = r.px(4);
            final chevronWidth = 24.0; // Icon size

            // How much width remains for the *text* inside the title row:
            final available =
                (constraints.maxWidth -
                        avatarDiameter -
                        spaceAfterAvatar -
                        chevronWidth -
                        spaceBeforeChevron)
                    .clamp(0.0, constraints.maxWidth);

            // >>> FIX: pick a fixed (or capped) width for the name box
            // Option A: fixed width (responsive)
            final nameBoxTarget = r.px(160); // <- adjust to taste
            // Option B (alternative): a fraction of available space
            // final nameBoxTarget = available * 0.5; // 50% of available

            // Final width used for the name area (never exceed available)
            final nameBoxWidth = math.min(available, nameBoxTarget);

            final style = Theme.of(
              context,
            ).textTheme.rTitleMedium(context)!.copyWith(color: Colors.white);

            final display = truncateToFit(
              text: widget.username,
              style: style,
              maxWidth: nameBoxWidth,
              textDirection: Directionality.of(context),
            );

            final g = (widget.gender ?? '').trim().toLowerCase();
            final IconData? genderIcon = (g == 'female')
                ? Icons.woman
                : (g == 'male')
                ? Icons.person
                : null;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : null,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: _avatarFile == null
                      ? (genderIcon != null
                            ? Icon(
                                genderIcon,
                                color: Colors.white,
                                size: r.font(20),
                              )
                            : CustomTextWidget(
                                (widget.username.trim().isNotEmpty
                                        ? widget.username.trim()[0]
                                        : '?')
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: r.font(12),
                                ),
                              ))
                      : null,
                ),

                SizedBox(width: spaceAfterAvatar),

                // fixed-width box so our measurement matches real layout
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: nameBoxWidth),
                  child: CustomTextWidget(
                    display, // already trimmed to fit
                    maxLines: 1,
                    softWrap: false,
                    overflow:
                        TextOverflow.clip, // no ellipsis, we trimmed ourselves
                    style: style,
                  ),
                ),

                SizedBox(width: spaceBeforeChevron),

                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: chevronWidth,
                  ),
                ),
              ],
            );
          },
        ),
        foregroundColor: AppColors.btnTextColor,
        gradient: const LinearGradient(
          colors: [AppColors.appBarColor, AppColors.appBarDarkColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        centerTitle: false,
        actions: [Icon(Icons.notifications_none, size: r.font(24))],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          NavBarItem(
            icon: Icons.home,
            activeIcon: Icons.home_outlined,
            label: 'Home',
          ),
          NavBarItem(
            icon: Icons.lock_clock,
            activeIcon: Icons.lock_clock,
            label: 'Reminder',
          ),
          NavBarItem(
            icon: Icons.calendar_today,
            activeIcon: Icons.calendar_today,
            label: 'Schedule',
          ),
          // , badgeCount: 3),
          NavBarItem(
            icon: Icons.trending_up_sharp,
            activeIcon: Icons.trending_up_sharp,
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.space(16),
        r.space(8),
        r.space(16),
        r.space(4),
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey[600],
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2), // tighter
      minLeadingWidth: r.px(24),
      leading: Icon(icon, size: r.font(20), color: Colors.grey[800]),
      title: CustomTextWidget(
        label,
        style: Theme.of(context).textTheme.rBodyMedium(context),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: r.font(18),
        color: Colors.grey[400],
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: r.space(12)),
    );
  }
}
