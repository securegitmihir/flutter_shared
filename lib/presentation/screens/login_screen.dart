import 'package:assisted_living/bloc/auth/auth_bloc.dart';
import 'package:assisted_living/presentation/widgets/custom_button.dart';
import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:assisted_living/presentation/widgets/mobile_input_field.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/routes/app_routes.dart';
import '../../bloc/common/common_bloc.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/otp_verification/otp_verification_bloc.dart';
import '../../data/data_provider/app_update_dp.dart';
import '../../data/models/country_code_model.dart';
import '../../data/repository/app_update_repo.dart';
import '../../app/configuration/enum.dart';
import '../../services/snackbar_service.dart';
import '../../utilities/utility_functions.dart';
import '../widgets/app_update_prompter.dart';
import '../widgets/language_pop_up.dart';
import '../widgets/otp_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  late CommonBloc _commonBloc;
  late AuthBloc _authBloc;
  List<CountryMobileCodesList>? _mobileCodeList;
  bool _countryCodeFetchFailure = true;
  ApiStatus mobileCodeStatus = ApiStatus.loading;
  final _phoneController = TextEditingController();
  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    _commonBloc = context.read<CommonBloc>();
    _commonBloc.add(const GetMobileCode());
    _loginBloc = context.read<LoginBloc>();
    _authBloc = context.read<AuthBloc>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkUpdate());
  }

  Future<void> _checkUpdate() async {
    final repo = AppUpdateRepository(AppUpdateDataProvider());
    print('App update repo');
    final decision = await repo.checkForUpdate();
    if (!mounted) return;
    await UpdatePrompter.show(context, decision, iosAppId: 'YOUR_APPSTORE_ID');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final n in _otpNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    final kbOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocListener<OtpVerificationBloc, OtpVerificationState>(
      listenWhen: (prev, curr) =>
          curr is OtpVerificationSuccessful || curr is OtpVerificationFailed,
      listener: (context, state) async {
        if (state is OtpVerificationSuccessful) {
          _authBloc.add(IsLoggedIn(true));
          // reset OTP bloc for next time
          context.read<OtpVerificationBloc>().add(ResetEvent());

          // if (context.mounted) {
          //   await showDialog<void>(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (_) => const LanguagePopup(),
          //   );
          // }

          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.profileSetup);
        }
        // else if (state is OtpVerificationFailed) {
        //   SnackBarService.showErrorSnackBar(content: state.error!);
        // }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<CommonBloc, CommonState>(
          listener: (context, state) {
            if (state is MobileCodeLoading) {
              mobileCodeStatus = ApiStatus.loading;
            }
            if (state is MobileCodeFetched) {
              mobileCodeStatus = ApiStatus.success;
              _mobileCodeList = state.mobileCodes;
              _loginBloc.add(SetDefaultValue(mobileCodes: _mobileCodeList!));
              _countryCodeFetchFailure = false;
            }
            if (state is MobileCodeFailure) {
              mobileCodeStatus = ApiStatus.failure;
              SnackBarService.showErrorSnackBar(content: state.error!);
              _countryCodeFetchFailure = true;
            }
          },
          builder: (context, state) {
            return BlocConsumer<LoginBloc, LoginState>(
              listenWhen: (previous, current) => previous.step != current.step,
              listener: (context, state) {
                if (state.step == LoginFlowStep.enterMobile) {
                  _phoneController.clear();
                }
                if (state.step == LoginFlowStep.verifyOtp) {
                  // clear boxes & focus first
                  for (final c in _otpCtrls) {
                    c.clear();
                  }
                  _otpNodes.first.requestFocus();

                  // set actual OTP & start timer ONCE
                  final otpBloc = context.read<OtpVerificationBloc>();
                  otpBloc.add(SetNewOTPEvent(otp: state.receivedOTP));
                  otpBloc.add(StartTimer(time: 60));
                }
                if (state is LoginSuccess) {
                } else if (state is LoginError) {
                  SnackBarService.showErrorSnackBar(
                    content: state.loginErrorMsg.toString(),
                  );
                }
              },
              builder: (context, state) {
                final onOtpStep = state.step == LoginFlowStep.verifyOtp;
                return GestureDetector(
                  onTap: () {
                    UtilityFunctions.closeKeyboard();
                  },
                  child: LayoutBuilder(
                    builder: (context, c) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: c.maxHeight),
                          child: IntrinsicHeight(
                            child: SafeArea(
                              // child: Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: AnimatedPadding(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                padding: EdgeInsets.only(
                                  // left: 16.w,
                                  left: r.space(16),
                                  // right: 16.w,
                                  right: r.space(16),
                                  bottom: onOtpStep
                                      ? MediaQuery.of(context).viewInsets.bottom
                                      : 0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(height: (onOtpStep && kbOpen) ? 110.h : 157.h),
                                    SizedBox(
                                      height: (onOtpStep && kbOpen)
                                          ? r.px(110)
                                          : r.px(157),
                                    ),
                                    // SizedBox(height: 157),
                                    // Image.asset("assets/images/logo.png", height: 28.h),
                                    Image.asset(
                                      "assets/images/logo.png",
                                      height: r.px(28),
                                      width: r.px(125),
                                    ),
                                    // SizedBox(height: 26.h),
                                    SizedBox(height: r.px(26)),
                                    CustomTextWidget(
                                      "login.welcome".tr(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.rHeadlineMedium(context)!,
                                      // kohinoorSemiBold.copyWith(
                                      //   fontSize: 24.sp,
                                      //   fontWeight: FontWeight.w600,
                                      //   color: AppColors.darkTextColor,
                                      // ),
                                    ),
                                    // SizedBox(height: 20.h),
                                    SizedBox(height: r.px(20)),
                                    CustomTextWidget(
                                      "login.enterNumber".tr(),
                                      style: Theme.of(context).textTheme
                                          .rLabelMedium(context)!
                                          .copyWith(fontSize: r.font(14)),
                                      // kohinoorRegular.copyWith(
                                      //   fontSize: 14.sp,
                                      //   fontWeight: FontWeight.w400,
                                      //   color: AppColors.primaryColor,
                                      // ),
                                    ),
                                    // SizedBox(height: 5.h),
                                    SizedBox(height: r.px(5)),
                                    MobileInputField(
                                      key: const Key('mobileField'),
                                      controller: _phoneController,
                                      allowedLength: state.allowedLength,
                                      mobileCodes:
                                          UtilityFunctions.getCountryCodeList(
                                            _mobileCodeList,
                                          ),
                                      textInputAction: TextInputAction.next,
                                      selectedCode: state.selectedCountryCode,
                                      onCountryCodeSelected: (selectedCountry) {
                                        _loginBloc.add(
                                          CountryCodeSelected(
                                            selectedCountryCodeId:
                                                UtilityFunctions.getCountryCodeKeyFromValue(
                                                  _mobileCodeList!,
                                                  selectedCountry,
                                                )!,
                                            selectedCountryCode:
                                                selectedCountry,
                                            mobileCodes: _mobileCodeList!,
                                          ),
                                        );
                                      },
                                      mobileNoChanged: (mobileNo) {
                                        _loginBloc.add(
                                          VerifyMobileNumber(
                                            mobileNumber: mobileNo,
                                            mobileCodes: _mobileCodeList!,
                                          ),
                                        );
                                      },
                                      errorText: !state.isMobileNoValid
                                          ? state.mobileErrorMsg
                                          : null,
                                      // enabled: !_countryCodeFetchFailure,
                                      enabled:
                                          !onOtpStep &&
                                          !_countryCodeFetchFailure,
                                      countryCodeStatus: mobileCodeStatus,
                                    ),
                                    // SizedBox(height: onOtpStep ? 0.h : 14.h),
                                    SizedBox(
                                      height: onOtpStep ? r.px(0) : r.px(14),
                                    ),
                                    if (onOtpStep)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => context
                                              .read<LoginBloc>()
                                              .add(BackToEditPhone()),
                                          child: CustomTextWidget(
                                            "login.changeNumber".tr(),
                                            style: Theme.of(context).textTheme
                                                .rBodyMedium(context)!
                                                .copyWith(fontSize: r.font(14)),
                                            // kohinoorRegular.copyWith(
                                            //   fontSize: 14.sp,
                                            //   fontWeight: FontWeight.w400,
                                            //   color: AppColors.primaryColor,
                                            // ),
                                          ),
                                        ),
                                      )
                                    else
                                      Wrap(
                                        children: [
                                          CustomTextWidget(
                                            "login.note".tr(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.rBodyMedium(context)!,
                                            // kohinoorRegular.copyWith(
                                            //   fontSize: 16.sp,
                                            //   fontWeight: FontWeight.w400,
                                            //   color: AppColors.textColor,
                                            // ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.terms,
                                              );
                                            },
                                            child: CustomTextWidget(
                                              "login.terms".tr(),
                                              style: Theme.of(context).textTheme
                                                  .rBodyMedium(context)!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                              // kohinoorSemiBold.copyWith(
                                              //   fontSize: 16.sp,
                                              //   fontWeight: FontWeight.w600,
                                              //   color: AppColors.highlightedTextColor,
                                              //   decoration: TextDecoration.underline,
                                              // ),
                                            ),
                                          ),
                                          CustomTextWidget(
                                            "login.and".tr(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.rBodyMedium(context)!,
                                            // kohinoorMedium.copyWith(
                                            //   fontSize: 16.sp,
                                            //   color: AppColors.textColor,
                                            // ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.privacy,
                                              );
                                            },
                                            child: CustomTextWidget(
                                              "login.privacy".tr(),
                                              style: Theme.of(context).textTheme
                                                  .rBodyMedium(context)!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                              // style: kohinoorSemiBold.copyWith(
                                              //   fontSize: 16.sp,
                                              //   fontWeight: FontWeight.w600,
                                              //   color: AppColors.highlightedTextColor,
                                              //   decoration: TextDecoration.underline,
                                              // ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    // SizedBox(height: 12.h),
                                    SizedBox(height: r.px(12)),
                                    AnimatedCrossFade(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      crossFadeState: onOtpStep
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      firstChild: const SizedBox.shrink(),
                                      secondChild: Column(
                                        children: [
                                          SizedBox(
                                            // height: 56.h,
                                            height: r.px(56),
                                            child: Row(
                                              key: const Key('otpRow'),
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(6, (
                                                index,
                                              ) {
                                                return OtpBox(
                                                  controller: _otpCtrls[index],
                                                  focusNode: _otpNodes[index],
                                                  nextFocus: index < 5
                                                      ? _otpNodes[index + 1]
                                                      : null,
                                                  prevFocus: index > 0
                                                      ? _otpNodes[index - 1]
                                                      : null,
                                                  onChanged: (_) =>
                                                      _notifyOtpChanged(),
                                                );
                                              }),
                                            ),
                                          ),
                                          // SizedBox(height: 12.h),
                                          SizedBox(height: r.px(12)),
                                        ],
                                      ),
                                    ),
                                    if (!(onOtpStep && kbOpen))
                                      const Spacer()
                                    else
                                      // SizedBox(height: 25.h),
                                      SizedBox(height: r.px(25)),
                                    BlocBuilder<
                                      OtpVerificationBloc,
                                      OtpVerificationState
                                    >(
                                      builder: (context, otpState) {
                                        final onOtpStep =
                                            state.step ==
                                            LoginFlowStep.verifyOtp;
                                        final isBtnEnabled = onOtpStep
                                            ? otpState.isOtpValid
                                            : state.isMobileNoValid;

                                        return CustomButton(
                                          key: const Key('primaryBtn'),
                                          buttonText: onOtpStep
                                              ? "login.verify".tr()
                                              : "login.sendOtp".tr(),
                                          isValid: isBtnEnabled,
                                          onClick: () {
                                            FocusScope.of(context).unfocus();
                                            if (onOtpStep) {
                                              // optional: verify here using entered OTP vs actual
                                              context
                                                  .read<OtpVerificationBloc>()
                                                  .add(
                                                    VerifyButtonClicked(
                                                      enteredOtp:
                                                          otpState.enteredOtp,
                                                      actualOtp:
                                                          state.receivedOTP,
                                                    ),
                                                  );
                                            } else {
                                              _loginBloc.add(SendOTP());
                                            }
                                          },
                                          isLoading: state.isLoginLoading,
                                        );
                                      },
                                    ),
                                    // SizedBox(height: 20.h),
                                    SizedBox(height: r.px(20)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    // child: SingleChildScrollView(
                    //   child: ConstrainedBox(
                    //     constraints: BoxConstraints(minHeight: c.maxHeight),
                    //     child: IntrinsicHeight(
                    //       child: SafeArea(
                    //         // child: Padding(
                    //         //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //         child: AnimatedPadding(
                    //           duration: const Duration(milliseconds: 200),
                    //           curve: Curves.easeOut,
                    //           padding: EdgeInsets.only(
                    //             // left: 16.w,
                    //             left: r.space(16),
                    //             // right: 16.w,
                    //             right: r.space(16),
                    //             bottom: onOtpStep
                    //                 ? MediaQuery.of(context).viewInsets.bottom
                    //                 : 0,
                    //           ),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               // SizedBox(height: (onOtpStep && kbOpen) ? 110.h : 157.h),
                    //               SizedBox(height: (onOtpStep && kbOpen) ? r.px(110) : r.px(157)),
                    //               // SizedBox(height: 157),
                    //               // Image.asset("assets/images/logo.png", height: 28.h),
                    //               Image.asset("assets/images/logo.png", height: r.px(28), width: r.px(125),),
                    //               // SizedBox(height: 26.h),
                    //               SizedBox(height: r.px(26)),
                    //               CustomTextWidget(
                    //                 Strings.welcome,
                    //                 style: Theme.of(context).textTheme
                    //                   .rHeadlineMedium(context)!,
                    //                 // kohinoorSemiBold.copyWith(
                    //                 //   fontSize: 24.sp,
                    //                 //   fontWeight: FontWeight.w600,
                    //                 //   color: AppColors.darkTextColor,
                    //                 // ),
                    //               ),
                    //               // SizedBox(height: 20.h),
                    //               SizedBox(height: r.px(20)),
                    //               CustomTextWidget(
                    //                 Strings.enterNumber,
                    //                 style: Theme.of(context).textTheme
                    //                     .rLabelMedium(context)!.copyWith(fontSize: r.font(14)),
                    //                 // kohinoorRegular.copyWith(
                    //                 //   fontSize: 14.sp,
                    //                 //   fontWeight: FontWeight.w400,
                    //                 //   color: AppColors.primaryColor,
                    //                 // ),
                    //               ),
                    //               // SizedBox(height: 5.h),
                    //               SizedBox(height: r.px(5)),
                    //               MobileInputField(
                    //                 key: const Key('mobileField'),
                    //                 controller: _phoneController,
                    //                 allowedLength: state.allowedLength,
                    //                 mobileCodes: UtilityFunctions.getCountryCodeList(
                    //                   _mobileCodeList,
                    //                 ),
                    //                 textInputAction: TextInputAction.next,
                    //                 selectedCode: state.selectedCountryCode,
                    //                 onCountryCodeSelected: (selectedCountry) {
                    //                   _loginBloc.add(
                    //                     CountryCodeSelected(
                    //                       selectedCountryCodeId:
                    //                           UtilityFunctions.getCountryCodeKeyFromValue(
                    //                             _mobileCodeList!,
                    //                             selectedCountry,
                    //                           )!,
                    //                       selectedCountryCode: selectedCountry,
                    //                       mobileCodes: _mobileCodeList!,
                    //                     ),
                    //                   );
                    //                 },
                    //                 mobileNoChanged: (mobileNo) {
                    //                   _loginBloc.add(
                    //                     VerifyMobileNumber(
                    //                       mobileNumber: mobileNo,
                    //                       mobileCodes: _mobileCodeList!,
                    //                     ),
                    //                   );
                    //                 },
                    //                 errorText: !state.isMobileNoValid
                    //                     ? state.mobileErrorMsg
                    //                     : null,
                    //                 // enabled: !_countryCodeFetchFailure,
                    //                 enabled: !onOtpStep && !_countryCodeFetchFailure,
                    //                 countryCodeStatus: mobileCodeStatus,
                    //               ),
                    //               // SizedBox(height: onOtpStep ? 0.h : 14.h),
                    //               SizedBox(height: onOtpStep ? r.px(0) : r.px(14)),
                    //               if (onOtpStep)
                    //                 Align(
                    //                   alignment: Alignment.centerRight,
                    //                   child: TextButton(
                    //                     onPressed: () => context.read<LoginBloc>().add(
                    //                       BackToEditPhone(),
                    //                     ),
                    //                     child: CustomTextWidget(
                    //                       Strings.changeNumber,
                    //                       style: Theme.of(context).textTheme
                    //                           .rBodyMedium(context)!.copyWith(fontSize: r.font(14)),
                    //                       // kohinoorRegular.copyWith(
                    //                       //   fontSize: 14.sp,
                    //                       //   fontWeight: FontWeight.w400,
                    //                       //   color: AppColors.primaryColor,
                    //                       // ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               else
                    //                 Wrap(
                    //                   children: [
                    //                     CustomTextWidget(
                    //                       Strings.note,
                    //                       style: Theme.of(context).textTheme
                    //                           .rBodyMedium(context)!,
                    //                       // kohinoorRegular.copyWith(
                    //                       //   fontSize: 16.sp,
                    //                       //   fontWeight: FontWeight.w400,
                    //                       //   color: AppColors.textColor,
                    //                       // ),
                    //                     ),
                    //                     GestureDetector(
                    //                       onTap: () {
                    //                         Navigator.pushNamed(context, AppRoutes.terms);
                    //                       },
                    //                       child: CustomTextWidget(
                    //                         Strings.terms,
                    //                         style: Theme.of(context).textTheme
                    //                             .rBodyMedium(context)!.copyWith(fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                    //                         // kohinoorSemiBold.copyWith(
                    //                         //   fontSize: 16.sp,
                    //                         //   fontWeight: FontWeight.w600,
                    //                         //   color: AppColors.highlightedTextColor,
                    //                         //   decoration: TextDecoration.underline,
                    //                         // ),
                    //                       ),
                    //                     ),
                    //                     CustomTextWidget(
                    //                       Strings.and,
                    //                       style: Theme.of(context).textTheme
                    //                           .rBodyMedium(context)!,
                    //                       // kohinoorMedium.copyWith(
                    //                       //   fontSize: 16.sp,
                    //                       //   color: AppColors.textColor,
                    //                       // ),
                    //                     ),
                    //                     GestureDetector(
                    //                       onTap: () {
                    //                         Navigator.pushNamed(context, AppRoutes.privacy);
                    //                       },
                    //                       child: CustomTextWidget(
                    //                         Strings.privacy,
                    //                         style: Theme.of(context).textTheme
                    //                             .rBodyMedium(context)!.copyWith(fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                    //                         // style: kohinoorSemiBold.copyWith(
                    //                         //   fontSize: 16.sp,
                    //                         //   fontWeight: FontWeight.w600,
                    //                         //   color: AppColors.highlightedTextColor,
                    //                         //   decoration: TextDecoration.underline,
                    //                         // ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               // SizedBox(height: 12.h),
                    //               SizedBox(height: r.px(12)),
                    //               AnimatedCrossFade(
                    //                 duration: const Duration(milliseconds: 200),
                    //                 crossFadeState: onOtpStep
                    //                     ? CrossFadeState.showSecond
                    //                     : CrossFadeState.showFirst,
                    //                 firstChild: const SizedBox.shrink(),
                    //                 secondChild: Column(
                    //                   children: [
                    //                     SizedBox(
                    //                       // height: 56.h,
                    //                       height: r.px(56),
                    //                       child: Row(
                    //                         key: const Key('otpRow'),
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.spaceBetween,
                    //                         children: List.generate(6, (index) {
                    //                           return OtpBox(
                    //                             controller: _otpCtrls[index],
                    //                             focusNode: _otpNodes[index],
                    //                             nextFocus: index < 5
                    //                                 ? _otpNodes[index + 1]
                    //                                 : null,
                    //                             prevFocus: index > 0
                    //                                 ? _otpNodes[index - 1]
                    //                                 : null,
                    //                             onChanged: (_) => _notifyOtpChanged(),
                    //                           );
                    //                         }),
                    //                       ),
                    //                     ),
                    //                     // SizedBox(height: 12.h),
                    //                     SizedBox(height: r.px(12)),
                    //                   ],
                    //                 ),
                    //               ),
                    //               if (!(onOtpStep && kbOpen))
                    //                 const Spacer()
                    //               else
                    //                 // SizedBox(height: 25.h),
                    //                 SizedBox(height: r.px(25)),
                    //               BlocBuilder<
                    //                 OtpVerificationBloc,
                    //                 OtpVerificationState
                    //               >(
                    //                 builder: (context, otpState) {
                    //                   final onOtpStep =
                    //                       state.step == LoginFlowStep.verifyOtp;
                    //                   final isBtnEnabled = onOtpStep
                    //                       ? otpState.isOtpValid
                    //                       : state.isMobileNoValid;
                    //
                    //                   return CustomButton(
                    //                     key: const Key('primaryBtn'),
                    //                     buttonText: onOtpStep
                    //                         ? Strings.verify
                    //                         : Strings.sendOtp,
                    //                     isValid: isBtnEnabled,
                    //                     onClick: () {
                    //                       FocusScope.of(context).unfocus();
                    //                       if (onOtpStep) {
                    //                         // optional: verify here using entered OTP vs actual
                    //                         context.read<OtpVerificationBloc>().add(
                    //                           VerifyButtonClicked(
                    //                             enteredOtp: otpState.enteredOtp,
                    //                             actualOtp: state.receivedOTP,
                    //                           ),
                    //                         );
                    //                       } else {
                    //                         _loginBloc.add(SendOTP());
                    //                       }
                    //                     },
                    //                     isLoading: state.isLoginLoading,
                    //                   );
                    //                 },
                    //               ),
                    //               // SizedBox(height: 20.h),
                    //               SizedBox(height: r.px(20)),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _notifyOtpChanged() {
    final otp = _otpCtrls.map((c) => c.text).join();
    context.read<OtpVerificationBloc>().add(OTPEntered(enteredOtp: otp));
  }
}
