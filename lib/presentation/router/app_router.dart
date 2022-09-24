import 'package:flutter/material.dart';
import 'package:nice_shot/presentation/features/auth/pages/login_page.dart';
import 'package:nice_shot/presentation/features/auth/pages/register_page.dart';
import 'package:nice_shot/presentation/features/auth/pages/verify_phone.dart';
import 'package:nice_shot/presentation/features/camera/camera_page.dart';
import 'package:nice_shot/presentation/features/edited_videos/edited_videos_page.dart';
import 'package:nice_shot/presentation/features/raw_videos/videos_page.dart';
import '../../core/routes/routes.dart';
import '../features/home/pages/home.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.loginPage:
        return MaterialPageRoute(builder: (_) =>  LoginPage());
      case Routes.registerPage:
        return MaterialPageRoute(builder: (_) =>  RegisterPage());
      case Routes.videosPage:
        return MaterialPageRoute(builder: (_) => const VideosPage());
      // case Routes.flagsByVideoPage:
      //   return MaterialPageRoute(builder: (_) => FlagsByVideoPage());
      case Routes.extractedVideosPage:
        return MaterialPageRoute(builder: (_) => const EditedVideoPage());
      case Routes.verifyCodePage:
        return MaterialPageRoute(builder: (_) => const VerifyCodePage());
      case Routes.cameraPage:
        return MaterialPageRoute(builder: (_) => const CameraPage());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
