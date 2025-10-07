class AppUrl {
  static var baseUrl = "https://services.secure-al.com:47277";
  static var getOTP = '$baseUrl/api/ALServices/GetOTPData';
  static var validateCustomerMobile = '$baseUrl/api/MobileAppController/ValidateCustomerMobile';
  static var countryCodeApi = '$baseUrl/api/Master/GetCountryCode';
  static var appVersionApi = '$baseUrl/api/ALServices/GetApiVersion';
  static Function getLanguageJson = (language, namespaces) =>
      '$baseUrl/i18n?locale=$language&namespaces=$namespaces';
  static Function getLanguageVersion = (language, namespaces) =>
      '$baseUrl/i18n/version?locale=$language&namespaces=$namespaces';
}