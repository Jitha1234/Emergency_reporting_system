import 'package:accident/constant.dart';
import 'package:accident/home.dart';
import 'package:accident/screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'signup.dart';
import 'home.dart';


class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var uid;
  var ufname = '';
  var ulname = '';
  var uemail = '';
  var uphone = '';
  var uphEm = '';
  var upass = '';
  final controller = ScrollController();
  double offset = 0;
  SharedPreferences logindata;
  bool newuser;

  ProgressDialog pr;

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    setnewuser();
    controller.addListener(onScroll);
  }

  // ignore: non_constant_identifier_names
  void setnewuser() async {
    logindata = await SharedPreferences.getInstance();
    newuser = logindata.getBool('login');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    controller.dispose();
    super.dispose();
  }

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print("get adress error"+e);
    });
  }

  Widget build(BuildContext) {
    //============================================= loading dialog
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.linear,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return new Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 110.0, 0.0, 0.0),
                    child: Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25.0, 177.0, 0.0, 0.0),
                    child: Text(
                      'There',
                      style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(250.0, 177.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Form(
                key: formkey,
                // ignore: deprecated_member_use
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "EMAIL",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Required *'),
                        EmailValidator(errorText: 'Note a valid Email')
                      ]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      obscureText: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Required *'),
                        MinLengthValidator(6, errorText: 'Min length is 6'),
                        MaxLengthValidator(20, errorText: 'Max length is 20')
                      ]),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.red,
                        child: GestureDetector(
                          onTap: () async {
                            if (formkey.currentState.validate()) {
                              var email = emailController.text.toString();
                              var password = passController.text.toString();
                              var data = await login(email, password);
                              Map jdata = jsonDecode(data);
                              if (jdata.isEmpty) {
                                var msg = 'Login failed';
                                var clr = Colors.red;
                                mystost(msg, clr);
                              } else {
                                if (jdata['status'] == 'nouser') {
                                  setState(() {
                                    pr.hide();
                                  });
                                  var title = "Email does note exist";
                                  var msg = "Press ok to register";
                                  Function event = _signup;
                                  showAlertDialog(context, title, msg, event);
                                } else if (jdata['status'] == 'failed') {
                                  setState(() {
                                    pr.hide();
                                  });

                                  var title = "Check !";
                                  var msg = "Email or password does note match";
                                  Function event = _popMsg;
                                  showAlertDialog(context, title, msg, event);
                                } else if (jdata['status'] == 'login') {
                                  uid = jdata['id'];
                                  ufname = jdata['firstname'];
                                  ulname = jdata['lastname'];
                                  uemail = jdata['email'];
                                  uphone = jdata['phone'];
                                  uphEm = jdata['emergencyph'];
                                  upass = jdata['password'];

                                  logindata.setBool('login', false);
                                  logindata.setString('id', uid);
                                  logindata.setString('ufname', ufname);
                                  logindata.setString('ulname', ulname);
                                  logindata.setString('email', uemail);
                                  logindata.setString('phone', uphone);
                                  logindata.setString('emergencyph', uphEm);
                                  logindata.setString('pass', upass);
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                                }
                              }
                            } else {
                              var msg = 'fill the required fields';
                              var clr = Colors.red;
                              mystost(msg, clr);
                            }
                          },
                          child: Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            //var msg = 'This feature only allowed on production';
                            //var clr = Colors.red;
                            //mystost(msg, clr);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScreenPage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.indigoAccent,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: ImageIcon(
                                    AssetImage('assets/facebook.png'),
                                    color: Colors.indigoAccent,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Center(
                                  child: Text(
                                    'Log in with facebook',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('New to here ?'),
                SizedBox(
                  width: 8.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  login(email, password) async {
    var url= new Uri.http(ip, "/app_api/login");
    setState(() {
      pr.show();
    });
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );
    setState(() {});
    return response.body;
  }

  showAlertDialog(BuildContext context, title, msg, event) {
    // Create button
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: event,
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _signup() {
    _popMsg();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  _popMsg() {
    Navigator.of(context).pop();
    setState(() {
      pr.hide();
    });
  }

  mystost(msg, clr) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: clr,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}