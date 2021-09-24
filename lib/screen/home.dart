import 'dart:async';
import 'dart:convert';
import 'package:bostyfield_app/screen/contactus.dart';
import 'package:bostyfield_app/screen/fieldaccess.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/style.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bostyfield_app/screen/nextavailable.dart';
import 'package:bostyfield_app/screen/bookings.dart';
import 'package:bostyfield_app/screen/myaccount.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home>{
  bool _isLoading = false;
  String? name;
  var email;
  var password;
  var data;
  var results;
  var servicelist;
  var decodeservicelist;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> loadUserData() async{
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    servicelist = localStorage.getString("services");
    if(user != null) {
      setState(() {
        name = user['firstname'];
      });
      if(servicelist == null) {
        var res = await Network().getPostData("/services");
        var services = json.encode(res.body);
        localStorage.setString("services", services);
        servicelist = localStorage.getString("services");
      }
      decodeservicelist = json.decode(servicelist!);
      this.setState(() {
        data = jsonDecode(decodeservicelist);
      });
      if(data.length == 0){
        results = 0;
      }
      setState(() {
        _isLoading = false;
      });
    }
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
                              onTap: () => _selection(data[index]["service"]),
                              child: Card(elevation: 4.0,
                                  color: Colors.green[600],
                                  margin: EdgeInsets.only(top: 30, left: 100, right: 100, bottom:150),
                                  child:
                                  Center(child:Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: new Text(
                                        data[index]["service"], textAlign: TextAlign.center,
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
                              onTap: () => _selection(data[index]["service"]),
                              child: Card(elevation: 4.0,
                                  color: Colors.green[600],
                                  margin: EdgeInsets.only(top: 30, left: 100, right: 100),
                                  child:
                                  Center(child:Container(
                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: Text(
                                          data[index]["service"], textAlign: TextAlign.center,
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
                  ])
          ),
        );
      }
    void _selection(selecteddogs) async{
    setState(() {
      _isLoading = true;
    });
    selecteddogs = selecteddogs.split(" ").first;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('selecteddogs', selecteddogs);
    var res = await Network().getPostData("/nextbookings");
    var fields = json.encode(res.body);
    localStorage.setString("fields", fields);
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => NextAvailable()
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }
    void logout() async{
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('services');
      localStorage.remove('access_token');
      localStorage.remove('token_type');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
  }
}