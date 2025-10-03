import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isLoggedIn;
  const AuthState({required this.isLoggedIn});
  AuthState copyWith({bool? isLoggedIn}) => AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      AuthState(isLoggedIn: json['isLoggedIn'] as bool? ?? false);
  Map<String, dynamic> toJson() => {'isLoggedIn': isLoggedIn};

  @override
  List<Object?> get props => [isLoggedIn];
}

class AuthInitial extends AuthState {
  const AuthInitial({required super.isLoggedIn});
}