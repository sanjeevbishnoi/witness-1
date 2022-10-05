part of 'user_bloc.dart';

abstract class UserEvent {}

class GetUserDataEvent extends UserEvent {}

class UpdateUserDataEvent extends UserEvent {
  final UserModel user;

  UpdateUserDataEvent({required this.user});
}

class ResetPasswordEvent extends UserEvent {
  final String oldPassword;
  final String newPassword;

  ResetPasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}
