import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/camera/widgets/resolutions_widget.dart';
import 'package:nice_shot/presentation/features/camera/widgets/zoom_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/actions_widget.dart';
import 'package:nice_shot/presentation/features/camera/bloc/bloc.dart';

// ignore: must_be_immutable
class CameraPage extends StatelessWidget with WidgetsBindingObserver {
  int countFlags = 0;
  bool isOpen = false;

  CameraPage({Key? key}) : super(key: key);

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
                double aspectRatio = MediaQuery
                    .of(context)
                    .size
                    .aspectRatio;
                double cameraAspectRatio =
                    cameraBloc.controller!.value.aspectRatio;
                double scale = 1.1 / (aspectRatio * cameraAspectRatio);
                return Transform.scale(
                  scale: scale,
                  child: CameraPreview(cameraBloc.controller!),
                );
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
                  IconButton(
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
                  ),
                  BlocBuilder<CameraBloc, CameraState>(
                    builder: (context, state) {
                      return ResolutionsWidget(cameraBloc: cameraBloc);
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
                    return Text(
                      '${cameraBloc.minutes}:${cameraBloc.seconds}',
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(MySizes.widgetSidePadding),
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
}
