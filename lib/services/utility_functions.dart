import 'package:flutter/services.dart';

import '../data/models/country_code_model.dart';

class UtilityFunctions {
  static List<String> getCountryCodeList(countryCodeList) {
    List<String> countryCodeStringList = [];

    if (countryCodeList != null) {
      for (CountryMobileCodesList countryCode in countryCodeList) {
        countryCodeStringList.add(
            '${countryCode.shortcode} ${countryCode.countryCode}');
      }
    }
    return countryCodeStringList;
  }

  static int? getCountryCodeKeyFromValue(List<CountryMobileCodesList> countryMobileCodes, String? countryCode) {
    if (countryCode == null) return null;
    for (CountryMobileCodesList countryMobileCode in countryMobileCodes) {
      if ('${countryMobileCode.shortcode} ${countryMobileCode.countryCode}' == countryCode) {
        return countryMobileCode.id;
      }
    }
    return null;
  }

  static int? getMobileAllowedLengthFromCountryCode(
      List<CountryMobileCodesList> countryMobileCodes, String? countryCode) {
    if (countryCode == null) return null;
    for (CountryMobileCodesList countryMobileCode in countryMobileCodes) {
      if ('${countryMobileCode.shortcode} ${countryMobileCode.countryCode}' == countryCode) {
        return countryMobileCode.numberLength;
      }
    }
    return null;
  }

  static closeKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}