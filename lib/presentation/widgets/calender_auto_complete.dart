import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YearAutocompleteField extends StatelessWidget {
  const YearAutocompleteField({
    super.key,
    required this.controller,
    required this.label,
    required this.onSelected,
    this.errorText,
    this.minYear = 1950,                 // set to 1900 if you want 194x to appear
    this.maxYear,
    this.hint = 'e.g. 1992',
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final int minYear;
  final int? maxYear;                    // default -> current year
  final String hint;
  final void Function(String year) onSelected;

  @override
  Widget build(BuildContext context) {
    final int kMax = maxYear ?? DateTime.now().year;

    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (TextEditingValue value) {
        return _buildOptions(value.text, minYear, kMax);
      },
      onSelected: (val) {
        controller.text = val;
        onSelected(val);
      },
      displayStringForOption: (opt) => opt,
      fieldViewBuilder: (ctx, textCtrl, focusNode, onFieldSubmitted) {
        // keep the external controller in sync
        if (textCtrl.text != controller.text) textCtrl.text = controller.text;
        textCtrl.addListener(() => controller.text = textCtrl.text);

        return TextField(
          controller: textCtrl,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      },
      optionsViewBuilder: (ctx, onOptionSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 260),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (_, i) {
                  final full = options.elementAt(i);
                  return ListTile(
                    // If you want to show just the last two digits like “41, 42…49”:
                    // title: Text(full.substring(2)),
                    title: Text(full),      // shows “1941, 1942 …”
                    onTap: () => onOptionSelected(full),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Iterable<String> _buildOptions(String raw, int min, int max) {
    final q = raw.trim();
    if (q.isEmpty) return const Iterable.empty();

    // When 3+ digits are typed (e.g. "194"), suggest the whole decade “1940…1949”
    if (q.length >= 3) {
      final n = int.tryParse(q);
      if (n == null) return const Iterable.empty();

      // decadeStart = first three digits + '0'  => "194" -> 1940
      final decadeStart = int.parse('${q.substring(0, 3)}0');
      final decade = List<int>.generate(10, (i) => decadeStart + i);
      return decade
          .where((y) => y >= min && y <= max)
          .map((y) => y.toString());
    }

    // For 1–2 digits typed, offer prefix matches and cap results
    final results = <int>[];
    for (int y = min; y <= max; y++) {
      if (y.toString().startsWith(q)) {
        results.add(y);
        if (results.length >= 12) break; // keep list short
      }
    }
    return results.map((e) => e.toString());
  }
}
