import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/camera/widgets/zoom_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:nice_shot/presentation/features/camera/bloc/bloc.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../core/routes/routes.dart';
import '../../../widgets/flag_count_widget.dart';
import '../widgets/actions_widget.dart';
import '../widgets/resolutions_widget.dart';

class CameraPage extends StatelessWidget with WidgetsBindingObserver {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CameraBloc c = BlocProvider.of<CameraBloc>(context, listen: true);
    CameraBloc cameraBloc = BlocProvider.of<CameraBloc>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: c.controller != null
            ? Stack(
                children: [
                  BlocBuilder<CameraBloc, CameraState>(
                      builder: (context, state) {
                    return GestureDetector(
                      onTapUp: (details) {
                        if (cameraBloc.controller!.value.isRecordingVideo) {
                          cameraBloc.add(FocusEvent(
                            details: details,
                            context: context,
                          ));
                        }
                      },
                      child: Stack(
                        children: [
                          CameraPreview(cameraBloc.controller!),
                          if (cameraBloc.showFocusCircle)
                            Positioned(
                                top: cameraBloc.y - 20,
                                left: cameraBloc.x - 20,
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.yellowAccent,
                                        width: 5,
                                      )),
                                )),
                        ],
                      ),
                    );
                  }),
                  if (!cameraBloc.controller!.value.isRecordingVideo)
                    BlocBuilder<CameraBloc, CameraState>(
                      builder: (context, state) {
                        return Align(
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
                              IconButton(
                                onPressed: () {
                                  cameraBloc.add(OpenFlashEvent(
                                    open: cameraBloc.flashOpened,
                                  ));
                                },
                                icon: Icon(
                                  cameraBloc.flashOpened
                                      ? Icons.flash_on
                                      : Icons.flash_off_outlined,
                                  color: cameraBloc.flashOpened
                                      ? Colors.yellowAccent
                                      : Colors.white,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  showDialog<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: [
                                              Text(
                                                "SELECT DURATION",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              const Spacer(),
                                              BlocBuilder<CameraBloc,
                                                  CameraState>(
                                                builder: (context, state) {
                                                  return Text(
                                                    "${cameraBloc.selectedMinutes} MIN",
                                                    style: const TextStyle(
                                                      color:
                                                          MyColors.primaryColor,
                                                      fontSize: 12,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          content: BlocBuilder<CameraBloc,
                                              CameraState>(
                                            builder: (context, state) {
                                              return NumberPicker(
                                                  value: cameraBloc
                                                      .selectedDuration
                                                      .inMinutes,
                                                  minValue: 1,
                                                  maxValue: 30,
                                                  itemWidth: 50,
                                                  infiniteLoop: true,
                                                  axis: Axis.horizontal,
                                                  onChanged: (value) {
                                                    cameraBloc.add(
                                                      ChangeSelectedDurationEvent(
                                                          duration: Duration(
                                                              minutes: value)),
                                                    );
                                                  });
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  "${cameraBloc.selectedMinutes} MIN",
                                  style: const TextStyle(
                                    color: Colors.yellowAccent,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              ResolutionsWidget(cameraBloc: cameraBloc),
                            ],
                          ),
                        );
                      },
                    ),
                  if (cameraBloc.controller!.value.isRecordingVideo)
                    Container(
                      margin: const EdgeInsets.only(top: MySizes.verticalSpace),
                      child: BlocBuilder<CameraBloc, CameraState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle,
                                        color: Colors.red, size: 18.0),
                                    const SizedBox(
                                        width: MySizes.horizontalSpace),
                                    Text(
                                      '${cameraBloc.minutes}:${cameraBloc.second}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: MySizes.widgetSideSpace),
                              FlagCountWidget(
                                count: cameraBloc.flags.length,
                                color: state is FlagsState
                                    ? const Color(0xFFFF1200)
                                    : const Color(0xFFFFFFFF),
                              ),
                            ],
                          );
                        },
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
              )
            : const LoadingWidget(),
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
