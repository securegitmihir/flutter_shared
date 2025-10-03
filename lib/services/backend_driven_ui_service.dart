import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class BackendDrivenUiService extends StatelessWidget {
  final String html;
  final Future<void> Function(dynamic)? onTapCall;

  const BackendDrivenUiService({required this.html, this.onTapCall, super.key});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      onTapUrl: (raw) async {
        final url = raw.trim();

        if (url.startsWith('app:')) {
          final normalized = url.replaceFirst(RegExp(r'^app:/*'), 'app://');
          Uri uri;
          try {
            uri = Uri.parse(normalized);
          } catch (_) {
            return false;
          }

          final parts = <String>[];
          if (uri.host.isNotEmpty) parts.add(uri.host);
          if (uri.pathSegments.isNotEmpty) parts.addAll(uri.pathSegments);
          final route = '/${parts.join('/')}';
          if (onTapCall != null) {
            await onTapCall!(url);
            return true;
          }
          // context.go(route, extra: uri.queryParameters);
          Navigator.pushNamed(context, route);
          return true; // IMPORTANT
        }
        // External links
        final uri = Uri.tryParse(url);
        if (uri == null) return false;
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
    );
  }
}
