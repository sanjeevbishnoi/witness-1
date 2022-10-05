part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final Data<UserModel>? user;
  final RequestState? registerState;
  final RequestState? loginState;
  final String? message;
  final File? file;
  final bool isPassword;
  final IconData? icon;
  final LoginModel? login;

  const AuthState({
    this.user,
    this.registerState,
    this.loginState,
    this.message,
    this.file,
    this.isPassword = true,
    this.icon,
    this.login,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        user,
        registerState,
        message,
        file,
    isPassword,
        icon,
        login,
    loginState,
      ];

  AuthState copyWith({
    Data<UserModel>? user,
    RequestState? registerState,
    RequestState? loginState,
    String? message,
    File? file,
    bool? isPassword,
    IconData? icon,
    LoginModel? login,
  }) {
    return AuthState(
      registerState: registerState ?? this.registerState,
      loginState: loginState ?? this.loginState,
      message: message ?? this.message,
      user: user ?? this.user,
      file: file ?? this.file,
      isPassword: isPassword ?? this.isPassword,
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
