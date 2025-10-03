part of 'otp_verification_bloc.dart';

class OtpVerificationState extends Equatable {
  final bool isOtpValid;
  final String enteredOtp;
  final bool otpMatched;
  final int? duration;
  final String actualOtp;
  final bool? resendOtpLoading;
  final bool? resendOtpSuccess;

  const OtpVerificationState({
    this.isOtpValid = false,
    this.enteredOtp = '',
    this.otpMatched = false,
    this.duration,
    this.actualOtp = '',
    this.resendOtpLoading,
    this.resendOtpSuccess,
  });

  @override
  List<Object> get props => [
    isOtpValid,
    enteredOtp,
    otpMatched,
    duration ?? 0,
    actualOtp,
    resendOtpLoading ?? false,
    resendOtpSuccess ?? false,
  ];
}

class OtpVerificationInitial extends OtpVerificationState {
  const OtpVerificationInitial({super.resendOtpLoading, super.resendOtpSuccess});
}

class OtpResendSuccess extends OtpVerificationState {
  const OtpResendSuccess({
    super.isOtpValid,
    super.enteredOtp,
    super.otpMatched,
    super.duration,
    super.actualOtp,
    super.resendOtpLoading,
    super.resendOtpSuccess,
  });
}

class OtpVerificationSuccessful extends OtpVerificationState {
  const OtpVerificationSuccessful({required super.otpMatched});
}

class OtpVerificationFailed extends OtpVerificationState {
  const OtpVerificationFailed(
      {super.isOtpValid,
        super.enteredOtp,
        super.otpMatched,
        super.duration,
        super.resendOtpLoading,
        super.resendOtpSuccess,
        super.actualOtp});

  @override
  List<Object> get props => [
    isOtpValid,
    enteredOtp,
    otpMatched,
    duration,
    resendOtpLoading ?? false,
    resendOtpSuccess ?? true,
  ];
}

class GetOTPFailure extends OtpVerificationState {
  final String error;

  const GetOTPFailure({
    required this.error,
  });
}
