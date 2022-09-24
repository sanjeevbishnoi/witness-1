part of 'user_bloc.dart';

abstract class UserEvent {}

class GetUserDataEvent extends UserEvent {
  final String id;

  GetUserDataEvent({required this.id});
}
