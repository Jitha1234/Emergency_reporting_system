//
// Generated file. Do not edit.
//

// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_sms/flutter_sms_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:sensors_plus_web/sensors_plus_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FlutterSmsPlugin.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  SensorsPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
