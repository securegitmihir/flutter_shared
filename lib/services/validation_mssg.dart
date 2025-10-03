class MobileNumberValidationMsg {
  static const String invalidType = "Invalid number";
  static const String cantBeEmpty = "Mobile number can't be empty";
  static const String invalidLength = "Mobile number must be of";
}

class MobileCodeValidationMessage {
  static const String notDefinedException = ': No country codes defined';
}

class UserNameValidationMsg {
  static const String invalidUserName = "Invalid user name";
  static const String cantBeEmpty = "User name can't be empty";
  static const String mustIncludeFirstAndLastName = 'Username must include both first name and last name.';
}

class EmailAddressValidationMsg {
  static const String cantBeEmpty = "Please enter the email address.";
  static const String validEmailAddress = "Please enter a valid email address.";
}

class GenderValidationMsg {
  static const String cantBeEmpty = "Please select gender.";
}

class BirthYearValidationMsg {
  static const String cantBeEmpty = "Please select birth year.";
}