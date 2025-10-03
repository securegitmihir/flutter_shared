import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:assisted_living/bloc/auth/auth_bloc.dart';
import 'package:assisted_living/bloc/initial_profile_setup/initial_profile_setup_bloc.dart';
import 'package:assisted_living/presentation/screens/profile_setup_screen.dart';
import 'package:assisted_living/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FakeStorage implements Storage {
  final Map<String, String?> _store = {};

  @override
  dynamic read(String key) => _store[key];

  @override
  Future<void> write(String key, value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  @override
  Future<void> close() {
    throw UnimplementedError();
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = FakeStorage();
  });

  tearDown(() async {
    await HydratedBloc.storage.clear();
  });

  group('Profile Setup form validation', () {
    Future<void> pumpProfileSetup(WidgetTester tester) async {
      // make the surface roomy to avoid overflow with big paddings/fonts
      // tester.binding.window.physicalSizeTestValue = const Size(1440, 3040);
      tester.view.physicalSize = const Size(2000, 4000);
      // tester.binding.window.devicePixelRatioTestValue = 1.0;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        // tester.binding.window.clearPhysicalSizeTestValue();
        tester.view.resetPhysicalSize();
        // tester.binding.window.clearDevicePixelRatioTestValue();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthBloc()),
            BlocProvider(create: (_) => InitialProfileSetupBloc()),
          ],
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
              home: child,
              routes: {
                AppRoutes.dashboard: (_) => const Scaffold(
                  body: Center(child: Text('Dashboard')),
                ),
              },
            ),
            child: const ProfileSetup(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Profile Setup'), findsOneWidget);
    }

    CustomButton saveBtn(WidgetTester t) =>
        t.widget<CustomButton>(find.byKey(const Key('saveContinueBtn')));
    InitialProfileSetupBloc blocOf(WidgetTester t) =>
        BlocProvider.of<InitialProfileSetupBloc>(t.element(find.byType(ProfileSetup)));

    testWidgets('Save button disabled until required fields valid', (tester) async {
      await pumpProfileSetup(tester);

      // Initially disabled
      expect(saveBtn(tester).isValid, isFalse);

      // Full name must be first + last
      await tester.enterText(find.byKey(const Key('fullNameField')), 'Shruti A');
      await tester.pump();
      expect(saveBtn(tester).isValid, isFalse, reason: 'birth year + gender missing');

      // Drive the dropdown/radio via bloc
      final bloc = blocOf(tester);
      bloc.add(BirthYearChanged(DateTime.now().year.toString()));
      bloc.add(GenderChanged('Male'));
      await tester.pump();

      expect(saveBtn(tester).isValid, isTrue, reason: 'required fields satisfied');
    });

    testWidgets('Email must be valid if provided', (tester) async {
      await pumpProfileSetup(tester);

      // Required fields
      await tester.enterText(find.byKey(const Key('fullNameField')), 'Shruti A');
      final bloc = blocOf(tester);
      bloc.add(BirthYearChanged(DateTime.now().year.toString()));
      bloc.add(GenderChanged('Female'));
      await tester.pump();
      expect(saveBtn(tester).isValid, isTrue, reason: 'email is optional if empty');

      // Invalid email disables
      await tester.enterText(find.byKey(const Key('emailField')), 'bademail');
      await tester.pump();
      expect(saveBtn(tester).isValid, isFalse);

      // Valid email enables
      await tester.enterText(find.byKey(const Key('emailField')), 'jane@example.com');
      await tester.pump();
      expect(saveBtn(tester).isValid, isTrue);
    });

    testWidgets('Click Save & Continue navigates to dashboard', (tester) async {
      await pumpProfileSetup(tester);

      // Fill valid data
      await tester.enterText(find.byKey(const Key('fullNameField')), 'Mark User');
      final bloc = blocOf(tester);
      bloc.add(BirthYearChanged(DateTime.now().year.toString()));
      bloc.add(GenderChanged('Male'));
      await tester.enterText(find.byKey(const Key('emailField')), 'mark@domain.com');
      await tester.pump();
      expect(saveBtn(tester).isValid, isTrue);

      // Tap save
      await tester.tap(find.byKey(const Key('saveContinueBtn')));
      await tester.pumpAndSettle();

      // Reached dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
