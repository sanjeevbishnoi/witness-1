import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nice_shot/data/model/duration.g.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import '../../data/network/local/cache_helper.dart';
import '../../presentation/widgets/alert_dialog_widget.dart';
import '../error/failure.dart';

import '../../data/model/video_model.dart';
import '../routes/routes.dart';
import '../strings/failures.dart';

String strDigits(int n) => n.toString().padLeft(2, '0');

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
void logOut({required BuildContext context}){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogWidget(
        title: "Logout",
        function: (){
          CacheHelper.clearData(key: "user").then((value) {
            Navigator.pushNamed(context, Routes.loginPage);
          });
        },
        message: "Are you sure logout from application?",
      );
    },
  );
}
