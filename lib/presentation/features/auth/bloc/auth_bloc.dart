import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  var picker = ImagePicker();

  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is PickUserImageEvent) {
        await pickImage().then((value) {
          emit(PickUserImageState(file: value!));
        });
      } else if (event is ChangeIconSuffixEvent) {
        emit(ChangeVisibilityPasswordState(
          icon: event.isShow ? Icons.visibility_sharp : Icons.visibility_off,
          isShow: event.isShow,
        ));
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
