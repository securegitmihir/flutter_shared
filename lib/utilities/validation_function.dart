import 'package:assisted_living/app/configuration/validation_mssg.dart';

import '../app/configuration/constants.dart';

class ValidationFunctions {
  static String? isMobileNumberValid(String? mobileNumber, int allowedLength) {
    if (mobileNumber == null || mobileNumber.isEmpty) {
      return MobileNumberValidationMsg.cantBeEmpty;
    }
    int? number = int.tryParse(mobileNumber);
    if (number == null) return MobileNumberValidationMsg.invalidType;
    if (mobileNumber.length != allowedLength) {
      return '${MobileNumberValidationMsg.invalidLength} $allowedLength digits';
    }

    return null;
  }

  static bool isOtpValid(String? enteredOtp) {
    if (enteredOtp == null || enteredOtp.isEmpty) {
      return false;
    }

    int? otp = int.tryParse(enteredOtp);
    if (otp == null) return false;
    if (enteredOtp.toString().length == 6) {
      return true;
    }
    return false;
  }

  static String? isUserNameValid(String? userName) {
    if (userName == null || userName.isEmpty) {
      return UserNameValidationMsg.cantBeEmpty;
    }

    var nameParts = userName.split(' ');
    if (nameParts.length < 2) {
      return UserNameValidationMsg.mustIncludeFirstAndLastName;
    }

    if (!RegExp(r'^[A-Za-z\\s]+$').hasMatch(userName.replaceAll(' ', ''))) {
      return UserNameValidationMsg.invalidUserName;
    }

    return null;
  }

  static String? isEmailValid(String email) {
    final RegExp regex = RegExp(Constants.regExpEmailAddress);

    if (email.isEmpty) {
      return EmailAddressValidationMsg.cantBeEmpty;
    } else if (!regex.hasMatch(email)) {
      return EmailAddressValidationMsg.validEmailAddress;
    }

    return null;
  }

  static String? isGenderValid(String gender) {
    if (gender.isEmpty) {
      return GenderValidationMsg.cantBeEmpty;
    }

    return null;
  }

  static String? isBirthYearValid(String birthYear) {
    if (birthYear.isEmpty) {
      return BirthYearValidationMsg.cantBeEmpty;
    }

    return null;
  }
}
