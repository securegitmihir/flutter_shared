import 'package:assisted_living/bloc/auth/auth_bloc.dart';
import 'package:assisted_living/bloc/initial_profile_setup/initial_profile_setup_bloc.dart';
import 'package:assisted_living/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:assisted_living/services/language/localization_wrapper.dart';
import 'package:assisted_living/services/log_service.dart';
import 'package:assisted_living/services/shared_pref_service.dart';
import 'package:assisted_living/theme/app_theme.dart';
import 'package:assisted_living/services/language/language_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'bloc/common/common_bloc.dart';
import 'bloc/login/login_bloc.dart';
import 'data/data_provider/common_dp.dart';
import 'data/data_provider/otp_verification_dp.dart';
import 'data/data_provider/var_customer_dp.dart';
import 'data/repository/common_repo.dart';
import 'data/repository/otp_verification_repo.dart';
import 'data/repository/var_customer_repo.dart';

late HydratedStorage hydratedStorage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init();
  await LogService.init();
  hydratedStorage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  HydratedBloc.storage = hydratedStorage;

  final localStorage = await SharedPreferences.getInstance();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CommonRepository(CommonDataProvider()),
        ),
        RepositoryProvider(
          create: (context) =>
              OTPVerificationRepository(OTPVerificationDataProvider()),
        ),
        RepositoryProvider(
          create: (context) => VarCustomerRepository(VarCustomerDataProvider()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              context.read<OTPVerificationRepository>(),
              context.read<VarCustomerRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CommonBloc(context.read<CommonRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                OtpVerificationBloc(context.read<OTPVerificationRepository>()),
          ),
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (_) => InitialProfileSetupBloc()),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeState()),
            Provider(create: (_) => localStorage),
            ChangeNotifierProvider(
              create: (buildContext) =>
                  LanguageState.initiateState(localStorage),
            ),
          ],
          child: LocalizationWrapper(child: MyApp()),
        ),
      ),
    ),
  );
}
