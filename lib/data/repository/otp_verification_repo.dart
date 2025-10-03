import '../data_provider/otp_verification_dp.dart';

class OTPVerificationRepository {
  final OTPVerificationDataProvider otpVerificationDataProvider;

  OTPVerificationRepository(this.otpVerificationDataProvider);

  Future<dynamic> getOTP(int? loginId) async {
    try {
      // final getOTP = await otpVerificationDataProvider.getOTP(loginId);
      // return getOTP;
      return "123456";
    } catch (e) {
      rethrow;
    }
  }
}
