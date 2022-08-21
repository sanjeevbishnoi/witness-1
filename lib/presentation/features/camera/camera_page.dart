import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/camera/widgets/resolutions_widget.dart';
import 'package:nice_shot/presentation/features/camera/widgets/zoom_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import '../../../core/routes/routes.dart';
import 'widgets/actions_widget.dart';
import 'package:nice_shot/presentation/features/camera/bloc/bloc.dart';

// ignore: must_be_immutable
class CameraPage extends StatelessWidget with WidgetsBindingObserver {
  int countFlags = 0;
  bool isOpen = false;

  CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        /* appBar: AppBar(
          title: const Text("Nice shot"),
          leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.videosPage),
            icon: const Icon(Icons.settings),
          ),
          actions: [
            BlocConsumer<CameraBloc, CameraState>(
              listener: (context, state) {
                if (state is FlashErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBarWidget(message: state.error),
                  );
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    isOpen = !isOpen;
                    context.read<CameraBloc>().add(
                      OpenFlashEvent(isOpen: isOpen),
                    );
                  },
                  icon: Icon(isOpen ? Icons.flash_off : Icons.flash_on),
                );
              },
            ),
          ],
        ),*/
        body: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, state) {
            if (state is StartRecordingState) {}
          },
          builder: (context, state) {
            CameraBloc bloc = BlocProvider.of(context, listen: true);
            if (bloc.controller != null) {
              double aspectRatio = MediaQuery.of(context).size.aspectRatio;
              double cameraAspectRatio = bloc.controller!.value.aspectRatio;
              double scale = 1.1 / (aspectRatio * cameraAspectRatio);
              return Stack(
                children: [
                  Transform.scale(
                    scale: scale,
                    child: CameraPreview(bloc.controller!),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.videosPage);
                          },
                          icon: const Icon(Icons.settings, color: Colors.white),
                        ),
                        if (bloc.states == States.isInit)
                          ResolutionsWidget(cameraBloc: bloc),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        '${bloc.minutes}:${bloc.seconds}',
                        style: const TextStyle(color: Colors.white),
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
                          ZoomWidget(cameraBloc: bloc),
                          ActionsWidget(cameraBloc: bloc),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
