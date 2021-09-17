import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:bostyfield_app/screen/availabletimes.dart';
import 'package:bostyfield_app/screen/bookings.dart';
import 'package:bostyfield_app/screen/contactus.dart';
import 'package:bostyfield_app/screen/fieldaccess.dart';
import 'package:bostyfield_app/screen/myaccount.dart';
import 'package:bostyfield_app/screen/payment.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/style.dart';
import 'package:bostyfield_app/screen/home.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class NextAvailable extends StatefulWidget {
  @override
  _NextAvailableState createState() => _NextAvailableState();
}

class _NextAvailableState extends State<NextAvailable>{
  bool _isLoading = false;
  String? name;
  String? selecteddate;
  var email;
  var password;
  var fieldname;
  var booking;
  var fieldlist;
  var decodefieldlist;
  var data;
  var results;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> loadUserData() async{
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    fieldlist = localStorage.getString("fields");
    decodefieldlist = json.decode(fieldlist!);

    if(user != null) {
      setState(() {
        name = user['firstname'];
      });
    }

    this.setState(() {
      data = jsonDecode(decodefieldlist);
      print(data);
    });

    if(data.length == 0){
      results = 0;
    }
    setState(() {
      _isLoading = false;
    });

  }
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
  @override
  void initState(){
    super.initState();
    this.loadUserData();
    BackButtonInterceptor.add(myInterceptor);
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => Home()
      ),
    );// Do some stuff.
    return true;
  }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('BostyFields.co.uk',style: GoogleFonts.prompt(fontWeight: FontWeight.w500)),
            backgroundColor: Colors.green[600],
          ),
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
                          if(index==0){
                            fieldname = 'Wenlock Walk';
                          }
                          if(index==1){
                            fieldname = 'Linley Leap';
                          }
                          if(index==2){
                            fieldname = 'Fae';
                          }
                          if(index==3){
                            fieldname = 'Troll';
                          }
                          if(last){
                            return new Container(
                                margin: EdgeInsets.only(top: 30, left: 50, right: 50, bottom:150),
                                child: Column(
                                    children: <Widget>[
                                      Text('$fieldname', style: TextStyle(fontSize: 20)),
                                      GestureDetector(
                                        onTap: () => _selection(index, data[index]["field"]),
                                        child: Card(elevation: 4.0,
                                            color: Colors.green[600],
                                            child:
                                            Center(child:Container(
                                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                child: Text(
                                                    data[index]["field"], textAlign: TextAlign.center,
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
                                      ),
                                    ]

                                ),
                            );
                          }else{
                            return new Container(
                              margin: EdgeInsets.only(top: 30, left: 50, right: 50),
                              child: Column(
                                children: <Widget>[
                                  Text('$fieldname', style: TextStyle(fontSize: 20)),
                                  GestureDetector(
                                    onTap: () => _selection(index, data[index]["field"]),
                                    child: Card(elevation: 4.0,
                                        color: Colors.green[600],
                                        child:
                                        Center(child:Container(
                                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            child: Text(
                                                data[index]["field"], textAlign: TextAlign.center,
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
                                  ),
                                ]
                              ),
                            );
                          };
                        },
                      ),
                    ),
                  ])
          ),
        );
      }

void _selection(selectedfield, selecteddate) async{
    setState(() {
      _isLoading = true;
    });

    selectedfield = selectedfield+1;
    selectedfield = "$selectedfield";
    print(selectedfield);

    selecteddate = "$selecteddate";
    print(selecteddate);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('selectedfield', selectedfield);
    localStorage.setString('selecteddate', selecteddate!);


    var res = await Network().getPostData("/bookings/"+selectedfield+"/"+selecteddate!);
    var times = json.decode(res.body);
    var entimes = json.encode(res.body);

    print(entimes);

    localStorage.setString("times", entimes);

    // ignore: unnecessary_null_comparison
    if(json.encode(times) != null){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>AvailableTimes()));
    }else{
      _showMsg(times['message']);
    }

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
