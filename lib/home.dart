import 'package:accident/upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'loginscreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences logindata;
  String id = "";
  String ufname = "";
  String ulname = "";
  String email = "";
  String phone = "";
  String phEm = "";
  String pass = "";

  bool fire = false;
  bool ambulance = false;
  bool cops = false;
  bool kseb = false;

  var firest = '0';
  var ambulancest = '0';
  var copsst = '0';
  var ksebst = '0';

  var clrfire = Colors.white;
  var clrambulance = Colors.white;
  var clrcops = Colors.white;
  var clrkseb = Colors.white;

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final landmarkController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final controller = ScrollController();

  double offset = 0;
  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
    controller.addListener(onScroll);
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      id = logindata.getString('id');
      ufname = logindata.getString('ufname');
      ulname = logindata.getString('ulname');
      email = logindata.getString('email');
      phone = logindata.getString('phone');
      phEm = logindata.getString('emergencyph');
      pass = logindata.getString('pass');
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizescr = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: (AppBar(
        title: Row(
          children: <Widget>[Text('Report an accident')],
        ),
      )),
      endDrawer: Drawer(
        elevation: 10.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(ufname + ' ' + ulname),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/account');
              },
              child: ListTile(
                title: new Text("Account Settings"),
                leading: new Icon(Icons.settings),
              ),
            ),
            Divider(
              height: 0.1,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/reports');
              },
              child: ListTile(
                title: new Text("My Reports"),
                leading: new Icon(Icons.report),
              ),
            ),
            InkWell(
              onTap: () async {
                await logindata.clear();

                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: ListTile(
                title: new Text("Logout"),
                leading: new Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: sizescr.height * .45,
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/bg.png')),
            ),
          ),
          Container(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      'Select Departments needed.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (fire == false) {
                                    fire = true;
                                    setState(() {
                                      clrfire = Colors.lightBlueAccent;
                                    });
                                  } else {
                                    fire = false;
                                    setState(() {
                                      clrfire = Colors.white;
                                    });
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: clrfire,
                                  elevation: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/fireman.png',
                                        height: 128,
                                      ),
                                      Text(
                                        'Fire',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (ambulance == false) {
                                    setState(() {
                                      ambulance = true;
                                      clrambulance = Colors.lightBlueAccent;
                                    });
                                  } else {
                                    setState(() {
                                      ambulance = false;
                                      clrambulance = Colors.white;
                                    });
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: clrambulance,
                                  elevation: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/ambulance.png',
                                        height: 128,
                                      ),
                                      Text(
                                        'Ambulance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (cops == false) {
                                    setState(() {
                                      cops = true;
                                      clrcops = Colors.lightBlueAccent;
                                    });
                                  } else {
                                    setState(() {
                                      cops = false;
                                      clrcops = Colors.white;
                                    });
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: clrcops,
                                  elevation: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/cops.png',
                                        height: 128,
                                      ),
                                      Text(
                                        'Cops',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (kseb == false) {
                                    setState(() {
                                      kseb = true;
                                      clrkseb = Colors.lightBlueAccent;
                                    });
                                  } else {
                                    setState(() {
                                      kseb = false;
                                      clrkseb = Colors.white;
                                    });
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: clrkseb,
                                  elevation: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/kseb.png',
                                        height: 128,
                                      ),
                                      Text(
                                        'Electricity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            autofocus: false,
                            controller: subjectController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Subject",
                                labelStyle: TextStyle(color: Colors.red),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Required *'),
                              MaxLengthValidator(50,
                                  errorText: 'Max length is 50')
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            autofocus: false,
                            controller: landmarkController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Landmark",
                                labelStyle: TextStyle(color: Colors.red),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Required *'),
                              MaxLengthValidator(100,
                                  errorText: 'Max length is 100')
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            autofocus: false,
                            textCapitalization: TextCapitalization.words,
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Description",
                                labelStyle: TextStyle(color: Colors.red),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Required *'),
                              MaxLengthValidator(500,
                                  errorText: 'Max length is 500')
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ignore: deprecated_member_use
                  Container(
                      padding: EdgeInsets.only(top: 0, left: 0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ignore: deprecated_member_use
                          RaisedButton(
                            onPressed: () {
                              nextclick();
                            },
                            child: Text(
                              'Next >',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.red,
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  nextclick() {
    if (fire == false && ambulance == false && cops == false && kseb == false) {
      var msg = "Select Department needed";
      Color clr = Colors.red;
      mystost(msg, clr);
    } else {
      if (formkey.currentState.validate()) {
        if (fire == true) {
          firest = "1";
        }
        if (ambulance == true) {
          ambulancest = "1";
        }
        if (cops == true) {
          copsst = "1";
        }
        if (kseb == true) {
          ksebst = "1";
        }
        var sub = subjectController.text.toString();
        var lmark = landmarkController.text.toString();
        var desc = descriptionController.text.toString();
        print(firest + " " + ambulancest + " " + copsst + " " + ksebst);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadPage(
                  sub: sub,
                  lmark: lmark,
                  desc: desc,
                  firest: firest,
                  ambulancest: ambulancest,
                  copsst: copsst,
                  ksebst: ksebst),
            ));
      } else {
        var msg = "Fill required field";
        Color clr = Colors.red;
        mystost(msg, clr);
      }
    }
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
