part of 'add_member_bloc.dart';

@immutable
class AddMemberState extends Equatable {
  final String fullName;
  final String? fullNameError;

  final String? relation;
  final String? relationError;

  final String? otherRelation;

  final bool isStepValid;

  const AddMemberState({
    this.fullName = '',
    this.fullNameError,
    this.relation = '',
    this.relationError,
    this.otherRelation = '',
    this.isStepValid = false,
  });

  AddMemberState copyWith({
    String? fullName,
    String? fullNameError,
    String? relation,
    String? relationError,
    String? otherRelation,
    bool? isStepValid,
  }) {
    return AddMemberState(
      fullName: fullName ?? this.fullName,
      fullNameError: fullNameError,
      relation: relation ?? this.relation,
      relationError: relationError,
      otherRelation: otherRelation ?? this.otherRelation,
      isStepValid: isStepValid ?? this.isStepValid,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    fullNameError,
    relation,
    relationError,
    otherRelation,
    isStepValid,
  ];
}

