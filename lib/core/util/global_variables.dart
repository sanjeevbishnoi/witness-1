import 'package:flutter/material.dart';
import 'package:nice_shot/data/model/api/login_model.dart';

bool permissionsGranted = false;
String token = "Bearer ${currentUserData?.token}";
LoginModel? currentUserData;
String? userId = "${currentUserData!.user!.id}";
final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
