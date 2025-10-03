part of 'common_bloc.dart';

@immutable
class CommonState extends Equatable {
  final String? error;
  const CommonState({this.error});

  CommonState copyWith({String? error}) {
    return CommonState(error: error ?? this.error);
  }

  @override
  List<Object?> get props => [];
}

final class CommonInitial extends CommonState {}

final class CommonLoading extends CommonState {}

final class MobileCodeLoading extends CommonState {}

final class MobileCodeFetched extends CommonState {
  final List<CountryMobileCodesList> mobileCodes;
  const MobileCodeFetched({required this.mobileCodes});
}

final class MobileCodeFailure extends CommonState {
  const MobileCodeFailure({required super.error});
}
