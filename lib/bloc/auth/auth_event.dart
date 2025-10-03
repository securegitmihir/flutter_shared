part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable{
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class IsLoggedIn extends AuthEvent {
  final bool isNewUser;
  const IsLoggedIn(this.isNewUser);

  @override
  List<Object> get props => [isNewUser];
}
