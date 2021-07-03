import 'package:accident/details.dart';
import 'package:flutter/material.dart';
import 'package:accident/constant.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Data {
  final String id;
  final String title;
  final String address;

  Data({this.id, this.title, this.address});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'],
      title: json['subject'],
      address: json['address'],
    );
  }
}

class MyReports extends StatefulWidget {
  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  Future<List<Data>> fetchData() async {
    var query = {'id': id};
    var url = new Uri.http(ip, "/app_api/myreports/", query);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  SharedPreferences logindata;
  String id = "";
  Future<List<Data>> futureData;

  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      id = logindata.getString('id');
    });
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('My reports'),
      ),
      body: Center(
        child: FutureBuilder<List<Data>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Data> data = snapshot.data;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      height: 150,
                      color: Colors.white,
                      width: double.maxFinite,
                      child: Card(
                        color: Colors.red[100],
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Stack(children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Icon(
                                                      Icons
                                                          .announcement_rounded,
                                                      color: Colors.red,
                                                      size: 40,
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Align(alignment: Alignment.topCenter,
                              child: Padding(padding: const EdgeInsets.only(top: 5),
                                child: Text(data[index].title,style: TextStyle(fontSize: 25,color: Colors.blue),),
                              ),
                            ),
                            Align(alignment: Alignment.center,
                              child: Padding(padding: const EdgeInsets.only(top: 5),
                                child: Text("Place: "+data[index].address,style: TextStyle(fontSize: 18,color: Colors.blue),),
                              ),
                            ),
                            Align(alignment: Alignment.bottomLeft,
                              child: Padding(padding: const EdgeInsets.only(top: 5),
                                child: Text("Id: "+data[index].id,style: TextStyle(fontSize: 15,color: Colors.blue),),
                              ),
                            ),
                            Align(alignment: Alignment.bottomRight,
                              child: Padding(padding: const EdgeInsets.only(top: 5),
                                child: InkWell(
                                  onTap: (){
                                    var idd = data[index].id;
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => DetailsPage(id: idd,)));
                                  },
                                    child: Text("Read more >",style: TextStyle(fontSize: 16,color: Colors.blue),)
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
