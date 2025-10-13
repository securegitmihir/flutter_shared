import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/app_colors.dart';
import '../../services/shared_pref_service.dart';
import '../widgets/custom_appbar.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final _ctrl = TextEditingController();
  bool _saving = false;
  DateTime? _lastSaved;

  static const _kDiaryTextKey = 'diary_text';
  static const _kDiarySavedAtKey = 'diary_saved_at';

  @override
  void initState() {
    super.initState();
    _load();
    _ctrl.addListener(_autosave); // lightweight debounce below
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    // final prefs = await SharedPreferences.getInstance();
    _ctrl.text = SharedPrefsService().getString(_kDiaryTextKey) ?? '';
    final ts = SharedPrefsService().getInt(_kDiarySavedAtKey);
    setState(() => _lastSaved = DateTime.fromMillisecondsSinceEpoch(ts));
  }

  DateTime? _pendingChangeAt;
  void _autosave() async {
    // simple debounce: wait ~800ms after last keypress
    _pendingChangeAt = DateTime.now();
    await Future.delayed(const Duration(milliseconds: 800));
    if (_pendingChangeAt == null) return;
    final diff = DateTime.now().difference(_pendingChangeAt!);
    if (diff.inMilliseconds >= 750) _save(silent: true);
  }

  Future<void> _save({bool silent = false}) async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDiaryTextKey, _ctrl.text);
    final now = DateTime.now();
    await prefs.setInt(_kDiarySavedAtKey, now.millisecondsSinceEpoch);
    setState(() {
      _saving = false;
      _lastSaved = now;
    });
    if (!silent && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  Future<bool> _onWillPop() async {
    await _save(silent: true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          title: CustomTextWidget(
            'Diary',
            style: Theme.of(context).textTheme
                .rTitleMedium(context)!
                .copyWith(color: AppColors.whiteColor),
          ),
          foregroundColor: AppColors.whiteColor,
          gradient: const LinearGradient(
            colors: [AppColors.gradientLightColor, AppColors.gradientDarkColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          centerTitle: false,
          // flexibleSpace: const DecoratedBox(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [AppColors.appBarColor, AppColors.appBarDarkColor],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //   ),
          // ),
          actions: [
            if (_saving)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              IconButton(
                tooltip: 'Save',
                icon: const Icon(Icons.check),
                onPressed: () => _save(),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_lastSaved != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Last saved: ${_lastSaved!.toLocal()}',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts…',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
