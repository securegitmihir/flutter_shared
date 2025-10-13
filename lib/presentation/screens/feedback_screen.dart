import 'package:assisted_living/presentation/widgets/custom_appbar.dart';
import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:assisted_living/services/backend_driven_ui_service.dart';
import '../../app/routes/app_routes.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String html = '''
<div style="background:#f7f7fb; padding:16px;">
  <div style="background:#ffffff; padding:20px; border-radius:14px; border:1px solid #e7e7ef; max-width:900px; margin:0 auto;">
    <h1 style="margin:0 0 6px; color:#1c1c28; text-align:center;">Feedback</h1>
    <p style="margin:0; text-align:center; color:#6b6b83;">Last updated: 01 Oct 2025</p>

    <hr style="border:none; border-top:1px solid #eee; margin:18px 0;" />

    <!-- Hero -->
    <div style="background:#eef7ff; border:1px solid #d9e7ff; padding:12px 14px; border-radius:12px; margin:0 0 16px;">
      <strong style="color:#1e3a8a;">We value your feedback.</strong>
      <span style="color:#3f3f55;"> Tell us what’s working well and what we can improve.</span>
    </div>

    <!-- Quick actions -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Send feedback</h2>
    <div style="display:flex; flex-wrap:wrap; gap:8px; margin-bottom:12px;">
      <a href="mailto:support@example.com?subject=App%20Feedback&body=Please%20share%20your%20thoughts%20here..."
         style="display:inline-block; padding:10px 14px; background:#2f5aff; color:#fff; border-radius:10px; text-decoration:none;">Email Feedback</a>
      <a href="https://wa.me/1234567890?text=Hi%2C%20I%20have%20feedback%20about%20the%20app"
         style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">WhatsApp</a>
    </div>

    <!-- Rate -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Rate our app</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 8px;">
      Ratings help us reach more people and prioritize improvements.
    </p>
    <div style="display:flex; flex-wrap:wrap; gap:8px; margin-bottom:12px;">
      <!-- Replace with your real store links -->
      <a href="https://play.google.com/store/apps/details?id=com.yourcompany.yourapp"
         style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">Rate on Play Store</a>
      <a href="https://apps.apple.com/app/id0000000000"
         style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">Rate on App Store</a>
    </div>

    <!-- How we use feedback -->
    <h2 style="color:#24243a; margin:16px 0 8px;">How we use your feedback</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>Improve reliability and performance.</li>
      <li>Prioritize feature requests.</li>
      <li>Fix bugs and polish the experience.</li>
    </ul>

    <!-- Helpful links -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Helpful links</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li><a href="app://help" style="color:#2f5aff; text-decoration:underline;">Help &amp; Support</a></li>
      <li><a href="app://privacy" style="color:#2f5aff; text-decoration:underline;">Privacy Policy</a></li>
      <li><a href="app://about" style="color:#2f5aff; text-decoration:underline;">About Us</a></li>
    </ul>
  </div>
</div>
    ''';

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomTextWidget('Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        // foregroundColor: AppColors.btnTextColor,
        // gradient: const LinearGradient(
        //   colors: [AppColors.appBarColor, AppColors.appBarDarkColor],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
      ),
      body: SingleChildScrollView(
        child: BackendDrivenUiService(
          html: html,
          onTapCall: (url) async {
            if (url.contains('back')) {
              Navigator.pop(context, true);
            } else if (url.contains('help')) {
              Navigator.pushNamed(context, AppRoutes.help);
            } else if (url.contains('privacy')) {
              Navigator.pushNamed(context, AppRoutes.privacy);
            } else if (url.contains('about')) {
              Navigator.pushNamed(context, AppRoutes.about);
            }
          },
        ),
      ),
    );
    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Positioned.fill(
    //         child: SingleChildScrollView(
    //           child: BackendDrivenUiService(
    //             html: _html, // remove the bottom Back link
    //             onTapCall: (url) async {
    //               if (url.contains('help')) {
    //                 Navigator.pushNamed(context, AppRoutes.help);
    //               } else if (url.contains('privacy')) {
    //                 Navigator.pushNamed(context, AppRoutes.privacy);
    //               } else if (url.contains('about')) {
    //                 Navigator.pushNamed(context, AppRoutes.about);
    //               }
    //             },
    //           ),
    //         ),
    //       ),
    //       SafeArea(
    //         child: IconButton(
    //           icon: const Icon(Icons.arrow_back_ios_new_rounded),
    //           onPressed: () => Navigator.pop(context),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
