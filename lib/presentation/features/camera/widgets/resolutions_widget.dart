import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/camera/bloc/camera_bloc.dart';

import '../bloc/camera_event.dart';

class ResolutionsWidget extends StatelessWidget {
  final CameraBloc cameraBloc;

  const ResolutionsWidget({
    required this.cameraBloc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ResolutionPreset>(
      elevation: MySizes.elevation.toInt(),
      alignment: Alignment.topRight,
      dropdownColor: Colors.black54,
      underline: Container(),
      value: cameraBloc.currentResolutionPreset,
      items: [
        for (ResolutionPreset preset in ResolutionPreset.values)
          DropdownMenuItem(
            alignment: Alignment.center,
            value: preset,
            child: Text(
              preset.toString().split('.')[1].toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
            ),
          ),
      ],
      onChanged: (value) {
        cameraBloc.currentResolutionPreset = value!;
        cameraBloc.add(InitCameraEvent());
      },
    );
  }
}
