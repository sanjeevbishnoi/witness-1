import 'dart:io';
import 'package:path_provider/path_provider.dart';
String logoPath="";
Future<String> getLogoPath() async {
  final Directory extDir = await getApplicationDocumentsDirectory();
  File file = File('${extDir.path}/logo.png');
  logoPath=file.path;
  return file.path;
}
