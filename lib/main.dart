import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:accident/screen.dart';
import 'package:accident/changepass.dart';
import 'package:accident/home.dart';
import 'package:accident/reports.dart';
import 'package:accident/splash.dart';
import 'package:flutter/material.dart';
import 'package:accident/signup.dart';
import 'package:accident/account.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_sms/flutter_sms.dart';

import 'constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'CodeLoser',
        channelDescription: 'Notification',
        defaultColor: Colors.green[200],
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true)
  ]);

  FlutterBackgroundService.initialize(onStart);

  runApp(MyApp());
}

void onStart() async {
  Timer _timer;
  SharedPreferences logindata;
  bool newuser;
  String id = "";
  String phEm = "";
  String ufname = "";
  String ulname = "";
  bool snd = false;
  bool slack = true;

  shared() async {
    logindata = await SharedPreferences.getInstance();
    newuser = logindata.getBool('login');
    id = logindata.getString('id');
    ufname = logindata.getString('ufname');
    ulname = logindata.getString('ulname');
    phEm = logindata.getString('emergencyph');
  }

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int min = 100, max = 100;
  String state = "Rest";
  int counter = 0;

  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.setForegroundMode(true);
  _alert(_state) {
    service.setNotificationInfo(
      title: "Accident Detection",
      content: _state,
    );
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      print("get adress error" + e);
    });
  }

  service.onDataReceived.listen((event) {
    if (event['action'] == "cancel") {
      _timer.cancel();
      print("Cancelled");
      snd = false;
    }
  });
  void check_if_already_login() async {
    shared();
    if (newuser == false) {
      notify("Fall Detected, If its not you then click here within 10s");
      if (snd == false) {
        snd = true;
        print(state);
        _getCurrentLocation();
        print(_currentPosition.toString());
        _timer = Timer(Duration(seconds: 10), () {
          snd = false;
          slack = false;
          var url = new Uri.http(ip, "/app_api/fallen");
          http.post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id": id,
              'phEm': phEm,
              'fname': ufname,
              'lname': ulname,
              'lat': _currentPosition.latitude.toString(),
              'long': _currentPosition.longitude.toString()
            }),
          );

          notify("Your emergency messege Send");
        });
      }
    } else {
      notify("Please Login");
    }
  }

  final detecting = (AccelerometerEvent event) async {
    _accelerometerValues = <double>[event.x, event.y, event.z];
    int sum = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)).round();
    if (min > sum) {
      min = sum;
    }
    if (max < sum) {
      max = sum;
    }
    if (min < 3) {
      min = 100;
      check_if_already_login();
    }
  };
  _streamSubscriptions.add(
    accelerometerEvents.listen(
      detecting,
    ),
  );
  _streamSubscriptions.add(
    userAccelerometerEvents.listen(
      (UserAccelerometerEvent event) {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      },
    ),
  );
}

void notify(body) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'key1',
      title: 'Ears',
      body: body,
    ),
  );
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    AwesomeNotifications().actionStream.listen((event) {
      FlutterBackgroundService().sendData({"action": "cancel"});
    });
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/account': (BuildContext context) => new accountPage(),
        '/password': (BuildContext context) => new passwordChange(),
        '/home': (BuildContext context) => new HomePage(),
        '/reports': (BuildContext context) => new MyReports(),
        '/screenpage': (BuildContext context) => new ScreenPage(),
      },
      home: new SplashScreen(),
    );
  }
}
