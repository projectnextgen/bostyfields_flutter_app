import 'dart:core';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:bostyfield_app/screen/bookings.dart';
import 'package:bostyfield_app/screen/contactus.dart';
import 'package:bostyfield_app/screen/fieldaccess.dart';
import 'package:bostyfield_app/screen/myaccount.dart';
import 'package:bostyfield_app/screen/payment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'home.dart';
import 'login.dart';
import 'nextavailable.dart';

class AvailableTimes extends StatefulWidget {
  @override
  AvailableTimesState createState() => new AvailableTimesState();
}

class AvailableTimesState extends State<AvailableTimes> {

  var field;  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var userid;
  var name;
  var date;
  var selectedamountofdogs;
  var time;
  var selectedfield;
  var selecteddate;
  var results;
  var data;
  var day;
  var formatdate;
  var dateformat;

  Future<String> getData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    selecteddate = localStorage.getString("selecteddate");

    dateformat = DateTime.parse(selecteddate);
    day = DateFormat('EEEE').format(dateformat); /// e.g Thursday
    formatdate = day + " " + selecteddate;

    var user = jsonDecode(localStorage.getString('user')!);
    var gettimes = localStorage.getString("times");
    var selectedfield = localStorage.getString("selectedfield");
    var decodegettimes = json.decode(gettimes!);
    if(user != null) {
      setState(() {
        userid = user['id'];
        name = user['firstname'];
      });
    }
    if(selectedfield=="1"){
      field = "Wenlock Walk";
    };
    if(selectedfield=="2"){
      field = "Linley Leap";
    };
    if(selectedfield=="3"){
      field = "Fae";
    };
    if(selectedfield=="4"){
      field = "Troll";
    };
    this.setState(() {
      data = jsonDecode(decodegettimes);
      print(data);
    });
    if(data.length == 0){
      results = 0;
    }
    setState(() {
      _isLoading = false;
    });
    return "Success!";
  }
  @override
  void initState(){
    super.initState();
    this.getData();
    BackButtonInterceptor.add(myInterceptor);
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => NextAvailable()
      ),
    );// Do some stuff.
    return true;
  }
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: new Text("BostyFields.co.uk", style: GoogleFonts.prompt(fontWeight: FontWeight.w500)),
          backgroundColor: Colors.green[600]),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen[600],
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/logo.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
              child: Text('Hi, $name', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            ListTile(
              title: Text('Bookings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Bookings()
                  ),
                );// Do some stuff.
              },
            ),
            ListTile(
              title: Text('Field Access'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => FieldAccess()
                  ),
                );// Do some stuff.
              },
            ),
            ListTile(
              title: Text('Book a Walk'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Home()
                  ),
                );
              },
            ),
            ListTile(
              title: Text('My Account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => MyAccount()
                  ),
                );// Do some stuff.
              },
            ),
            ListTile(
              title: Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ContactUs()
                  ),
                );// Do some stuff.
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.green[600]!))) : Stack(
          children: <Widget>[
          Material(
            child: results == 0 ? Center(child: Text('No Bookings Available')) : new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index){
              bool last = data.length == (index + 1);
              if(last) {
                return new GestureDetector(
                  onTap: () => _order(data[index]["time"]),
                  child: Card(elevation: 4.0,
                    color: Colors.green[600],
                    margin: EdgeInsets.only(top: 30, left: 100, right: 100, bottom:150),
                    child:
                    Center(child:Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: new Text(
                            data[index]["time"], textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            )),
                      )
                    )
                  ),
                );
                }else {
                  return new GestureDetector(
                    onTap: () => _order(data[index]["time"]),
                    child: Card(elevation: 4.0,
                      color: Colors.green[600],
                      margin: EdgeInsets.only(top: 30, left: 100, right: 100),
                      child:
                      Center(child:Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                              data[index]["time"], textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              )
                          )
                        )
                      )
                    ),
                  );
                };
            },
          ),
        ),
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Center(
                child: Card(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.book),
                        title: Text(field == null ? "Field" : field),
                        subtitle: Text(formatdate == null ? "date" : formatdate + " times. Live dates can be viewed by using the search or go back to select a different field."),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('BACK'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => NextAvailable()
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                              showTitleActions: true,

                              minTime: DateTime(2021, 8, 1),
                              maxTime: DateTime(2021, 12, 31), onConfirm: (date) {
                                  _selectiondate(date.toString());
                              }, locale: LocaleType.en);
                            },
                            child: Text(
                            'SEARCH',
                              ),
                            ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ])
      ),
    );
  }
  void _selectiondate(date) async{
    setState(() {
      _isLoading = true;
    });

    date = date.split(" ").first;

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    selectedfield = localStorage.getString('selectedfield');

    localStorage.setString('selecteddate', date!);

    var res = await Network().getPostData("/bookings/"+selectedfield+"/"+date!);
    var entimes = json.encode(res.body);

    localStorage.setString("times", entimes);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>AvailableTimes()));
  }
  Future<void> _order(time) async{
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    selectedfield = localStorage.getString('selectedfield');
    selectedamountofdogs = localStorage.getString('selecteddogs');
    localStorage.setString('time', time!);

    var data = {
      'userid' : userid,
      'fieldid' : selectedfield,
      'amountofdogs' : selectedamountofdogs,
      'date': selecteddate,
      'time': time,
    };

    var res = await Network().bookingData(data, '/booking');
    var body = json.decode(res.body);
    var outstandingamount = body['outstandingamount'];
    if(outstandingamount==true){
      var message = json.encode(body['message']);
      localStorage.setString('outstandingamount', message);
      print(message);
    }

    localStorage.setString('booking', json.encode(body['booking']));
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>PaymentScreen()));
  }
  void logout() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('access_token');
    localStorage.remove('token_type');
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>Login()));
  }
}