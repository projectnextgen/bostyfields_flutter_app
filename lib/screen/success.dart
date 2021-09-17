import 'dart:core';
import 'dart:convert';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:bostyfield_app/screen/bookings.dart';
import 'package:bostyfield_app/screen/contactus.dart';
import 'package:bostyfield_app/screen/fieldaccess.dart';
import 'package:bostyfield_app/screen/myaccount.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:bostyfield_app/screen/home.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
class Success extends StatefulWidget {
  @override
  _SuccessState createState() => _SuccessState();
}
class _SuccessState extends State<Success>{
bool _isLoading = false;
final _formKey = GlobalKey<FormState>();
var email;
final _scaffoldKey = GlobalKey<ScaffoldState>();
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
  _loadUserData();
}
String? name;
String? bookingreference;
String? paymentreference;
var booking;
var data;
_loadUserData() async{
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var user = jsonDecode(localStorage.getString('user')!);
  var booking = jsonDecode(localStorage.getString('booking')!);

if(user != null) {
  setState(() {
    name = user['firstname'];
  });
}

if(booking != null) {
  setState(() {
    bookingreference = booking['bookingreference'];
    paymentreference = booking['paymentreference'];
  });
}

}
final _htmlContent = """
    <div class='col-lg-12 p-0 border bookingcolumn'>
      <div class='serviceimagecontainer'>							
          <div class="pb-4 border-bottom">
            <h1>BOOKING COMPLETE</h1>                                                                                                                                                                                                                                                      </h2></h2>
          </div>
          <div class="pb-4 border-bottom">
            <h2><bookingreference></bookingreference></h2>                                                                                                                                                                                                                                                      </h2></h2>
          </div>	
          <div class="pb-4 border-bottom">
            <h2>PAYMENT REF:</h2>
            <h3><paymentreference></paymentreference></h3>                                                                                                                                                                                                                                                      </h2></h2>
          </div>  				  
      </div>
  """ ;
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
        child: SingleChildScrollView(
          child: Html(
            data: _htmlContent,
            onLinkTap: (selectedfield, _, __, ___){
              _isLoading = true;
              _selection(selectedfield);
            },
            customRender: {
              "bookingreference": (RenderContext context, Widget child) {
                return TextSpan(text: "$bookingreference");
              },
              "paymentreference": (RenderContext context, Widget child) {
                return TextSpan(text: "$paymentreference");
              },
            },
            tagsList: Html.tags..addAll(["bookingreference", "paymentreference"]),
            // Styling with CSS (not real CSS)
            style: {
              'html': Style(
                backgroundColor: Colors.white38,
              ),
              'h1': Style(
                  color: Colors.white,
                  fontSize: FontSize(24.0),
                  fontWeight: FontWeight.w700
              ),
              'h2': Style(
                  color: Colors.white,
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.w700
              ),
              'h3': Style(
                  color: Colors.white,
                  fontSize: FontSize.large
              ),
              'a': Style(
                color: Colors.white,
                fontSize: FontSize.large,
                textDecoration: TextDecoration.none,
              ),
              'p': Style(
                  color: Colors.black87,
                  fontSize: FontSize.large
              ),
              '.bookingcolumn': Style(
                  textAlign: TextAlign.center,
                  fontSize: FontSize.large
              ),
              '.serviceimagecontainer': Style(
                textAlign: TextAlign.center,
                fontSize: FontSize.large,
                color: Colors.black87,
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.all(20),
              ),
              '.serviceimagecontainer1': Style(
                textAlign: TextAlign.center,
                fontSize: FontSize.large,
                backgroundColor: Colors.lightGreen,
                padding: EdgeInsets.all(20),
              ),
              '.serviceimagecontainer2': Style(
                textAlign: TextAlign.center,
                fontSize: FontSize.large,
                backgroundColor: Colors.green[400],
                padding: EdgeInsets.all(20),
              ),
              '.button': Style(
                textAlign: TextAlign.center,
                fontSize: FontSize.large,
                backgroundColor: Colors.green[600],
                color: Colors.white,
                fontWeight: FontWeight.bold,
                padding: EdgeInsets.all(1),
                margin: EdgeInsets.only(top:20, left: 50, right: 50, bottom: 0),
              ),
            },
          ),
        ),
      ),
    );
  }
void _selection(selectedfield) async{
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = false;
    });

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