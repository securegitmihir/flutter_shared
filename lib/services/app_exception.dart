import 'package:easy_localization/easy_localization.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message, "exceptions.fetchExceptionMsg".tr());
}

class SomethingWentWrongException extends AppException {
  SomethingWentWrongException([String? message])
    : super(message, "exceptions.somethingWentWrongMsg".tr());
}

class InternalServerException extends AppException {
  InternalServerException([String? message]) : super('', message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
    : super(message, "exceptions.unauthorizedRequestMsg".tr());
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
    : super(message, "exceptions.badRequestMsg".tr());
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
    : super(message, "exceptions.invalidInputMsg".tr());
}