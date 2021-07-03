import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:accident/constant.dart';
import 'package:http/http.dart' as http;
import 'package:accident/account.dart';

class passwordChange extends StatefulWidget {
  @override
  _passwordChangeState createState() => _passwordChangeState();
}

class _passwordChangeState extends State<passwordChange> {
  SharedPreferences logindata;
  String id = "";
  String pass = "";

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
      pass = logindata.getString('pass');
    });
  }

  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Stack(
        children: [
          Container(),
          Container(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(),
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
                            obscureText: true,
                            controller: currentPassController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Current password",
                                labelStyle: TextStyle(color: Colors.red),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Required *'),
                              MinLengthValidator(6,
                                  errorText: 'Min length is 6'),
                              MaxLengthValidator(20,
                                  errorText: 'Max length is 20')
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            autofocus: false,
                            obscureText: true,
                            controller: newPassController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "New password",
                                labelStyle: TextStyle(color: Colors.red),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Required *'),
                              MinLengthValidator(6,
                                  errorText: 'Min length is 6'),
                              MaxLengthValidator(20,
                                  errorText: 'Max length is 20')
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autofocus: false,
                              obscureText: true,
                              controller: confirmPassController,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Confirm new password",
                                  labelStyle: TextStyle(color: Colors.red),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red))),
                              validator: (val) {
                                if (val.isEmpty) return 'Required *';
                                if (val != newPassController.text)
                                  return 'Not Match';
                                return null;
                              }),
                          SizedBox(
                            height: 10.0,
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
                              update();
                              },
                            child: Text(
                              'Update',
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
    );
  }

  void update() async {
    if (formkey.currentState.validate()) {
      if(currentPassController.text != pass){
        String title = '!! Warning !!';
        String msg = 'Current password is incorrect\ncheck your current password';
        Function event = _popMsg;
        showAlertDialog(context,title , msg, event);
      }else{
        if(newPassController.text == pass){
          String title = '!! Warning !!';
          String msg = 'you can\'t use current password as new password';
          Function event = _popMsg;
          showAlertDialog(context,title , msg, event);
        }else{
          String uploadPass=newPassController.text;
          String uploadId = id;
          var data = await update2(uploadId, uploadPass);
          print(data);
          Map jdata = jsonDecode(data);
          if (jdata.isEmpty) {
            String warning ="Err!!";
            String msg ="Some server side error occurred";
            Function event = _popMsg;
            showAlertDialog(context,warning , msg, event);
          }else{
            pass = jdata['pass'];

            logindata.setString('pass', pass);
            String warning ="Sucess";
            String msg ="Password updated sucessfully";
            Function event = _backaccount;
            showAlertDialog(context,warning , msg, event);
          }
        }
      }
    }else{
      String title = '!! Warning !!';
      String msg = 'Fill the required fields';
      Function event =_popMsg;
      showAlertDialog(context,title , msg, event);
    }
  }


  update2(id, pass,) async {
    var url= new Uri.http(ip, "/app_api/passupdate");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"id": id,"pass": pass}),
    );
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
  _backaccount() async {
    Navigator.pop(context);
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => accountPage()), (route) => false);
  }

  _popMsg() {
    Navigator.of(context).pop();
  }


}
