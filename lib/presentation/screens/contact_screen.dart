// import 'package:flutter/material.dart';
// import 'package:assisted_living/services/backend_driven_ui_service.dart';
// import '../../app/routes/app_routes.dart';
//
// class ContactUsScreen extends StatelessWidget {
//   const ContactUsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final String _html = '''
// <div style="background:#f7f7fb; padding:16px;">
//   <div style="background:#ffffff; padding:20px; border-radius:14px; border:1px solid #e7e7ef; max-width:900px; margin:0 auto;">
//     <h1 style="margin:0 0 6px; color:#1c1c28; text-align:center;">Contact Us</h1>
//     <p style="margin:0; text-align:center; color:#6b6b83;">Last updated: 26 Sep 2025</p>
//
//     <hr style="border:none; border-top:1px solid #eee; margin:18px 0;" />
//
//     <!-- Hero -->
//     <div style="background:#eef7ff; border:1px solid #d9e7ff; padding:12px 14px; border-radius:12px; margin:0 0 16px;">
//       <strong style="color:#1e3a8a;">We’re here to help.</strong>
//       <span style="color:#3f3f55;"> Reach us via email, phone, or WhatsApp. You’ll usually hear back within 24–48 hours.</span>
//     </div>
//
//     <!-- Quick contact -->
//     <h2 style="color:#24243a; margin:16px 0 8px;">Quick contact</h2>
//     <div style="display:flex; flex-wrap:wrap; gap:8px; margin-bottom:12px;">
//       <a href="mailto:support@example.com?subject=Support%20request&body=Describe%20your%20issue..."
//          style="display:inline-block; padding:10px 14px; background:#2f5aff; color:#fff; border-radius:10px; text-decoration:none;">Email Support</a>
//       <a href="tel:+1234567890"
//          style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">Call Us</a>
//       <a href="https://wa.me/1234567890?text=Hi%2C%20I%20need%20help"
//          style="display:inline-block; padding:10px 14px; background:#f5f5f8; color:#2b2b3f; border:1px solid #e6e6f0; border-radius:10px; text-decoration:none;">WhatsApp</a>
//     </div>
//
//     <!-- Address -->
//     <h2 style="color:#24243a; margin:16px 0 8px;">Office</h2>
//     <p style="color:#44445a; line-height:1.6; margin:0 0 6px;">
//       Assisted Living Inc.<br/>
//       123 Green Avenue, Floor 3<br/>
//       Springfield, XY 00000
//     </p>
//     <p style="margin:0 0 12px;">
//       <a href="https://maps.google.com/?q=123%20Green%20Avenue%20Springfield%20XY%2000000" style="color:#2f5aff; text-decoration:underline;">Open in Google Maps</a>
//     </p>
//
//     <!-- Hours -->
//     <h2 style="color:#24243a; margin:16px 0 8px;">Support hours</h2>
//     <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
//       <li>Mon–Fri: 9:00 AM – 6:00 PM (local time)</li>
//       <li>Sat: 10:00 AM – 2:00 PM</li>
//       <li>Sun &amp; public holidays: Closed</li>
//     </ul>
//
//     <!-- Helpful links -->
//     <h2 style="color:#24243a; margin:16px 0 8px;">Helpful links</h2>
//     <ul style="margin:0 0 12px; padding-left:18px; color:#44445a; line-height:1.6;">
//       <li><a href="app://terms" style="color:#2f5aff; text-decoration:underline;">Terms &amp; Conditions</a></li>
//       <li><a href="app://privacy" style="color:#2f5aff; text-decoration:underline;">Privacy Policy</a></li>
//       <li><a href="app://about" style="color:#2f5aff; text-decoration:underline;">About Us</a></li>
//     </ul>
//
//     <!-- Note -->
//     <p style="color:#6b6b83; font-size:12px; margin:0 0 12px;">
//       For emergencies or urgent medical needs, please contact local emergency services.
//     </p>
//
//     <div style="margin-top:18px; text-align:center;">
//       <a href="app://back"
//          style="display:inline-block; padding:10px 16px; background:#2f5aff; color:#fff; border-radius:10px; text-decoration:none;">
//          Back
//       </a>
//     </div>
//   </div>
// </div>
//     ''';
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: BackendDrivenUiService(
//           html: _html,
//           onTapCall: (url) async {
//             if (url.contains('back')) {
//               Navigator.pop(context, true);
//             } else if (url.contains('privacy')) {
//               Navigator.pushNamed(context, AppRoutes.privacy);
//             } else if (url.contains('terms')) {
//               Navigator.pushNamed(context, AppRoutes.terms);
//             } else if (url.contains('about')) {
//               Navigator.pushNamed(context, AppRoutes.about);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneDialer {
  static Future<void> dial(BuildContext context, String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer for $phoneNumber')),
      );
    }
  }
}
