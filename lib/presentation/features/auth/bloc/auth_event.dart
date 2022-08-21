part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class PickUserImageEvent extends AuthEvent {}

class ChangeIconSuffixEvent extends AuthEvent {
  final bool isShow;

  ChangeIconSuffixEvent({required this.isShow});
}
