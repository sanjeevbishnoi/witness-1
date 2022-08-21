part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class PickUserImageState extends AuthState {
  final File file;

  PickUserImageState({required this.file});
}

class ChangeVisibilityPasswordState extends AuthState {
  final IconData icon;
  final bool isShow;

  ChangeVisibilityPasswordState({ required this.isShow, required this.icon});
}
