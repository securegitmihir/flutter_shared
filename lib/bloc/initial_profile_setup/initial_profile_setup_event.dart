part of 'initial_profile_setup_bloc.dart';

abstract class InitialProfileSetupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FullNameChanged extends InitialProfileSetupEvent {
  final String fullName;
  FullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class BirthYearChanged extends InitialProfileSetupEvent {
  final String birthYear;
  BirthYearChanged(this.birthYear);

  @override
  List<Object?> get props => [birthYear];
}

class GenderChanged extends InitialProfileSetupEvent {
  final String gender;
  GenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class EmailChanged extends InitialProfileSetupEvent {
  final String email;
  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class ValidateStep extends InitialProfileSetupEvent {}

class ResetValidation extends InitialProfileSetupEvent {}

