import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:accident/constant.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final String id;
  const DetailsPage({Key key, @required this.id}) : super(key: key);
  @override
  _DetailsPageState createState() => new _DetailsPageState(id);
}

class _DetailsPageState extends State<DetailsPage> {
  String id;
  String title;
  String address;
  String time;
  String description;
  String landmark;
  String latitude;
  String longitude;
  String fire;
  String ambulance;
  String cops;
  String electrical;
  String imgsrc;
  String formattedDate;
  String formattedTime;
  String StsFire;
  String StsAmbulance;
  String StsCops;
  String StsKseb;
  _DetailsPageState(this.id);
  Future FitchData()async{
    var query = {'id': id};
    var url = new Uri.http(ip, "/app_api/reportdetail/", query);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jdata = jsonDecode(response.body);
      title = jdata['subject'];
      address = jdata['address'];
      time = jdata['time'];
      description = jdata['description'];
      landmark = jdata['landmark'];
      latitude = jdata['latitude'];
      longitude = jdata['longitude'];
      fire = jdata['fire'];
      ambulance = jdata['ambulance'];
      cops = jdata['cops'];
      electrical = jdata['electrical'];
      imgsrc = 'http://'+ip+'/images/accuploads/'+id+'.jpeg';
      formattedDate=DateFormat('yyyy-MM-dd').format(DateTime.parse(time));
      formattedTime=DateFormat('kk:mm:ss').format(DateTime.parse(time));
      if(fire == '0'){
        StsFire = 'assets/images/cross.png';
      }
      else if(fire == '1'){
        StsFire = "assets/images/wait.gif";
      }
      else if(fire == '10'){
        StsFire = "assets/images/blktick.png";
      }
      else if(fire == '11'){
        StsFire = "assets/images/grntick.png";
      }

      if(ambulance == '0'){
        StsAmbulance = "assets/images/cross.png";
      }
      else if(ambulance == '1'){
        StsAmbulance = "assets/images/wait.gif";
      }
      else if(ambulance == '10'){
        StsAmbulance = "assets/images/blktick.png";
      }
      else if(ambulance == '11'){
        StsAmbulance = "assets/images/grntick.png";
      }

      if(cops == '0'){
        StsCops = "assets/images/cross.png";
      }
      else if(cops == '1'){
        StsCops = "assets/images/wait.gif";
      }
      else if(cops == '10'){
        StsCops = "assets/images/blktick.png";
      }
      else if(cops == '11'){
        StsCops = "assets/images/grntick.png";
      }

      if(electrical == '0'){
        StsKseb = "assets/images/cross.png";
      }
      else if(electrical == '1'){
        StsKseb = "assets/images/wait.gif";
      }
      else if(electrical == '10'){
        StsKseb = "assets/images/blktick.png";
      }
      else if(electrical == '11'){
        StsKseb = "assets/images/grntick.png";
      }

    }else{
      throw Exception('Unexpected error occured!');
    }
  }
  Future futureData;

  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    futureData = FitchData();
  }


  @override
  Widget build(BuildContext context) {
    var sizescr = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: (AppBar(title: Text("Accident Details"),)),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder(
            future: futureData,
            builder: (context, snapshot) {
              if (title != null) {
                return new Container(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      Card(
                        color: Colors.red[100],
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Image.network(imgsrc,fit: BoxFit.cover,height: sizescr.height * .50,width: double.maxFinite,),
                                SizedBox(height: 10,),
                                Text(title,style: TextStyle(fontSize: 25,color: Colors.red),),
                                SizedBox(height: 10,),
                                Row(children: [
                                  Text("Date  : ",style: TextStyle(color: Colors.red,),),
                                  SizedBox(width: 3,),
                                  Text(formattedDate)
                                ],),
                                SizedBox(height: 5,),
                                Row(children: [
                                  Text("Time  : ",style: TextStyle(color: Colors.red,),),
                                  SizedBox(width: 3,),
                                  Text(formattedTime)
                                ],),
                                SizedBox(height: 5,),
                                Row(children: [
                                  Text("Place  : ",style: TextStyle(color: Colors.red,),),
                                  SizedBox(width: 3,),
                                  Text(address)
                                ],),
                              ],
                            ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                        elevation: 5,
                        margin: EdgeInsets.only(left: 35,top: 10,right: 35),
                      ),
                      SizedBox(height: 15,),
                      Card(
                        color: Colors.red[100],
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                Text("Status",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Fire"),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: 25,
                                          child: Image.asset(StsFire),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Ambulance"),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: 25,
                                          child: Image.asset(StsAmbulance),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Cops"),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: 25,
                                          child: Image.asset(StsCops),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("KSEB"),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: 25,
                                          child: Image.asset(StsKseb),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: EdgeInsets.only(left: 35,top: 10,right: 35),
                      ),
                      SizedBox(height: 15,),
                      Card(
                        color: Colors.red[100],
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                Text("Landmark",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text(landmark,style: TextStyle(fontSize: 17,color: Colors.black),),
                              ],
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: EdgeInsets.only(left: 35,top: 10,right: 35),
                      ),
                      SizedBox(height: 15,),
                      Card(
                        color: Colors.red[100],
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                Text("Description",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text(description,style: TextStyle(fontSize: 17,color: Colors.black),),
                                
                              ],
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: EdgeInsets.only(left: 35,top: 10,right: 35),
                      ),
                      SizedBox(height: 15,),
                      
                    ],
                  ),
                );
              }else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
    
  }
}
