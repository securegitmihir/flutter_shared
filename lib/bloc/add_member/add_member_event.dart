part of 'add_member_bloc.dart';

@immutable
abstract class AddMemberEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FullNameChanged extends AddMemberEvent {
  final String fullName;
  FullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class RelationChanged extends AddMemberEvent {
  final String? relation;
  RelationChanged(this.relation);

  @override
  List<Object?> get props => [relation];
}

class OtherRelationChanged extends AddMemberEvent {
  final String? otherRelation;
  OtherRelationChanged(this.otherRelation);

  @override
  List<Object?> get props => [otherRelation];
}

class ValidateStep extends AddMemberEvent {}

class ResetValidation extends AddMemberEvent {}

