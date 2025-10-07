import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../services/validation_function.dart';

part 'add_member_event.dart';
part 'add_member_state.dart';

class AddMemberBloc
    extends HydratedBloc<AddMemberEvent, AddMemberState> {
  AddMemberBloc() : super(const AddMemberState()) {
    on<FullNameChanged>(_onFullNameChanged);
    on<RelationChanged>(_onRelationChanged);
    on<OtherRelationChanged>(_onOtherRelationChanged);
    on<ValidateStep>(_onValidateStep);
    on<ResetValidation>(_onResetValidation);
  }

  @override
  AddMemberState? fromJson(Map<String, dynamic> json) {
    try {
      return AddMemberState(
        fullName: json['fullName'] ?? '',
        relation: json['relation'] ?? '',
        otherRelation: json['otherRelation'] ?? '',
        isStepValid: json['isStepValid'] ?? false,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AddMemberState state) {
    return {
      'fullName': state.fullName,
      'relation': state.relation,
      'otherRelation': state.otherRelation,
      'isStepValid': state.isStepValid,
    };
  }

  void _onFullNameChanged(
      FullNameChanged event,
      Emitter<AddMemberState> emit,
      ) {
    final error = ValidationFunctions.isUserNameValid(event.fullName.trim());

    // final isStepValid = _validateStep(
    //   fullName: event.fullName,
    //   relation: state.relation,
    // );

    emit(
      state.copyWith(
        fullName: event.fullName,
        fullNameError: error,
        isStepValid: _validateStep(fullName: event.fullName),
      ),
    );
  }

  void _onRelationChanged(
      RelationChanged e,
      Emitter<AddMemberState> emit,
      ) {
    // Optional: clear otherRelation when moving away from "Others".
    final nextOther = (e.relation == 'Others') ? state.otherRelation : '';

    emit(
      state.copyWith(
        relation: (e.relation?.isEmpty ?? true) ? null : e.relation,
        otherRelation: nextOther,
        // relation is optional, so validity still depends only on fullName
        isStepValid: _validateStep(fullName: state.fullName),
      ),
    );
  }

  void _onOtherRelationChanged(OtherRelationChanged e, Emitter<AddMemberState> emit) {
    emit(
      state.copyWith(
        otherRelation: e.otherRelation,
        // No impact on validity (optional)
        isStepValid: _validateStep(fullName: state.fullName),
      ),
    );
  }

  bool _validateStep({
    required String fullName,
    String? relation,
  }) {
    final nameErr = ValidationFunctions.isUserNameValid(fullName.trim());
    final requiredFilled = fullName.trim().isNotEmpty;
    final noErrors = nameErr == null;
    return requiredFilled && noErrors;
  }

  FutureOr<void> _onValidateStep(
      ValidateStep event,
      Emitter<AddMemberState> emit,
      ) {
    final isStepValid = _validateStep(
      fullName: state.fullName,
    );

    emit(state.copyWith(isStepValid: isStepValid));
  }

  FutureOr<void> _onResetValidation(
      ResetValidation event,
      Emitter<AddMemberState> emit,
      ) {
    emit(state.copyWith(isStepValid: false));
  }
}