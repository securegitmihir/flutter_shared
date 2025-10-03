import 'package:flutter/widgets.dart';

/// Returns the longest prefix of [text] (prefer whole words) that fits into [maxWidth].
/// Falls back to character-level trim if even the first word doesn't fit.
String truncateToFit({
  required String text,
  required TextStyle style,
  required double maxWidth,
  TextDirection textDirection = TextDirection.ltr,
}) {
  // Normalize spaces: trim edges, collapse multiple spaces to a single space so measurement is consistent.
  String clean = text.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (clean.isEmpty) return clean;

  bool fits(String s) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: style),
      maxLines: 1,
      textDirection: textDirection,
    )..layout(); // intrinsic width (no maxWidth cap)
    return tp.width <= maxWidth;
  }

  // If everything fits, return.
  if (fits(clean)) return clean;

  // Try word-by-word.
  final words = clean.split(' ');
  String out = '';
  for (final w in words) {
    final candidate = out.isEmpty ? w : '$out $w';
    if (fits(candidate)) {
      out = candidate;
    } else {
      break;
    }
  }

  if (out.isNotEmpty) return out;

  // First word itself doesn't fit → trim by characters.
  final codepoints = clean.runes.toList();
  int lo = 0, hi = codepoints.length; // binary search longest fitting prefix
  while (lo < hi) {
    final mid = (lo + hi + 1) >> 1;
    final cand = String.fromCharCodes(codepoints.take(mid));
    if (fits(cand)) {
      lo = mid;
    } else {
      hi = mid - 1;
    }
  }
  return String.fromCharCodes(codepoints.take(lo));
}
