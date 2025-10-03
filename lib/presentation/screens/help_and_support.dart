import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:assisted_living/services/backend_driven_ui_service.dart';
import '../../app/routes/app_routes.dart';
import '../widgets/custom_appbar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String _html = '''
<div style="background:#f7f7fb; padding:16px;">
  <div style="background:#ffffff; padding:20px; border-radius:14px; border:1px solid #e7e7ef; max-width:900px; margin:0 auto;">
    <h1 style="margin:0 0 6px; color:#1c1c28; text-align:center;">Help &amp; Support</h1>
    <p style="margin:0; text-align:center; color:#6b6b83;">Last updated: 26 Sep 2025</p>

    <hr style="border:none; border-top:1px solid #eee; margin:18px 0;" />

    <!-- Intro -->
    <div style="background:#eef7ff; border:1px solid #d9e7ff; padding:12px 14px; border-radius:12px; margin:0 0 16px;">
      <strong style="color:#1e3a8a;">How can we help?</strong>
      <span style="color:#3f3f55;"> Find quick answers below or reach our team directly.</span>
    </div>

    <!-- Quick actions -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Quick actions</h2>
    <div style="display:flex; flex-wrap:wrap; gap:8px; margin-bottom:12px;">
      <a href="mailto:support@example.com"
         style="display:inline-block; padding:10px 14px; background:#2f5aff; color:#fff; border-radius:10px; text-decoration:none;">Email Support</a>
      <a href="tel:+1234567890"
         style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">Call Us</a>
      <a href="https://wa.me/1234567890?text=Hi%2C%20I%20need%20help"
         style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">WhatsApp</a>
      <a href="https://example.com/help"
         style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">Help Center</a>
    </div>

    <!-- Common issues -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Common issues</h2>
    <h3 style="color:#2b2b3f; margin:12px 0 6px;">Not receiving OTP?</h3>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>Check your phone number and country code.</li>
      <li>Wait 60 seconds and try “Resend OTP”.</li>
      <li>Ensure you have network connectivity.</li>
    </ul>

    <h3 style="color:#2b2b3f; margin:12px 0 6px;">Notifications not working?</h3>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>Enable notifications for the app in system settings.</li>
      <li>Disable battery optimization for reliable reminders.</li>
      <li>Keep the app updated to the latest version.</li>
    </ul>

    <h3 style="color:#2b2b3f; margin:12px 0 6px;">App crashed or froze?</h3>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>Force close and reopen the app.</li>
      <li>Update to the latest version.</li>
      <li>Reboot your device if the issue persists.</li>
    </ul>

    <!-- FAQs -->
    <h2 style="color:#24243a; margin:16px 0 8px;">FAQs</h2>
    <p style="color:#2b2b3f; margin:8px 0 4px;"><strong>How do I change my profile details?</strong></p>
    <p style="color:#44445a; margin:0 0 8px;">Open the menu &rarr; Profile to edit your info.</p>

    <p style="color:#2b2b3f; margin:8px 0 4px;"><strong>Where can I see reminders?</strong></p>
    <p style="color:#44445a; margin:0 0 8px;">Use the Reminder tab to review, add, or edit reminders.</p>

    <p style="color:#2b2b3f; margin:8px 0 4px;"><strong>How is my data used?</strong></p>
    <p style="color:#44445a; margin:0 0 8px;">We collect only what we need and never sell your data. Read our
      <a href="app://privacy" style="color:#2f5aff; text-decoration:underline;">Privacy Policy</a>.
    </p>

    <!-- Links -->
    <h2 style="color:#24243a; margin:16px 0 8px;">More</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li><a href="app://terms" style="color:#2f5aff; text-decoration:underline;">Terms &amp; Conditions</a></li>
      <li><a href="app://privacy" style="color:#2f5aff; text-decoration:underline;">Privacy Policy</a></li>
      <li><a href="app://about" style="color:#2f5aff; text-decoration:underline;">About Us</a></li>
    </ul>
  </div>
</div>
    ''';

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomTextWidget('Help and Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: BackendDrivenUiService(
          html: _html,
          onTapCall: (url) async {
            if (url.contains('back')) {
              Navigator.pop(context, true);
            } else if (url.contains('privacy')) {
              Navigator.pushNamed(context, AppRoutes.privacy);
            } else if (url.contains('terms')) {
              Navigator.pushNamed(context, AppRoutes.terms);
            } else if (url.contains('about')) {
              Navigator.pushNamed(context, AppRoutes.about);
            }
          },
        ),
      ),
    );
  }
}
