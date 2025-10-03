part of 'package:assisted_living/theme/app_theme.dart';

class ThemeState extends ChangeNotifier {

  // final themeHive = serviceLocator<LocalStorageService>();

  ThemeType themeType =
      (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark)
      ? ThemeType.dark
      : ThemeType.light;

  ThemeState() {
    _readThemeAsync();
  }

  Future<void> _readThemeAsync() async {
    // final fromLocal = await themeHive.read('hive_theme') ?? themeType;
    final fromLocal = SharedPrefsService().getString("hive_theme") ?? themeType;
    if (fromLocal == ThemeType.dark.toString()) {
      themeType = ThemeType.dark;
    } else if (fromLocal == ThemeType.light.toString()) {
      themeType = ThemeType.light;
    }

    notifyListeners();
  }

  void changeTheme() async {
    themeType = themeType == ThemeType.light ? ThemeType.dark : ThemeType.light;
    await SharedPrefsService().saveString("hive_theme", themeType.toString());
    notifyListeners();
  }
}
