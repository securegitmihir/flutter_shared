part of 'login_bloc.dart';

final class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

final class SetDefaultValue extends LoginEvent {
  const SetDefaultValue({
    required this.mobileCodes,
  });

  final List<CountryMobileCodesList> mobileCodes;
}

final class CountryCodeSelected extends LoginEvent {
  const CountryCodeSelected({
    required this.selectedCountryCodeId,
    required this.mobileCodes,
    required this.selectedCountryCode,
  });

  final int selectedCountryCodeId;
  final String selectedCountryCode;
  final List<CountryMobileCodesList> mobileCodes;
}

final class VerifyMobileNumber extends LoginEvent {
  const VerifyMobileNumber({
    required this.mobileCodes,
    this.mobileNumber,
  });

  final String? mobileNumber;
  final List<CountryMobileCodesList> mobileCodes;
}

// final class VerifyForgotMobileNumber extends LoginEvent {
//   const VerifyForgotMobileNumber({required this.forgotMobileNumber, required this.mobileCodes});
//
//   final String? forgotMobileNumber;
//   final List<CountryMobileCodesList> mobileCodes;
// }

final class SendOTP extends LoginEvent {}

final class OtpVerified extends LoginEvent {}

final class BackToEditPhone extends LoginEvent {}