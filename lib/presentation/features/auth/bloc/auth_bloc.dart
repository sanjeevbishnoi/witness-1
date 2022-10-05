import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_shot/core/strings/messages.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/data/model/api/User_model.dart';
import 'package:nice_shot/data/model/api/data_model.dart';
import 'package:nice_shot/data/repositories/user_repository.dart';

import '../../../../data/model/api/login_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  var picker = ImagePicker();
  final UserRepository userRepository;
  bool isPassword = false;

  AuthBloc({required this.userRepository}) : super(const AuthState()) {
    on<AuthEvent>((event, emit) async {
      if (event is PickUserImageEvent) {
        await pickImage().then((value) {
          emit(state.copyWith(
            file: value!,
            loginState: RequestState.none,
            registerState: RequestState.none,
          ));
        });
      } else if (event is ChangeIconSuffixEvent) {
        isPassword = !event.isPassword;
        emit(state.copyWith(
          loginState: RequestState.none,
          registerState: RequestState.none,
          icon: event.isPassword
              ? Icons.visibility_sharp
              : Icons.visibility_off,
          isPassword: event.isPassword,
        ));

      } else if (event is CreateAccountEvent) {
        emit(state.copyWith(registerState: RequestState.loading));
        var result = await userRepository.createUser(userModel: event.user);
        result.fold(
          (l) => emit(state.copyWith(
              registerState: RequestState.error, message: "${l.runtimeType}")),
          (r) => emit(state.copyWith(
            registerState: RequestState.loaded,
            user: Data<UserModel>.fromJson(r.data),
            message: r.data['message'] ?? REGISTER_SUCCESS_MESSAGE,
          )),
        );
      } else if (event is LoginEvent) {
        emit(state.copyWith(loginState: RequestState.loading));
        var result = await userRepository.login(
          email: event.email,
          password: event.password,
        );
        result.fold(
          (l) => emit(state.copyWith(loginState: RequestState.error)),
          (r) {
            emit(
              state.copyWith(
                loginState: RequestState.loaded,
                login: LoginModel.fromJson(r.data),
                message: r.data['error'] ?? LOGIN_SUCCESS_MESSAGE,
              ),
            );
          },
        );
      }
    });
  }

  Future<File?> pickImage() async {
    final file = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      return File(file.path);
    }
    return null;
  }
}
