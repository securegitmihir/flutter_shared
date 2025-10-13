import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:assisted_living/services/backend_driven_ui_service.dart';

import '../widgets/custom_appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String html =
    '''
<div style="background:#f7f7fb; padding:16px;">
  <div style="background:#ffffff; padding:20px; border-radius:14px; border:1px solid #e7e7ef; max-width:900px; margin:0 auto;">
    <h1 style="margin:0 0 6px; color:#1c1c28; text-align:center;">About Us</h1>
    <p style="margin:0; text-align:center; color:#6b6b83;">Last updated: 30 Sep 2025</p>

    <hr style="border:none; border-top:1px solid #eee; margin:18px 0;" />

    <!-- Mission -->
    <div style="background:#eef7ff; border:1px solid #d9e7ff; padding:12px 14px; border-radius:12px; margin:0 0 16px;">
      <strong style="color:#1e3a8a;">Our mission:</strong>
      <span style="color:#3f3f55;">
        Make independent living safer and simpler through thoughtful tools that connect families, caregivers, and seniors.
      </span>
    </div>

    <!-- What we do -->
    <h2 style="color:#24243a; margin:16px 0 8px;">What we do</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      We build easy-to-use features to help you manage everyday health and wellness: reminders, schedules, check-ins, and insights —
      all designed to keep loved ones informed without getting in the way.
    </p>

    <!-- Core values -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Our values</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li><strong>Privacy first</strong> — we collect only what’s needed and never sell your data.</li>
      <li><strong>Accessibility</strong> — readable text, clear actions, and simple flows.</li>
      <li><strong>Reliability</strong> — stable experiences across a wide range of devices.</li>
      <li><strong>Support</strong> — real humans when you need help.</li>
    </ul>

    <!-- Highlights -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Highlights</h2>
    <table style="width:100%; border-collapse:collapse;">
      <tbody>
        <tr>
          <td style="padding:10px; border:1px solid #f0f0f4; width:33%;">
            <div style="font-weight:600; color:#2b2b3f; margin-bottom:6px;">Smart Reminders</div>
            <div style="color:#5a5a74;">Medications, routines, and appointments on time.</div>
          </td>
          <td style="padding:10px; border:1px solid #f0f0f4; width:33%;">
            <div style="font-weight:600; color:#2b2b3f; margin-bottom:6px;">Shared Visibility</div>
            <div style="color:#5a5a74;">Keep family in the loop with minimal effort.</div>
          </td>
          <td style="padding:10px; border:1px solid #f0f0f4; width:33%;">
            <div style="font-weight:600; color:#2b2b3f; margin-bottom:6px;">Insights</div>
            <div style="color:#5a5a74;">Trends that help you spot changes early.</div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Contact -->
    <h2 style="color:#24243a; margin:16px 0 8px;">Contact</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      Have questions or feedback? We’d love to hear from you.<br/>
      Email <a href="mailto:support@example.com" style="color:#2f5aff;">support@example.com</a><br/>
      Visit <a href="https://example.com" style="color:#2f5aff; text-decoration:underline;">our website</a>
    </p>

    <p style="color:#6b6b83; font-size:12px; margin:0 0 12px;">
      We may update this page as our product evolves.
    </p>
  </div>
</div>
    ''';

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomTextWidget('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: BackendDrivenUiService(
          html: html,
          onTapCall: (url) async {
            if (url.contains('back')) {
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text('Welcome')));
              Navigator.pop(context, true);
              // Navigator.pushNamed(context, AppRoutes.login);
            }
          },
        ),
      ),
    );
  }
}
