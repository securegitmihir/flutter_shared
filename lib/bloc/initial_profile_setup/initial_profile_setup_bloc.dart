import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../services/validation_function.dart';

part 'initial_profile_setup_event.dart';
part 'initial_profile_setup_state.dart';

class InitialProfileSetupBloc
    extends HydratedBloc<InitialProfileSetupEvent, InitialProfileSetupState> {
  InitialProfileSetupBloc() : super(const InitialProfileSetupState()) {
    on<FullNameChanged>(_onFullNameChanged);
    on<BirthYearChanged>(_onBirthYearChanged);
    on<GenderChanged>(_onGenderChanged);
    on<EmailChanged>(_onEmailChanged);
    on<ValidateStep>(_onValidateStep);
    on<ResetValidation>(_onResetValidation);
  }

  @override
  InitialProfileSetupState? fromJson(Map<String, dynamic> json) {
    try {
      return InitialProfileSetupState(
        fullName: json['fullName'] ?? '',
        birthYear: json['birthYear'] ?? '',
        gender: json['gender'] ?? '',
        email: json['email'] ?? '',
        isStepValid: json['isStepValid'] ?? false,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(InitialProfileSetupState state) {
    return {
      'fullName': state.fullName,
      'birthYear': state.birthYear,
      'gender': state.gender,
      'email': state.email,
      'isStepValid': state.isStepValid,
    };
  }

  void _onFullNameChanged(
    FullNameChanged event,
    Emitter<InitialProfileSetupState> emit,
  ) {
    final error = ValidationFunctions.isUserNameValid(event.fullName.trim());

    final isStepValid = _validateStep(
      fullName: event.fullName,
      birthYear: state.birthYear,
      gender: state.gender,
      email: state.email,
    );

    emit(
      state.copyWith(
        fullName: event.fullName,
        fullNameError: error,
        isStepValid: isStepValid,
      ),
    );
  }

  bool _validateStep({
    required String fullName,
    required String birthYear,
    required String gender,
    required String email, // email optional
  }) {
    final nameErr   = ValidationFunctions.isUserNameValid(fullName.trim());
    final yearErr   = ValidationFunctions.isBirthYearValid(birthYear);
    final genderErr = ValidationFunctions.isGenderValid(gender);
    final trimmedEmail = email.trim();
    final emailErr = trimmedEmail.isEmpty
        ? null
        : ValidationFunctions.isEmailValid(trimmedEmail);

    final requiredFilled =
        fullName.trim().isNotEmpty && birthYear.isNotEmpty && gender.isNotEmpty;

    final noErrors =
        nameErr == null &&
            yearErr == null &&
            genderErr == null &&
            (trimmedEmail.isEmpty || emailErr == null);

    return requiredFilled && noErrors;
  }

  // bool _validateStep({
  //   required String fullName,
  //   required String birthYear,
  //   required String gender,
  //   required String email,
  // }) {
  //   return fullName.isNotEmpty &&
  //       birthYear.isNotEmpty &&
  //       gender.isNotEmpty &&
  //       email.isNotEmpty;
  // }

  void _onBirthYearChanged(
    BirthYearChanged event,
    Emitter<InitialProfileSetupState> emit,
  ) {
    final error = ValidationFunctions.isBirthYearValid(event.birthYear);
    final isStepValid = _validateStep(
      fullName: state.fullName,
      birthYear: event.birthYear,
      gender: state.gender,
      email: state.email,
    );
    emit(
      state.copyWith(
        birthYear: event.birthYear,
        birthYearError: error,
        isStepValid: isStepValid,
      ),
    );
  }

  void _onGenderChanged(
    GenderChanged event,
    Emitter<InitialProfileSetupState> emit,
  ) {
    final error = ValidationFunctions.isGenderValid(event.gender);
    final isStepValid = _validateStep(
      fullName: state.fullName,
      birthYear: state.birthYear,
      gender: event.gender,
      email: state.email,
    );
    emit(
      state.copyWith(
        gender: event.gender,
        genderError: error,
        isStepValid: isStepValid,
      ),
    );
  }

  void _onEmailChanged(
      EmailChanged event,
      Emitter<InitialProfileSetupState> emit,
      ) {
    final trimmed = event.email.trim();

    // No error when empty. Validate only if user typed something.
    final error = trimmed.isEmpty ? null : ValidationFunctions.isEmailValid(trimmed);

    final isStepValid = _validateStep(
      fullName: state.fullName,
      birthYear: state.birthYear,
      gender: state.gender,
      email: trimmed,
    );

    emit(
      state.copyWith(
        email: trimmed,
        emailError: error,
        isStepValid: isStepValid,
      ),
    );
  }

  // void _onEmailChanged(
  //   EmailChanged event,
  //   Emitter<InitialProfileSetupState> emit,
  // ) {
  //   final error = ValidationFunctions.isEmailValid(event.email);
  //   final isStepValid = _validateStep(
  //     fullName: state.fullName,
  //     birthYear: state.birthYear,
  //     gender: state.gender,
  //     email: event.email,
  //   );
  //   emit(
  //     state.copyWith(
  //       email: event.email,
  //       emailError: error,
  //       isStepValid: isStepValid,
  //     ),
  //   );
  // }

  FutureOr<void> _onValidateStep(
    ValidateStep event,
    Emitter<InitialProfileSetupState> emit,
  ) {
    final isStepValid = _validateStep(
      fullName: state.fullName,
      birthYear: state.birthYear,
      gender: state.gender,
      email: state.email,
    );

    emit(state.copyWith(isStepValid: isStepValid));
  }

  FutureOr<void> _onResetValidation(
    ResetValidation event,
    Emitter<InitialProfileSetupState> emit,
  ) {
    emit(state.copyWith(isStepValid: false));
  }
}
