part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final Data<UserModel>? user;
  final RequestState? requestState;
  final String? message;
  final File? file;
  final bool showPassword;
  final IconData? icon;
  final LoginModel? login;

  const AuthState({
    this.user,
    this.requestState,
    this.message,
    this.file,
    this.showPassword = false,
    this.icon,
    this.login,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        user,
        requestState,
        message,
        file,
        showPassword,
        icon,
        login,
      ];

  AuthState copyWith({
    Data<UserModel>? user,
    RequestState? requestState,
    String? message,
    File? file,
    bool? showPassword,
    IconData? icon,
    LoginModel? login,
  }) {
    return AuthState(
      requestState: requestState ?? this.requestState,
      message: message ?? this.message,
      user: user ?? this.user,
      file: file ?? this.file,
      showPassword: showPassword ?? this.showPassword,
      icon: icon ?? this.icon,
      login: login ?? this.login,
    );
  }
}

// abstract class AuthState {
//   const AuthState();
// }
//
// class AuthInitial extends AuthState {}
//
// class PickUserImageState extends AuthState {
//   final File file;
//
//   PickUserImageState({required this.file});
// }
//
// class ChangeVisibilityPasswordState extends AuthState {
//   final IconData icon;
//   final bool isShow;
//
//   ChangeVisibilityPasswordState({ required this.isShow, required this.icon});
// }
