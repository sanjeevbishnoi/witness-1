part of 'user_bloc.dart';

class UserState extends Equatable {
  final Data<UserModel>? user;
  final RequestState? requestState;
  final RequestState? updateDataState;
  final RequestState? resetPasswordState;
  final String? message;

  const UserState({
    this.updateDataState,
    this.resetPasswordState,
    this.user,
    this.requestState,
    this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        user,
        requestState,
        message,
        updateDataState,
        resetPasswordState,
      ];

  UserState copyWith({
    Data<UserModel>? user,
    RequestState? requestState,
    RequestState? updateDataState,
    RequestState? resetPasswordState,
    String? message,
  }) {
    return UserState(
      requestState: requestState ?? this.requestState,
      message: message ?? this.message,
      user: user ?? this.user,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      updateDataState: updateDataState ?? this.updateDataState,
    );
  }
}
