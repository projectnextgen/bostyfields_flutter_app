import 'dart:convert';
import 'package:bostyfield_app/screen/contactus.dart';
import 'package:bostyfield_app/screen/editbooking.dart';
import 'package:bostyfield_app/screen/fieldaccess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:bostyfield_app/screen/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:bostyfield_app/screen/termsandconditions.dart';

import 'myaccount.dart';
class Bookings extends StatefulWidget {
  @override
  _BookingsState createState() => _BookingsState();
}
class _BookingsState extends State<Bookings> {
  bool _isLoading = false;
  var data;
  var results;

  Future<String> getData() async {
    this.setState(() {
      _isLoading = true;
    });
    var res = await Network().userbookings('/userbookings');
    var body = json.encode(res.body);
    this.setState(() {
      data = json.decode(body);
      data = json.decode(data);
    });
    if(data.length == 0){
      results = 0;
    }
    this.setState(() {
      _isLoading = false;
    });
    return "Success!";
  }
  Future<void> _showMsg(msg) async {
    final SnackBar snackBar = SnackBar(
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    this.getData();
    this._loadUserData();
  }
  String? name;

  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    var message = localStorage.getString('refundmessage');
    if(user != null) {
      setState(() {
        name = user['firstname'];
      });
    }
    if(message != null) {
      var message = localStorage.getString('refundmessage')!;
      _showMsg(message);
      localStorage.remove('refundmessage');
    }
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
        child: _isLoading ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.green[600]!))) : Stack(
        children: <Widget>[
          Material(
            child: results == 0 ? Card(margin: EdgeInsets.only(top: 30, left: 30, right: 30),child:Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text('There are no applicable bookings for this account. Make a booking today.',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 20.0,
                height: 1.2,
              )))) : new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index){
                return new Column(
                children: [
                  Card(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
                    child:
                    Center(child:Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            data[index]["fieldname"], textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            data[index]["productname"], textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            "£"+data[index]["amount"], textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            data[index]["datetime"], textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              height: 1.2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => getBookingData(data[index]["id"]),
                            child: Card(
                              color: Colors.green[600],
                              margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
                              child:
                              Center(child:Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Edit", textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ),
                            ),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future<String> getBookingData(id) async {
    this.setState(() {
      _isLoading = true;
    });
    var data = {
      'bookingid' : id,
    };
    var res = await Network().userbooking(data, '/userbooking');
    var body = json.encode(res.body);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('editbooking', body);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>EditBooking()));

    return "Success!";
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


