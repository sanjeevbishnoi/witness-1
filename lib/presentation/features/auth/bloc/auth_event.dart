part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class PickUserImageEvent extends AuthEvent {}

class ChangeIconSuffixEvent extends AuthEvent {
  final bool showPassword;

  ChangeIconSuffixEvent({required this.showPassword});
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class CreateAccountEvent extends AuthEvent {
  final UserModel user;

  CreateAccountEvent({required this.user});
}
