part of 'user_bloc.dart';

class UserState extends Equatable {
  final Data<UserModel>? user;
  final RequestState? requestState;
  final String? message;

  const UserState({
    this.user,
    this.requestState,
    this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [user, requestState, message];

  UserState copyWith({
    Data<UserModel>? user,
    RequestState? requestState,
    String? message,
  }) {
    return UserState(
      requestState: requestState ?? this.requestState,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}
