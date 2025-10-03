import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:assisted_living/services/backend_driven_ui_service.dart';

import '../../app/routes/app_routes.dart';
import '../widgets/custom_appbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String _html =
    '''
<div style="background:#f7f7fb; padding:16px;">
  <div style="background:#ffffff; padding:20px; border-radius:14px; border:1px solid #e7e7ef; max-width:900px; margin:0 auto;">
    <h1 style="margin:0 0 6px; color:#1c1c28; text-align:center;">Privacy Policy</h1>
    <p style="margin:0; text-align:center; color:#6b6b83;">Last updated: 29 Sep 2025</p>

    <hr style="border:none; border-top:1px solid #eee; margin:18px 0;" />

    <div style="background:#eef7ff; border:1px solid #d9e7ff; padding:12px 14px; border-radius:12px; margin:0 0 16px;">
      <strong style="color:#1e3a8a;">Summary:</strong>
      <span style="color:#3f3f55;">
        We collect only what we need to run our app, keep it secure, and improve features. We never sell your data.
      </span>
    </div>

    <h2 style="color:#24243a; margin:16px 0 8px;">What we collect</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>Account info (name, email, phone).</li>
      <li>Usage & device info (app interactions, crash logs, basic device details).</li>
      <li>Optional content you submit (support messages, profile details).</li>
    </ul>

    <h2 style="color:#24243a; margin:16px 0 8px;">How we use your data</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>Provide and maintain the service (authentication, core features).</li>
      <li>Improve performance and fix issues (analytics & crash diagnostics).</li>
      <li>Communicate with you about updates and support.</li>
    </ul>

    <h2 style="color:#24243a; margin:16px 0 8px;">Sharing</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      We share data with trusted service providers (e.g., analytics, cloud hosting) under contracts that
      restrict how they use it. We may disclose data if required by law or to protect rights and safety.
      We do <strong>not</strong> sell your personal information.
    </p>

    <h2 style="color:#24243a; margin:16px 0 8px;">Retention & Security</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      We keep data only as long as needed for the purposes above or as required by law. We use reasonable
      technical and organizational safeguards to protect it.
    </p>

    <h2 style="color:#24243a; margin:16px 0 8px;">Your rights</h2>
    <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
      <li>Access, correct, or delete your information.</li>
      <li>Opt out of non-essential communications.</li>
      <li>Contact us to exercise your rights or ask questions.</li>
    </ul>

    <h2 style="color:#24243a; margin:16px 0 8px;">Children</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      Our service is not directed to children under 13, and we do not knowingly collect their personal data.
    </p>

    <h2 style="color:#24243a; margin:16px 0 8px;">Contact</h2>
    <p style="color:#44445a; line-height:1.6; margin:0 0 12px;">
      Email us at <a href="mailto:privacy@example.com" style="color:#2f5aff;">privacy@example.com</a>.
      Learn more on our <a href="https://example.com/privacy" style="color:#2f5aff; text-decoration:underline;">full policy page</a>.
    </p>

    <p style="color:#6b6b83; font-size:12px; margin:0 0 12px;">
      We may update this policy to reflect changes to our practices or for legal reasons.
    </p>
  </div>
</div>
    ''';

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomTextWidget('Privacy Policy'),
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
              Navigator.pop(context, true);
              // Navigator.pushNamed(context, AppRoutes.login);
            }
          },
        ),
      ),
    );
  }
}
