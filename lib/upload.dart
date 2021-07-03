import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:convert';
import 'constant.dart';
import 'home.dart';


class UploadPage extends StatefulWidget {
  final String sub;
  final String lmark;
  final String desc;
  final String firest;
  final String ambulancest;
  final String copsst;
  final String ksebst;

  UploadPage({Key key, @required this.sub,this.lmark,this.desc,this.firest,this.ambulancest,this.copsst,this.ksebst}) : super(key: key);
  @override
  _UploadPageState createState() => _UploadPageState(sub,lmark,desc,firest,ambulancest,copsst,ksebst);
}

class _UploadPageState extends State<UploadPage> {


  SharedPreferences logindata;
  String sub;
  String lmark;
  String desc;
  String firest;
  String ambulancest;
  String copsst;
  String ksebst;

  String id;
  File _imageFile;

  _UploadPageState(this.sub,this.lmark,this.desc,this.firest,this.ambulancest,this.copsst,this.ksebst);

  ProgressDialog pr;

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      id = logindata.getString('id');
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    initial();
  }


  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }



  @override
  Widget build(BuildContext context) {
    //============================================= loading dialoge
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.bounceIn,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    var sizescr = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (AppBar(
        title: Text("Tack picture and upload"),
      )),
      body: Stack(
        children: [
          SafeArea(child: ListView(
            children: [
              SizedBox(height: 10,),
              Center(
                child: GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      _getCurrentLocation();
                    },
                    child: Container(
                      height: sizescr.height * .65,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _imageFile != null
                              ? FileImage(_imageFile)
                              : AssetImage("assets/images/cam.png"),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startUploading();
        },
        child: Icon(Icons.send),
        backgroundColor: Colors.red,
      ),
    );
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print("get adress error"+e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }


  Future<Map<String, dynamic>> getUploadImg() async {
    var uri = Uri.parse("http://"+ip+"/app_api/accupload");
    setState(() {
      pr.show();
    });
    _getCurrentLocation();
    final mimeTypeData =
    lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', uri);
    final file = await http.MultipartFile.fromPath('file', _imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['subject'] = sub;
    imageUploadRequest.fields['landmark'] = lmark;
    imageUploadRequest.fields['description'] = desc;
    imageUploadRequest.fields['userid'] = id;
    imageUploadRequest.fields['latitude'] =
        _currentPosition.latitude.toString();
    imageUploadRequest.fields['longitude'] =
        _currentPosition.longitude.toString();
    imageUploadRequest.fields['address'] = _currentAddress;
    imageUploadRequest.fields['time'] = DateTime.now().toString();
    imageUploadRequest.fields['fire'] = firest;
    imageUploadRequest.fields['ambulance'] = ambulancest;
    imageUploadRequest.fields['cops'] = copsst;
    imageUploadRequest.fields['electrical'] = ksebst;
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print('upload error 1'+e);
      return null;
    }
  }

  void _startUploading() async {
    if (_imageFile == null) {
      setState(() {
        pr.hide();
      });
      var title = "! Warning";
      var msg = "Capture image before send";
      Function event = _popMsg;
      showAlertDialog(context, title, msg, event);
      print("no image or text");
    } else {
      final Map<String, dynamic> response = await getUploadImg();
      if (response != null) {
        print(response);
        setState(() {
          pr.hide();
        });
        var title = "Success";
        var msg = "Your report Successfully submitted";
        Function event = _backhome;
        showAlertDialog(context, title, msg, event);
      } else {
        pr.hide();
        var title = "Error !!!";
        var msg = "Error Occurred";
        Function event = _popMsg;
        showAlertDialog(context, title, msg, event);
        print("no response");
      }
    }
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


  _backhome() async {
    Navigator.pop(context);
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }

  _popMsg() {
    Navigator.of(context).pop();
  }



}
