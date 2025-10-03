import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:assisted_living/services/backend_driven_ui_service.dart';

import '../../app/routes/app_routes.dart';
import '../widgets/custom_appbar.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String _html =
    '''
 <!-- Terms & Conditions - Flutter friendly (inline CSS only) -->
  <div style="background:#f7f7fb; padding:16px;">
  <div style="background:#ffffff; padding:20px; border-radius:14px; border:1px solid #e7e7ef;">
    <h1 style="margin:0 0 8px; color:#1c1c28; text-align:center;">Terms &amp; Conditions</h1>
    <p style="margin:0; text-align:center; color:#6b6b83;">Last updated: 26 Sep 2025</p>

    <hr style="border:none; border-top:1px solid #eee; margin:20px 0;" />

    <!-- Hero callout -->
    <div style="background:#eef2ff; border:1px solid #dfe4ff; padding:12px 14px; border-radius:12px; margin:0 0 16px;">
      <strong style="color:#2b3a67;">Summary:</strong>
      <span style="color:#3f3f55;">
        By using this application, you agree to the terms below. If you do not agree, please discontinue use.
      </span>
    </div>

    <!-- Quick facts table -->
    <table style="width:100%; border-collapse:collapse; margin:10px 0 18px;">
      <thead>
        <tr>
          <th style="text-align:left; padding:10px; font-weight:600; color:#2b2b3f; border-bottom:1px solid #eee;">Topic</th>
          <th style="text-align:left; padding:10px; font-weight:600; color:#2b2b3f; border-bottom:1px solid #eee;">Summary</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td style="padding:10px; border-bottom:1px solid #f0f0f4;">License</td>
          <td style="padding:10px; border-bottom:1px solid #f0f0f4;">Non-exclusive, revocable right to use the app.</td>
        </tr>
        <tr>
          <td style="padding:10px; border-bottom:1px solid #f0f0f4;">Privacy</td>
          <td style="padding:10px; border-bottom:1px solid #f0f0f4;">We handle data per our
            <a href="https://example.com/privacy" style="color:#2f5aff; text-decoration:underline;">Privacy Policy</a>.
          </td>
        </tr>
        <tr>
          <td style="padding:10px;">Support</td>
          <td style="padding:10px;">Email <a href="mailto:support@example.com" style="color:#2f5aff;">support@example.com</a></td>
        </tr>
      </tbody>
    </table>

    <h2 style="color:#24243a; margin:18px 0 8px;">1. Acceptance of Terms</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      By accessing or using this application (“App”), you confirm that you can form a binding contract
      with us and that you accept these Terms. If you do not agree, do not use the App.
    </p>

    <h2 style="color:#24243a; margin:18px 0 8px;">2. License &amp; Restrictions</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>We grant you a limited, revocable, non-transferable license to use the App.</li>
      <li>Do not reverse engineer, decompile, or attempt to extract the source code.</li>
      <li>Do not misuse the App (e.g., spamming, scraping, or violating applicable laws).</li>
    </ul>

    <h2 style="color:#24243a; margin:18px 0 8px;">3. User Content</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      You are responsible for content you submit. You grant us a non-exclusive, worldwide license to
      host and display such content solely to provide and improve the App.
    </p>

    <h2 style="color:#24243a; margin:18px 0 8px;">4. Privacy</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      We process personal data as described in our
      <a href="https://example.com/privacy" style="color:#2f5aff; text-decoration:underline;">Privacy Policy</a>.
      Some in-app links may navigate internally:
      <span style="background:#e8f5e9; padding:2px 6px; border-radius:6px;">
        <a href="app://about" style="color:#2e7d32; text-decoration:none;">About (internal)</a>
      </span>.
    </p>

    <h2 style="color:#24243a; margin:18px 0 8px;">5. Third-Party Services</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      The App may include links to third-party content or services.
      We are not responsible for third-party terms or policies.
    </p>

    <h2 style="color:#24243a; margin:18px 0 8px;">6. Disclaimers</h2>
    <div style="background:#fff7e6; border:1px solid #ffe8b3; padding:12px 14px; border-radius:12px; margin:0 0 12px;">
      <strong style="color:#8a6d3b;">No Warranty:</strong>
      <span style="color:#5a4a2a;">
        The App is provided “as is” without warranties of any kind, express or implied.
      </span>
    </div>

    <h2 style="color:#24243a; margin:18px 0 8px;">7. Limitation of Liability</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      To the maximum extent permitted by law, we will not be liable for any indirect, incidental,
      or consequential damages arising from your use of the App.
    </p>

    <h2 style="color:#24243a; margin:18px 0 8px;">8. Termination</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      We may suspend or terminate access if you violate these Terms or use the App in a harmful manner.
    </p>

    <h2 style="color:#24243a; margin:18px 0 8px;">9. Changes to These Terms</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      We may update these Terms from time to time. Continued use after changes constitutes acceptance.
    </p>

    <h2 style="color:#24243a; margin:18px 0 8px;">10. Contact</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 6px;">
      Questions? Email <a href="mailto:legal@example.com" style="color:#2f5aff;">legal@example.com</a>
      or visit our <a href="https://example.com" style="color:#2f5aff;">website</a>.
    </p>
  </div>
</div>
    ''';

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomTextWidget('Terms and Conditions'),
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
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text('Welcome')));
              // Navigator.pushNamed(context, AppRoutes.login);
              Navigator.pop(context, true);
            }
          },
        ),
      ),
    );
  }
}
