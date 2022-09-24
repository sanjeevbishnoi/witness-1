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

  AuthBloc({required this.userRepository}) : super(const AuthState()) {
    on<AuthEvent>((event, emit) async {
      if (event is PickUserImageEvent) {
        await pickImage().then((value) {
          emit(state.copyWith(file: value!));
          // emit(PickUserImageState(file: value!));
        });
      } else if (event is ChangeIconSuffixEvent) {
        emit(state.copyWith(
          icon: event.showPassword
              ? Icons.visibility_sharp
              : Icons.visibility_off,
          showPassword: event.showPassword,
        ));
        // emit(ChangeVisibilityPasswordState(
        //   icon: event.isShow ? Icons.visibility_sharp : Icons.visibility_off,
        //   isShow: event.isShow,
        // ));
      } else if (event is CreateAccountEvent) {
        emit(state.copyWith(requestState: RequestState.loading));
        var result = await userRepository.createUser(userModel: event.user);
        result.fold(
          (l) => emit(state.copyWith(
              requestState: RequestState.error, message: "${l.runtimeType}")),
          (r) => emit(state.copyWith(
            requestState: RequestState.loaded,
            user: r,
            message: REGISTER_SUCCESS_MESSAGE,
          )),
        );
      } else if (event is LoginEvent) {
        emit(state.copyWith(requestState: RequestState.loading));
        var result = await userRepository.login(
          email: event.email,
          password: event.password,
        );
        result.fold(
          (l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(
            requestState: RequestState.loaded,
            message: LOGIN_SUCCESS_MESSAGE,
            login: r,
          )),
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
