import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/model/api/login_model.dart';
import '../../data/model/duration.g.dart';
import '../../data/model/flag_model.dart';
import '../../data/network/local/cache_helper.dart';
import '../../presentation/widgets/alert_dialog_widget.dart';
import '../error/failure.dart';

import '../../data/model/video_model.dart';
import '../routes/routes.dart';
import '../strings/failures.dart';
import '../util/global_variables.dart';

String strDigits(int n) => n.toString().padLeft(2, '0');

Future<Directory> getPath() async {
  var path = await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DCIM,
  );
  Directory directory = Directory("$path/witness/records");
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  return directory;
}

void registerAdapters() {
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(VideoModelAdapter());
  Hive.registerAdapter(FlagModelAdapter());
}

Future openBoxes() async {
  await Hive.openBox<VideoModel>('video_db');
  await Hive.openBox<VideoModel>('exported_video_db');
}

String mapFailureToMessage({required Failure failure}) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case EmptyCacheFailure:
      return EMPTY_CACHE_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    default:
      return DEFAULT_FAILURE_MESSAGE;
  }
}

void setToken({required String token}) {
  myToken = "Bearer $token";
}

void setUserId({required String id}) {
  myId = id;
}

void setUser({required LoginModel user}) {
  currentUserData = user;
}
