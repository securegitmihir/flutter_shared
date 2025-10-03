import 'dart:async';

import 'package:assisted_living/data/models/login_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../data/models/country_code_model.dart';
import '../../data/repository/otp_verification_repo.dart';
import '../../data/repository/var_customer_repo.dart';
import '../../services/enum.dart';
import '../../services/strings.dart';
import '../../services/utility_functions.dart';
import '../../services/validation_function.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  OTPVerificationRepository otpVerificationRepository;
  VarCustomerRepository varCustomerRepository;

  LoginBloc(this.otpVerificationRepository, this.varCustomerRepository)
    : super(const LoginState()) {
    on<SetDefaultValue>(_onSetDefaultValue);
    on<CountryCodeSelected>(_onCountryCodeSelected);
    on<VerifyMobileNumber>(_verifyMobileNumber);
    on<SendOTP>(_onSendOTP);
    on<OtpVerified>(_onOtpVerified);
    on<BackToEditPhone>(_backToEditPhone);
  }

  void _onSetDefaultValue(SetDefaultValue event, Emitter<LoginState> emit) {
    final state = this.state;
    final selectedCode = UtilityFunctions.getCountryCodeList(
      event.mobileCodes,
    )[0];
    emit(
      state.copyWith(
        selectedCountryCodeId: UtilityFunctions.getCountryCodeKeyFromValue(
          event.mobileCodes,
          selectedCode,
        ),
        selectedCountryCode: selectedCode,
        isMobileNoValid: state.isMobileNoValid,
        loginResponseModel: state.loginResponseModel,
        mobileErrorMsg: state.mobileErrorMsg,
        enteredMobileNo: state.enteredMobileNo,
      ),
    );
  }

  void _verifyMobileNumber(VerifyMobileNumber event, Emitter<LoginState> emit) {
    final state = this.state;
    int? allowedLength = UtilityFunctions.getMobileAllowedLengthFromCountryCode(
      event.mobileCodes,
      state.selectedCountryCode,
    );
    String? errorMessage = ValidationFunctions.isMobileNumberValid(
      event.mobileNumber,
      allowedLength!,
    );

    emit(
      state.copyWith(
        allowedLength: allowedLength,
        enteredMobileNo: event.mobileNumber,
        isMobileNoValid: errorMessage == null,
        mobileErrorMsg: errorMessage,
      ),
    );
  }

  void _onCountryCodeSelected(
    CountryCodeSelected event,
    Emitter<LoginState> emit,
  ) {
    final state = this.state;
    emit(
      state.copyWith(
        selectedCountryCodeId: event.selectedCountryCodeId,
        selectedCountryCode: event.selectedCountryCode,
      ),
    );
    add(
      VerifyMobileNumber(
        mobileNumber: state.enteredMobileNo,
        mobileCodes: event.mobileCodes,
      ),
    );
  }

  void _onSendOTP(SendOTP event, Emitter<LoginState> emit) async {
    // final state = this.state;
    // final String enteredMobileNo = state.forgotMobileNumber.toString();
    // final data = {'loginid': enteredMobileNo};
    // emit(state.copyWith(enteredMobileNo: enteredMobileNo, otpSendStatus: ApiStatus.loading));

    final enteredMobileNo =
        state.enteredMobileNo ?? '';
    if (enteredMobileNo.isEmpty) {
      emit(
        state.copyWith(
          otpSendStatus: ApiStatus.failure,
          loginErrorMsg: Strings.mobileNumberNotFilled,
        ),
      );
      return;
    }

    emit(state.copyWith(otpSendStatus: ApiStatus.loading));
    try {
      final data = {'loginid': enteredMobileNo};
      // final value = await varCustomerRepository.validateCustomerMobile(data);
      await varCustomerRepository.validateCustomerMobile(data).then((
        value,
      ) async {
        if (value.isValid!) {
          final otp = await otpVerificationRepository.getOTP(
            int.tryParse(enteredMobileNo),
          );
          if (otp == null || otp.toString().isEmpty) {
            emit(
              state.copyWith(
                // isForgotMobileValid: false,
                // forgotMobileError: Strings.somethingWentWrongExceptionMsg,
                // forgotMobileNumber: enteredMobileNo,
                otpSendStatus: ApiStatus.failure,
                loginErrorMsg: Strings.somethingWentWrongExceptionMsg,
              ),
            );
          } else {
            emit(
              state.copyWith(
                otpSendStatus: ApiStatus.success,
                receivedOTP: otp,
                loginResponseModel: LoginResponseModel(
                  verified: true,
                  isNewUser: true,
                ),
                forgotMobileNumber: enteredMobileNo,
                step: LoginFlowStep.verifyOtp,
              ),
            );
            emit(
              OtpSuccess(
                otpSendStatus: ApiStatus.success,
                receivedOTP: otp,
                loginResponseModel: LoginResponseModel(
                  verified: true,
                  isNewUser: true,
                ),
                forgotMobileNumber: enteredMobileNo,
                selectedCountryCode: state.selectedCountryCode,
                selectedCountryCodeId: state.selectedCountryCodeId,
                step: LoginFlowStep.verifyOtp,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              // isForgotMobileValid: false,
              // forgotMobileError: Strings.mobileNumberNotRegistered,
              // forgotMobileNumber: enteredMobileNo,
              otpSendStatus: ApiStatus.failure,
              loginErrorMsg: Strings.mobileNumberNotRegistered,
            ),
          );
        }
      });
    } catch (e) {
      emit(
        state.copyWith(
          // isForgotMobileValid: false,
          // forgotMobileError: Strings.somethingWentWrongExceptionMsg,
          // forgotMobileNumber: enteredMobileNo,
          otpSendStatus: ApiStatus.failure,
          loginErrorMsg: Strings.somethingWentWrongExceptionMsg,
        ),
      );
    }
  }

  void _onOtpVerified(OtpVerified event, Emitter<LoginState> emit) {
    final state = this.state;
    emit(state.copyWith(otpSendStatus: ApiStatus.idle));
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    return LoginState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    return state.toJson();
  }

  FutureOr<void> _backToEditPhone(
    BackToEditPhone event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        step: LoginFlowStep.enterMobile,
        enteredMobileNo: '',
        isMobileNoValid: false,
        mobileErrorMsg: null,
        otpSendStatus: ApiStatus.idle,
        receivedOTP: '',
      ),
    );
  }
}
