part of 'otp_verification_bloc.dart';

class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyButtonClicked extends OtpVerificationEvent {
  final String? enteredOtp;
  final String actualOtp;

  const VerifyButtonClicked({
    required this.actualOtp,
    required this.enteredOtp,
  });
}

class StartTimer extends OtpVerificationEvent {
  final int time;
  const StartTimer({required this.time});
}

class ResendOTPClicked extends OtpVerificationEvent {
  final int time;
  final String enteredMobileNumber;

  const ResendOTPClicked({
    required this.time,
    required this.enteredMobileNumber,
  });
}

class OTPEntered extends OtpVerificationEvent {
  final String enteredOtp;

  const OTPEntered({required this.enteredOtp});
}

class Tick extends OtpVerificationEvent {
  final int duration;
  const Tick({required this.duration});
}

class SetNewOTPEvent extends OtpVerificationEvent {
  const SetNewOTPEvent({
    required this.otp,
  });

  final String otp;
}

class ResetEvent extends OtpVerificationEvent {
  const ResetEvent();
}

class ClearOTP extends OtpVerificationEvent {
  const ClearOTP();
}
