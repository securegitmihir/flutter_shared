// import 'package:assisted_living/responsive/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // import '../../services/locale_provider.dart';
//
// class LanguagePopup extends StatefulWidget {
//   const LanguagePopup({super.key});
//
//   @override
//   State<LanguagePopup> createState() => _LanguagePopupState();
// }
//
// class _LanguagePopupState extends State<LanguagePopup> {
//   // Add more later; scroll view will handle it
//   final List<Locale> _options = const [
//     Locale('en'),
//     Locale('hi'),
//   ];
//
//   late Locale? _selected;
//
//   @override
//   void initState() {
//     super.initState();
//     // final lp = context.read<LocaleProvider>();
//     _selected = lp.effectiveLocale; // preselect current
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.responsive;
//     final theme = Theme.of(context);
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.px(16))),
//       insetPadding: EdgeInsets.symmetric(horizontal: r.space(20), vertical: r.space(24)),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(maxHeight: r.px(460), minWidth: r.px(320)),
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(r.space(16), r.space(16), r.space(16), r.space(12)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text('Choose language', style: theme.textTheme.titleLarge),
//               SizedBox(height: r.px(6)),
//               Text(
//                 'You can change this later in Settings.',
//                 style: theme.textTheme.bodyMedium,
//               ),
//               SizedBox(height: r.px(12)),
//
//               // Scrollable list (even if only 2 for now)
//               Expanded(
//                 child: Scrollbar(
//                   thumbVisibility: true,
//                   child: ListView.separated(
//                     itemCount: _options.length,
//                     separatorBuilder: (_, __) => Divider(height: r.px(1)),
//                     itemBuilder: (_, i) {
//                       final loc = _options[i];
//                       final isSelected = _selected?.languageCode == loc.languageCode;
//
//                       return ListTile(
//                         contentPadding: EdgeInsets.symmetric(horizontal: r.space(4)),
//                         title: Text(_labelFor(loc)),
//                         leading: Radio<Locale>(
//                           value: loc,
//                           groupValue: _selected,
//                           onChanged: (val) => setState(() => _selected = val),
//                         ),
//                         onTap: () => setState(() => _selected = loc),
//                         minVerticalPadding: r.space(16), // larger tap target
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: r.px(12)),
//
//               // Actions: Skip (follow system) + Continue
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () async {
//                         // Skip → follow system (no override)
//                         await context.read<LocaleProvider>().setOverride(null);
//                         // If you don't use the binder, also do: await context.setLocale(PlatformDispatcher.instance.locale);
//                         if (mounted) Navigator.pop(context);
//                       },
//                       child: Text('Skip'),
//                     ),
//                   ),
//                   SizedBox(width: r.px(12)),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (_selected != null) {
//                           await context.read<LocaleProvider>().setOverride(_selected);
//                           // If you don’t use EasyLocaleBinder, also call:
//                           // await context.setLocale(Locale(_selected!.languageCode));
//                         }
//                         if (mounted) Navigator.pop(context);
//                       },
//                       child: Text('Continue'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _labelFor(Locale l) {
//     switch (l.languageCode) {
//       case 'hi':
//         return 'हिंदी';
//       case 'en':
//       default:
//         return 'English';
//     }
//   }
// }
