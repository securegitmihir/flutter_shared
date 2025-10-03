import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:assisted_living/app/routes/route_generator.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../services/nav_observer..dart';
import '../theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeType = context.watch<ThemeState>().themeType;
    final theme = AppTheme.getTheme(themeType, context.responsive);

    print("Width: ${MediaQuery.of(context).size.width}");
    print("Height: ${MediaQuery.of(context).size.height}");
    return ScreenUtilInit(
      designSize: const Size(412, 870),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Assisted Living India Project - Services',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        // ),
        theme: theme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [appRouteObserver],
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
      ),
    );
  }
}
