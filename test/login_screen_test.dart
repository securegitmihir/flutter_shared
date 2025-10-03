import 'package:assisted_living/app/app.dart';
import 'package:assisted_living/bloc/auth/auth_bloc.dart';
import 'package:assisted_living/bloc/common/common_bloc.dart';
import 'package:assisted_living/bloc/initial_profile_setup/initial_profile_setup_bloc.dart';
import 'package:assisted_living/bloc/login/login_bloc.dart';
import 'package:assisted_living/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:assisted_living/data/models/country_code_model.dart';
import 'package:assisted_living/data/models/validate_mobile_no_model.dart';
import 'package:assisted_living/data/repository/common_repo.dart';
import 'package:assisted_living/data/repository/otp_verification_repo.dart';
import 'package:assisted_living/data/repository/var_customer_repo.dart';
import 'package:assisted_living/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// ---- Mocks ----
class MockCommonRepository extends Mock implements CommonRepository {}

class MockOTPVerificationRepository extends Mock
    implements OTPVerificationRepository {}

class MockVarCustomerRepository extends Mock implements VarCustomerRepository {}

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
  late MockCommonRepository commonRepo;
  late MockOTPVerificationRepository otpRepo;
  late MockVarCustomerRepository varRepo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = FakeStorage();
  });

  tearDown(() async {
    await HydratedBloc.storage.clear();
  });

  setUp(() {
    commonRepo = MockCommonRepository();
    otpRepo = MockOTPVerificationRepository();
    varRepo = MockVarCustomerRepository();

    // Stub: CommonBloc → GetMobileCode result
    when(() => commonRepo.getCountryCodeList(any())).thenAnswer(
      (_) async => [
        CountryMobileCodesList(
          id: 1,
          countryCode: '+91',
          shortcode: 'Ind',
          numberLength: 10,
        ),
        CountryMobileCodesList(
          id: 2,
          countryCode: '+1',
          shortcode: 'USA',
          numberLength: 10,
        ),
        CountryMobileCodesList(
          id: 3,
          countryCode: '+44',
          shortcode: 'UK',
          numberLength: 11,
        ),
      ],
    );

    // Stub: OTP repo if your flow hits it later
    when(() => otpRepo.getOTP(any())).thenAnswer((_) async => '123456');

    // Stub: Var customer repo validate (used in SendOTP)
    when(() => varRepo.validateCustomerMobile(any())).thenAnswer(
      (_) async => ValidationResponse(isValid: true, alreadyRegistered: false),
    );
  });

  tearDown(() async {
    await HydratedBloc.storage.clear();
  });

  // group('Splash ➜ Login flow', () {
  //   testWidgets('tap Get Started navigates to Login; login widgets present', (
  //       tester,
  //       ) async {
  //     // Optional: enlarge test surface to avoid RenderFlex overflow on Splash
  //     tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
  //     tester.binding.window.devicePixelRatioTestValue = 1.0;
  //     addTearDown(() {
  //       tester.binding.window.clearPhysicalSizeTestValue();
  //       tester.binding.window.clearDevicePixelRatioTestValue();
  //     });
  //
  //     await tester.pumpWidget(
  //       MultiRepositoryProvider(
  //         providers: [
  //           // inject mocks
  //           RepositoryProvider<CommonRepository>.value(value: commonRepo),
  //           RepositoryProvider<OTPVerificationRepository>.value(value: otpRepo),
  //           RepositoryProvider<VarCustomerRepository>.value(value: varRepo),
  //         ],
  //         child: MultiBlocProvider(
  //           providers: [
  //             BlocProvider(create: (ctx) => LoginBloc(ctx.read<OTPVerificationRepository>(), ctx.read<VarCustomerRepository>())),
  //             BlocProvider(create: (ctx) => CommonBloc(ctx.read<CommonRepository>())..add(const GetMobileCode())),
  //             BlocProvider(create: (ctx) => OtpVerificationBloc(ctx.read<OTPVerificationRepository>())),
  //             BlocProvider(create: (_) => AuthBloc()),
  //             BlocProvider(create: (_) => InitialProfileSetupBloc()),
  //           ],
  //           child: const MyApp(),
  //         ),
  //       ),
  //     );
  //
  //     await tester.pumpAndSettle(const Duration(seconds: 2));
  //
  //     // Splash: button should exist
  //     expect(find.byKey(const Key('getStarted')), findsOneWidget);
  //
  //     // Tap and wait for navigation to Login
  //     await tester.tap(find.byKey(const Key('getStarted')));
  //     await tester.pumpAndSettle(const Duration(seconds: 2));
  //
  //     // Login screen widgets
  //     expect(find.byKey(const Key('mobileField')), findsOneWidget);
  //     expect(find.byKey(const Key('primaryBtn')), findsOneWidget);
  //   });
  //
  //   testWidgets('invalid mobile keeps primary button disabled', (tester) async {
  //     await _pumpApp(tester);
  //
  //     // Enter too-short number
  //     await tester.enterText(find.byKey(const Key('mobileField')), '12345');
  //     await tester.pump();
  //
  //     // Primary button should be disabled (onPressed == null)
  //     final ElevatedButton btn =
  //     tester.widget<ElevatedButton>(find.byType(ElevatedButton));
  //     expect(btn.onPressed, isNull);
  //
  //     // Still on login (OTP row should not exist)
  //     expect(find.byKey(const Key('otpRow')), findsNothing);
  //   });
  //
  //   testWidgets('valid mobile enables button → tap shows OTP row and button label changes to Verify',
  //           (tester) async {
  //             await tester.pumpWidget(
  //               MultiRepositoryProvider(
  //                 providers: [
  //                   // inject mocks
  //                   RepositoryProvider<CommonRepository>.value(value: commonRepo),
  //                   RepositoryProvider<OTPVerificationRepository>.value(value: otpRepo),
  //                   RepositoryProvider<VarCustomerRepository>.value(value: varRepo),
  //                 ],
  //                 child: MultiBlocProvider(
  //                   providers: [
  //                     BlocProvider(create: (ctx) => LoginBloc(ctx.read<OTPVerificationRepository>(), ctx.read<VarCustomerRepository>())),
  //                     BlocProvider(create: (ctx) => CommonBloc(ctx.read<CommonRepository>())..add(const GetMobileCode())),
  //                     BlocProvider(create: (ctx) => OtpVerificationBloc(ctx.read<OTPVerificationRepository>())),
  //                     BlocProvider(create: (_) => AuthBloc()),
  //                     BlocProvider(create: (_) => InitialProfileSetupBloc()),
  //                   ],
  //                   child: const MyApp(),
  //                 ),
  //               ),
  //             );
  //
  //         // Enter valid +91 number (your CommonRepo mock sets +91 length to 10)
  //         await tester.enterText(find.byKey(const Key('mobileField')), '9876543210');
  //         await tester.pump();
  //
  //         // Button should be enabled now
  //         var btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
  //         expect(btn.onPressed, isNotNull);
  //
  //         // Tap "Send OTP"
  //         await tester.tap(find.byKey(const Key('primaryBtn')));
  //         await tester.pumpAndSettle();
  //
  //         // OTP boxes row should appear
  //         expect(find.byKey(const Key('otpRow')), findsOneWidget);
  //
  //         // Button text should now be "Verify"
  //         expect(find.text('Verify'), findsOneWidget); // adjust if your label differs
  //       });
  //
  //   testWidgets('enter correct OTP (123456) → Verify enabled → tap navigates to Profile Setup',
  //           (tester) async {
  //         await _pumpApp(tester);
  //
  //         // Enter valid number and send OTP
  //         await tester.enterText(find.byKey(const Key('mobileField')), '9876543210');
  //         await tester.pump();
  //         await tester.tap(find.byKey(const Key('primaryBtn'))); // Send OTP
  //         await tester.pumpAndSettle();
  //
  //         // Ensure OTP row visible
  //         expect(find.byKey(const Key('otpRow')), findsOneWidget);
  //
  //         // Find the 6 TextFields inside the OTP row and type "123456"
  //         // (OtpBox wraps a TextField; this finds them in order)
  //         final otpTextFields = find.descendant(
  //           of: find.byKey(const Key('otpRow')),
  //           matching: find.byType(TextField),
  //         );
  //         expect(otpTextFields, findsNWidgets(6));
  //
  //         const otp = '123456';
  //         for (var i = 0; i < otp.length; i++) {
  //           await tester.enterText(otpTextFields.at(i), otp[i]);
  //           // small pump to propagate OTPEntered events
  //           await tester.pump(const Duration(milliseconds: 10));
  //         }
  //
  //         // Verify button should be enabled now
  //         var btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
  //         expect(btn.onPressed, isNotNull);
  //         expect(find.text('Verify'), findsOneWidget);
  //
  //         // Tap Verify
  //         await tester.tap(find.byKey(const Key('primaryBtn')));
  //         await tester.pumpAndSettle();
  //
  //         // Should navigate to Profile Setup (adjust matcher if your title text differs)
  //         expect(find.text('Profile Setup'), findsOneWidget);
  //       });
  // });

  group('Login validation + OTP flow', () {
    Future<void> pumpApp(WidgetTester tester) async {
      // Make the surface roomy to avoid overflow during any screen
      // tester.binding.window.physicalSizeTestValue = const Size(2000, 4000);
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
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<CommonRepository>.value(value: commonRepo),
            RepositoryProvider<OTPVerificationRepository>.value(value: otpRepo),
            RepositoryProvider<VarCustomerRepository>.value(value: varRepo),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (ctx) => LoginBloc(
                  ctx.read<OTPVerificationRepository>(),
                  ctx.read<VarCustomerRepository>(),
                ),
              ),
              BlocProvider(
                create: (ctx) =>
                    CommonBloc(ctx.read<CommonRepository>())
                      ..add(const GetMobileCode()),
              ),
              BlocProvider(
                create: (ctx) =>
                    OtpVerificationBloc(ctx.read<OTPVerificationRepository>()),
              ),
              BlocProvider(create: (_) => AuthBloc()),
              BlocProvider(create: (_) => InitialProfileSetupBloc()),
            ],
            child: ChangeNotifierProvider(
              create: (_) => ThemeState(),
              child:const MyApp(),
            )
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Splash -> Login
      expect(find.byKey(const Key('getStarted')), findsOneWidget);
      await tester.tap(find.byKey(const Key('getStarted')));
      await tester.pumpAndSettle();

      // On login
      expect(find.byKey(const Key('mobileField')), findsOneWidget);
      expect(find.byKey(const Key('primaryBtn')), findsOneWidget);

      // Sanity: must start on enterMobile (no OTP row yet)
      expect(find.byKey(const Key('otpRow')).hitTestable(), findsNothing);
      expect(find.text('Verify'), findsNothing);
    }

    testWidgets('invalid mobile keeps primary button disabled', (tester) async {
      await pumpApp(tester);

      await tester.enterText(find.byKey(const Key('mobileField')), '12345');
      await tester.pump();

      final ElevatedButton btn = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(btn.onPressed, isNull);

      // Still not on OTP step
      expect(find.byKey(const Key('otpRow')).hitTestable(), findsNothing);
      expect(find.text('Verify'), findsNothing);
    });

    testWidgets(
      'valid mobile enables button → tap shows OTP row and button label changes to Verify',
      (tester) async {
        await pumpApp(tester);

        // Enter valid +91 number. VarCustomerRepository mock returns isValid:true for anything,
        // but in-app mock repo returns true for 9999999999; use that to mirror app behavior closely.
        await tester.enterText(
          find.byKey(const Key('mobileField')),
          '9999999999',
        );
        await tester.pump();

        // Button enabled
        var btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNotNull);

        // Tap "Send OTP"
        await tester.tap(find.byKey(const Key('primaryBtn')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.byKey(const Key('otpRow')), findsOneWidget);
        expect(find.text('Verify'), findsOneWidget);
        // Let the OTP timer finish so the test ends cleanly (prevents "pending timers")
        await tester.pump(const Duration(seconds: 61));
      },
    );

    testWidgets(
      'enter correct OTP (123456) → Verify enabled → tap navigates to Profile Setup',
      (tester) async {
        await pumpApp(tester);

        // Valid mobile + send OTP
        await tester.enterText(
          find.byKey(const Key('mobileField')),
          '9999999999',
        );
        await tester.pump();
        await tester.tap(find.byKey(const Key('primaryBtn')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        // OTP row present
        expect(find.byKey(const Key('otpRow')), findsOneWidget);

        // Enter "123456" into 6 boxes
        final otpTextFields = find.descendant(
          of: find.byKey(const Key('otpRow')),
          matching: find.byType(TextField),
        );
        expect(otpTextFields, findsNWidgets(6));

        const otp = '123456';
        for (var i = 0; i < otp.length; i++) {
          await tester.enterText(otpTextFields.at(i), otp[i]);
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Verify enabled
        var btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNotNull);
        expect(find.text('Verify'), findsOneWidget);

        // Tap Verify
        await tester.tap(find.byKey(const Key('primaryBtn')));
        await tester.pumpAndSettle();

        // Navigated to Profile Setup
        expect(
          find.text('Profile Setup'),
          findsOneWidget,
          reason: 'We should be on Profile Setup after verified OTP',
        );

        await tester.pump(const Duration(seconds: 61));

        // "Kill" and "relaunch" the app: re-pump MyApp using the SAME Hydrated storage.
        // DO NOT clear HydratedBloc.storage here; your tearDown() will run only after this test.
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<CommonRepository>.value(value: commonRepo),
              RepositoryProvider<OTPVerificationRepository>.value(value: otpRepo),
              RepositoryProvider<VarCustomerRepository>.value(value: varRepo),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (ctx) => LoginBloc(
                  ctx.read<OTPVerificationRepository>(),
                  ctx.read<VarCustomerRepository>(),
                )),
                BlocProvider(create: (ctx) => CommonBloc(ctx.read<CommonRepository>())),
                BlocProvider(create: (ctx) => OtpVerificationBloc(ctx.read<OTPVerificationRepository>())),
                BlocProvider(create: (_) => AuthBloc()),                 // <- Hydrated: reads isLoggedIn:true
                BlocProvider(create: (_) => InitialProfileSetupBloc()),
              ],
              child: ChangeNotifierProvider(
                create: (_) => ThemeState(),
                child: const MyApp(),
              )
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Back on Splash -> tap Get Started
        // expect(find.byKey(const Key('getStarted')), findsOneWidget);
        // await tester.tap(find.byKey(const Key('getStarted')));
        // await tester.pumpAndSettle();

        // Because AuthBloc hydrated state has isLoggedIn:true,
        // Splash should route directly to Profile Setup, skipping Login.
        expect(find.text('Profile Setup'), findsOneWidget);
        expect(find.byKey(const Key('getStarted')), findsNothing);
        expect(find.byKey(const Key('mobileField')), findsNothing);
      },
    );
  });
}
