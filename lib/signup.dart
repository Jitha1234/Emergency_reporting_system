import 'dart:convert';

import 'package:accident/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';

class SignupPage extends StatefulWidget {
  _SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Widget build(BuildContext) {
    TextEditingController fnameController = TextEditingController();
    TextEditingController lnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController phEmController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController cpassController = TextEditingController();

    String msg = '';

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
      controller.addListener(onScroll);
    }

    @override
    void dispose() {
      // TODO: implement dispose
      controller.dispose();
      super.dispose();
    }

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
                    padding: EdgeInsets.fromLTRB(10.0, 90.0, 0.0, 0.0),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(225.0, 90.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Form(
                key: formkey,
                // ignore: deprecated_member_use
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: fnameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "First Name:",
                          labelStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      validator: RequiredValidator(errorText: 'Required *'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: lnameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Last Name:",
                          labelStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Phone No:",
                          labelStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      validator: MultiValidator([
                        
                        RequiredValidator(errorText: 'Required *'),
                        MinLengthValidator(10, errorText: 'Min length is 10'),
                        MaxLengthValidator(10, errorText: 'Max length is 10'),
                        PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)', errorText: ' phone No only contain numbers'),
                      ]),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: phEmController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Emergency Phone No:",
                          labelStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      validator: MultiValidator([

                        RequiredValidator(errorText: 'Required *'),
                        MinLengthValidator(10, errorText: 'Min length is 10'),
                        MaxLengthValidator(10, errorText: 'Max length is 10'),
                        PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)', errorText: ' phone No only contain numbers'),
                      ]),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email:",
                          labelStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Required *'),
                        EmailValidator(errorText: 'Note a valid Email')
                      ]),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password:",
                          labelStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      obscureText: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Required *'),
                        MinLengthValidator(6, errorText: 'Min length is 6'),
                        MaxLengthValidator(20, errorText: 'Max length is 20')
                      ]),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                        controller: cpassController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Confirm password:",
                            labelStyle: TextStyle(color: Colors.red),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                        obscureText: true,
                        validator: (val) {
                          if (val.isEmpty) return 'Required *';
                          if (val != passController.text) return 'Not Match';
                          return null;
                        }),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.red,
                        child: GestureDetector(
                          onTap: () async {
                            if (formkey.currentState.validate()) {
                              var firstname = fnameController.text.toString();
                              var lastname = lnameController.text.toString();
                              var email = emailController.text.toString();
                              var phone = phoneController.text.toString();
                              var password = passController.text.toString();
                              var phEm = phEmController.text.toString();
                              var data = await signup(
                                  firstname, lastname, email, phone, password,phEm);
                              Map jdata = jsonDecode(data);
                              if (jdata['status'] == 'reguser') {
                                var msg = 'Registration Success';
                                var clr = Colors.green;
                                mystost(msg, clr);
                                Navigator.of(context).pop();
                              } else if (jdata['status'] == 'existuser') {
                                var msg = 'Email already exist ';
                                var clr = Colors.red;
                                mystost(msg, clr);
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                Text('Allready Have an account ?'),
                SizedBox(
                  width: 5.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Sign in',
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

  signup(firstname, lastname, email, phone, password,phEm) async {
    var url= new Uri.http(ip,'app_api/userreg');
    var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "password": password,
        "emergencyph": phEm
      }),
    );
    return response.body;
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
