import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:accident/constant.dart';
import 'package:accident/home.dart';
class accountPage extends StatefulWidget {
  @override
  _accountPageState createState() => _accountPageState();
}

class _accountPageState extends State<accountPage> {
  SharedPreferences logindata;
  String id = "" ;
  String ufname = "";
  String ulname = "";
  String email = "";
  String phone = "";
  String phEm = '';
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
      ufname = logindata.getString('ufname');
      ulname = logindata.getString('ulname');
      email = logindata.getString('email');
      phone = logindata.getString('phone');
      phEm = logindata.getString('emergencyph');
      pass = logindata.getString('pass');
      fNameController.text=ufname;
      lNameController.text=ulname;
      emailController.text=email;
      phoneController.text=phone;
      phEmController.text=phEm;
    });
  }

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final phEmController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
        appBar: AppBar(title: Text('Account'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return Constants.choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Stack(
          children: [
            Container(

            ),
            Container(
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      child: Text(
                        'Update your account details.',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Form(
                        autovalidateMode: AutovalidateMode.always, key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autofocus: false,
                              controller: fNameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "First name",
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
                              controller: lNameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Last Name",
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
                              controller: emailController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.red),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red))),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Required *'),
                                EmailValidator(errorText: 'Note a valid Email'),
                                MaxLengthValidator(100,
                                    errorText: 'Max length is 100')
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autofocus: false,
                              controller: phoneController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Phone No",
                                  labelStyle: TextStyle(color: Colors.red),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red))),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Required *'),
                                MinLengthValidator(10, errorText: 'Min length is 10'),
                                MaxLengthValidator(10, errorText: 'Max length is 10'),
                                PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)', errorText: ' phone No only contain numbers'),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autofocus: false,
                              controller: phEmController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Emergency Phone No",
                                  labelStyle: TextStyle(color: Colors.red),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red))),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Required *'),
                                MinLengthValidator(10, errorText: 'Min length is 10'),
                                MaxLengthValidator(10, errorText: 'Max length is 10'),
                                PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)', errorText: ' phone No only contain numbers'),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autofocus: false,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "password",
                                  labelStyle: TextStyle(color: Colors.red),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red))),
                              obscureText: true,
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Required *'),
                                MinLengthValidator(6, errorText: 'Min length is 6'),
                                MaxLengthValidator(20, errorText: 'Max length is 20')
                              ]),
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    // ignore: deprecated_member_use
                    Container(
                        padding: EdgeInsets.only(top: 0, left: 0, right: 20.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: (){
                                if (formkey.currentState.validate()) {
                                  update();
                                }else{
                                  String warning ="!! Warning !!";
                                  String msg ="Fill required fields";
                                  showAlertDialog(context,warning , msg);
                                }
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
                            SizedBox(height: 60,),
                          ],
                        )

                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ignore: missing_return
      onWillPop: () async {
        await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
      },
    );
  }

  void update(){
    if(fNameController.text==ufname){
      if(lNameController.text==ulname){
        if(emailController.text==email){
          if(phoneController.text==phone){
            if(phEmController.text==phEm){
              String warning ="!! Warning !!";
              String msg ="No changes for update";
              showAlertDialog(context,warning , msg);
            }else{update_1();}
          }else{update_1();}
        }else{update_1();}
      }else{update_1();}
    }else{update_1();}
  }



  void update_1() async {
    if(passwordController.text==pass){
      String uploadId=id;
      String uploadFname=fNameController.text;
      String uploadLname=lNameController.text;
      String uploadEmail=emailController.text;
      String uploadPhone=phoneController.text;
      String uploadphEm=phEmController.text;
      var data = await update2(uploadId, uploadFname, uploadLname, uploadEmail, uploadPhone, uploadphEm);
      print(data);
      Map jdata = jsonDecode(data);
      if (jdata.isEmpty) {
        String warning ="Err!!";
        String msg =""
            "Some server side error occurred";
        showAlertDialog(context,warning , msg);
      }else{
        ufname = jdata['fname'];
        ulname = jdata['lname'];
        email = jdata['email'];
        phone = jdata['phone'];
        phEm = jdata['emergencyph'];
        logindata.setString('ufname', ufname);
        logindata.setString('ulname', ulname);
        logindata.setString('email', email);
        logindata.setString('phone', phone);
        logindata.setString('emergencyph', phEm);
        String warning ="Sucess";
        String msg =""
            "Data updated sucessfully";
        showAlertDialog(context,warning , msg);
      }
    }else{
      String warning ="Err!!";
      String msg =""
          "Password incorrect\ncheck your password";
      showAlertDialog(context,warning , msg);
    }
  }


  update2(id, fname, lname, email, phone,phEm) async {
    var url= new Uri.http(ip, "/app_api/userupdate");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"id": id,"fname": fname,"lname": lname,"email": email,"phone": phone,"emergencyph": phEm}),
    );
    return response.body;
  }



  showAlertDialog(BuildContext context, title, msg) {
    // Create button
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: (){Navigator.of(context).pop();},
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

  void choiceAction(String choice){
    Navigator.of(context).pushNamed('/password');
  }
}
