part of 'initial_profile_setup_bloc.dart';

class InitialProfileSetupState extends Equatable {
  final String fullName;
  final String? fullNameError;

  final String birthYear;
  final String? birthYearError;

  final String gender;
  final String? genderError;

  final String email;
  final String? emailError;

  final bool isStepValid;

  const InitialProfileSetupState({
    this.fullName = '',
    this.fullNameError,
    this.birthYear = '',
    this.birthYearError,
    this.gender = '',
    this.genderError,
    this.email = '',
    this.emailError,
    this.isStepValid = false,
  });

  InitialProfileSetupState copyWith({
    String? fullName,
    String? fullNameError,
    String? birthYear,
    String? birthYearError,
    String? gender,
    String? genderError,
    String? email,
    String? emailError,
    bool? isStepValid,
  }) {
    return InitialProfileSetupState(
      fullName: fullName ?? this.fullName,
      fullNameError: fullNameError,
      birthYear: birthYear ?? this.birthYear,
      birthYearError: birthYearError,
      gender: gender ?? this.gender,
      genderError: genderError,
      email: email ?? this.email,
      emailError: emailError,
      isStepValid: isStepValid ?? this.isStepValid,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    fullNameError,
    birthYear,
    birthYearError,
    gender,
    genderError,
    email,
    emailError,
    isStepValid,
  ];
}
