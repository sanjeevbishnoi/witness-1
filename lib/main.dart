import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/data/repositories/edited_video_repository.dart';
import 'package:nice_shot/data/repositories/user_repository.dart';
import 'package:nice_shot/presentation/features/edited_videos/bloc/edited_video_bloc.dart';
import 'package:nice_shot/presentation/features/permissions/permissions.dart';
import 'package:nice_shot/presentation/bloc_delegate.dart';
import 'package:nice_shot/presentation/features/permissions/allow_access_page.dart';
import 'package:nice_shot/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:nice_shot/presentation/features/auth/pages/register_page.dart';
import 'package:nice_shot/presentation/features/camera/bloc/bloc.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/features/trimmer/bloc/trimmer_bloc.dart';
import 'package:nice_shot/presentation/router/app_router.dart';
import 'core/global_variables.dart';
import 'data/model/duration.g.dart';
import 'data/model/flag_model.dart';
import 'data/model/video_model.dart';
import 'data/network/local/cache_helper.dart';
import 'data/network/remote/dio_helper.dart';
import 'injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  await di.init();
  final directory = await path.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.initFlutter();
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(VideoModelAdapter());
  Hive.registerAdapter(FlagModelAdapter());
  await Hive.openBox<VideoModel>('video_db');
  await Hive.openBox<VideoModel>('exported_video_db');
  await AppPermissions.checkPermissions().then(
    (value) => permissionsGranted = value,
  );
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: ApplicationBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(userRepository: UserRepositoryImpl()),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(userRepository: UserRepositoryImpl()),
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
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Camera demo',
        theme: Themes.theme,
        onGenerateRoute: Routers.generateRoute,
        home: permissionsGranted ? RegisterPage() : const AllowAccessPage(),
      ),
    );
  }
}
