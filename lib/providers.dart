import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/util/global_variables.dart';
import 'package:nice_shot/data/repositories/edited_video_repository.dart';
import 'package:nice_shot/data/repositories/raw_video_repository.dart';
import 'package:nice_shot/data/repositories/user_repository.dart';
import 'package:nice_shot/presentation/features/edited_videos/bloc/edited_video_bloc.dart';
import 'package:nice_shot/presentation/features/auth/bloc/auth_bloc.dart';

import 'package:nice_shot/presentation/features/camera/bloc/bloc.dart';
import 'package:nice_shot/presentation/features/editor/bloc/trimmer_bloc.dart';
import 'package:nice_shot/presentation/features/main_layout/bloc/main_layout_bloc.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/features/raw_videos/bloc/raw_video_bloc.dart';

List<BlocProvider> providers = [
  BlocProvider<AuthBloc>(
    create: (_) => AuthBloc(userRepository: UserRepositoryImpl()),
  ),
  BlocProvider<UserBloc>(
    create: (_) =>
        UserBloc(userRepository: UserRepositoryImpl())..add(GetUserDataEvent()),
  ),
  BlocProvider<CameraBloc>(
    create: (_) => CameraBloc()..add(InitCameraEvent()),
  ),

  BlocProvider<TrimmerBloc>(
    create: (_) => TrimmerBloc(),
  ),
  BlocProvider<EditedVideoBloc>(
    create: (_) => EditedVideoBloc(
      editedVideosRepository: EditedVideosRepositoryImpl(),
    )..add(GetEditedVideosEvent(id: userId!)),
  ),
  BlocProvider<RawVideoBloc>(
    create: (_) => RawVideoBloc(
      rawVideosRepository: RawVideosRepositoryImpl(),
    ),
  ),
  BlocProvider<MainLayoutBloc>(
    create: (_) => MainLayoutBloc(),
  ),
];
