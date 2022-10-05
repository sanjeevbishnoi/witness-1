import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/camera/widgets/zoom_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/actions_widget.dart';
import 'package:nice_shot/presentation/features/camera/bloc/bloc.dart';

import 'widgets/resolutions_widget.dart';

class CameraPage extends StatelessWidget with WidgetsBindingObserver {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CameraBloc cameraBloc = context.read<CameraBloc>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
              if (cameraBloc.controller != null) {
                return CameraPreview(cameraBloc.controller!);
              } else {
                return const LoadingWidget();
              }
            }),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<CameraBloc, CameraState>(
                    builder: (context, state) {
                      return state is InitCameraState ||
                              state is StopRecordingState
                          ? IconButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.homePage,
                                  (route) => false,
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            )
                          : Container();
                    },
                  ),

                  BlocBuilder<CameraBloc, CameraState>(
                    builder: (context, state) {
                      return state is InitCameraState ||
                              state is StopRecordingState
                          ? ResolutionsWidget(cameraBloc: cameraBloc)
                          : Container();
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: BlocBuilder<CameraBloc, CameraState>(
                  builder: (context, state) {
                    return state is StartTimerState
                        ? Text(
                            '${cameraBloc.minutes}:${cameraBloc.second}',
                            style: const TextStyle(color: Colors.white),
                          )
                        : Container();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(MySizes.widgetSideSpace),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<CameraBloc, CameraState>(
                      builder: (context, state) {
                        return ZoomWidget(cameraBloc: cameraBloc);
                      },
                    ),
                    BlocBuilder<CameraBloc, CameraState>(
                      builder: (context, state) {
                        return ActionsWidget(cameraBloc: cameraBloc);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("resume");
        break;
      case AppLifecycleState.inactive:
        debugPrint("inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("detached");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
