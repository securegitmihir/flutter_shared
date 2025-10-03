part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.loginErrorMsg = '',
    this.selectedCountryCode,
    this.selectedCountryCodeId,
    this.isMobileNoValid = false,
    this.enteredMobileNo,
    this.mobileErrorMsg,
    this.receivedOTP = '',
    this.isLoginLoading = false,
    this.otpSendStatus = ApiStatus.idle,
    this.isOTPVerified = false,
    this.allowedLength = 10,
    this.forgotAllowedLength = 10,
    this.loginResponseModel,
    this.forgotMobileError = '',
    this.forgotMobileNumber = '',
    this.isForgotMobileValid = false,
    this.step = LoginFlowStep.enterMobile,
  });

  final String? mobileErrorMsg;
  final bool isMobileNoValid;
  final String loginErrorMsg;
  final String? selectedCountryCode;
  final int? selectedCountryCodeId;
  final String? enteredMobileNo;
  final String receivedOTP;
  final bool isLoginLoading;
  final ApiStatus otpSendStatus;
  final bool isOTPVerified;
  final int allowedLength;
  final int forgotAllowedLength;
  final LoginResponseModel? loginResponseModel;
  final String? forgotMobileNumber;
  final bool isForgotMobileValid;
  final String? forgotMobileError;
  final LoginFlowStep step;


  LoginState copyWith({
    String? selectedCountryCode,
    String? mobileErrorMsg,
    bool? isMobileNoValid,
    int? selectedCountryCodeId,
    String? enteredMobileNo,
    String? receivedOTP,
    String? loginErrorMsg,
    bool? isLoginLoading,
    ApiStatus? otpSendStatus,
    bool? isOTPVerified,
    int? allowedLength,
    int? forgotAllowedLength,
    LoginResponseModel? loginResponseModel,
    String? forgotMobileNumber,
    bool? isForgotMobileValid,
    String? forgotMobileError,
    LoginFlowStep? step,
  }) {
    return LoginState(
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
      mobileErrorMsg: mobileErrorMsg ?? this.mobileErrorMsg,
      isMobileNoValid: isMobileNoValid ?? this.isMobileNoValid,
      selectedCountryCodeId: selectedCountryCodeId ?? this.selectedCountryCodeId,
      enteredMobileNo: enteredMobileNo ?? this.enteredMobileNo,
      receivedOTP: receivedOTP ?? this.receivedOTP,
      loginErrorMsg: loginErrorMsg ?? this.loginErrorMsg,
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      otpSendStatus: otpSendStatus ?? this.otpSendStatus,
      isOTPVerified: isOTPVerified ?? this.isOTPVerified,
      allowedLength: allowedLength ?? this.allowedLength,
      forgotAllowedLength: forgotAllowedLength ?? this.forgotAllowedLength,
      loginResponseModel: loginResponseModel ?? this.loginResponseModel,
      forgotMobileNumber: forgotMobileNumber ?? this.forgotMobileNumber,
      isForgotMobileValid: isForgotMobileValid ?? this.isForgotMobileValid,
      forgotMobileError: forgotMobileError ?? this.forgotMobileError,
      step: step ?? this.step,
    );
  }

  static LoginState fromJson(Map<String, dynamic> json) {
    return LoginState(
      loginResponseModel: json['loginModel'] != null ? LoginResponseModel.fromJson(json['loginModel']) : null,
      step: LoginFlowStep.values.firstWhere(
            (e) => e.name == (json['step'] ?? LoginFlowStep.enterMobile.name),
        orElse: () => LoginFlowStep.enterMobile,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginModel': loginResponseModel?.toJson(),
      'step': step.name,
    };
  }

  @override
  List<Object?> get props => [
    selectedCountryCode,
    mobileErrorMsg,
    isMobileNoValid,
    selectedCountryCodeId,
    enteredMobileNo,
    receivedOTP,
    loginErrorMsg,
    isLoginLoading,
    otpSendStatus,
    isOTPVerified,
    allowedLength,
    forgotAllowedLength,
    loginResponseModel,
    forgotMobileNumber,
    isForgotMobileValid,
    forgotMobileError,
    step
  ];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginSuccess extends LoginState {
  const LoginSuccess({
    required super.enteredMobileNo,
    required super.loginResponseModel,
    required super.forgotMobileNumber,
  });
}

class LoginError extends LoginState {
  const LoginError({required super.loginErrorMsg});
}

class OtpSuccess extends LoginState {
  const OtpSuccess({
    required super.forgotMobileNumber,
    required super.receivedOTP,
    required super.otpSendStatus,
    required super.selectedCountryCode,
    required super.selectedCountryCodeId,
    required super.loginResponseModel,
    required super.step,
  });
}
