import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/data/model/api/login_model.dart';
import 'package:nice_shot/presentation/features/permissions/permissions.dart';
import 'package:nice_shot/logic/debugs/bloc_delegate.dart';
import 'package:nice_shot/presentation/router/app_router.dart';
import 'package:nice_shot/providers.dart';
import 'core/functions/functions.dart';
import 'core/internet_connection.dart';
import 'core/util/global_variables.dart';
import 'data/network/local/cache_helper.dart';
import 'data/network/remote/dio_helper.dart';
import 'injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  DioHelper.init();
ConnectionStatusSingleton.getInstance();
  await CacheHelper.init();
  await di.init();
  final directory = await path.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.initFlutter();
  registerAdapters();
  await openBoxes();
  await AppPermissions.checkPermissions().then((value) {
    permissionsGranted = value;
  });
  String? initRoute;
  final user = CacheHelper.getData(key: "user");
  if (user != null) {
    currentUserData = LoginModel.fromJson(json.decode(user));
    initRoute = Routes.homePage;
  }
  if (user == null && permissionsGranted) {
    initRoute = Routes.registerPage;
  }
  if (!permissionsGranted) {
    initRoute = Routes.allowAccessPage;
  }
  BlocOverrides.runZoned(() {
    runApp(MyApp(initRoute: initRoute!));
  }, blocObserver: ApplicationBlocObserver());
}

class MyApp extends StatelessWidget {
  final String initRoute;

  const MyApp({Key? key, required this.initRoute}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Camera demo',
        theme: Themes.theme,
        onGenerateRoute: Routers.generateRoute,
        initialRoute: initRoute,
      ),
    );
  }
}
