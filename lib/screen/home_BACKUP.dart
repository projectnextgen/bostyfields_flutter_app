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
  _startLoading() {
    setState(() {
      _isLoading = true;
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
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
    setState(() {});
    _startLoading();
    _loadUserData();
  }

  String? name;

  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);

    if(user != null) {
      setState(() {
        name = user['firstname'];
      });
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
                    color: Colors.lightGreen,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/drawerimage.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Text('Hi, $name', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                ListTile(
                  title: Text('Book a Walk'),
                  onTap: () {
                    Navigator.pop(context);
                  },
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
              child: _isLoading ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.green[600]!))) : SingleChildScrollView(
                child: Html(
                  data: _htmlContent,
                  onLinkTap: (selecteddogs, _, __, ___){
                    _selection(selecteddogs);
                  },
                  // Styling with CSS (not real CSS)
                  style: {
                    'html': Style(
                        backgroundColor: Colors.white38,
                    ),
                    'h1': Style(
                        color: Colors.black87,
                        fontSize: FontSize.large
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
void _selection(selecteddogs) async{
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('selecteddogs', selecteddogs);

    var res = await Network().getPostData("/nextbookings");
    var body = json.decode(res.body);
    // ignore: unnecessary_null_comparison
    if(json.encode(body['id']) != null){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('field1', json.encode(body['field1']));
      localStorage.setString('field2', json.encode(body['field2']));
      localStorage.setString('field3', json.encode(body['field3']));
      localStorage.setString('field4', json.encode(body['field4']));

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => NextAvailable()
        ),
      );


    }else{
      print('No Internet Connection');
      _showMsg('No Internet Connection');
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
final _htmlContent = """
      <div class="col-lg-12 p-0 border bookingcolumn">
      	<div class='serviceimagecontainer'>							
					  <div class="pb-4 border-bottom">
						  <h2>SELECT THE NUMBER OF DOGS</h2>
					  </div>
				</div>
				<div class='serviceimagecontainer1'>	
					  <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">							
					  <a href="1">
              <div class="button">
                <h3>1 Dog</h3>
              </div>
					  </a>
				</div>
				<div class='serviceimagecontainer2'>	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">		
            <a href="2">
              <div class="button">
                <h3>2 Dogs</h3>
              </div>
            </a>
				</div>

				<div class='serviceimagecontainer1'>								
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">
            <a href='3'>							
              <div class="button">
                <h3>3 Dogs</h3>
              </div>
            </a>
				</div>

				<div class="serviceimagecontainer2">
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">
            <a href='4'>		
              <div class="button">
                <h3>4 Dogs</h3>
              </div>
            </a>
				</div>

				<div class="serviceimagecontainer1">
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">							
            <a href='5'>
              <div class="button">
                <h3>5 Dogs</h3>
              </div>
            </a>
				</div>

				
				<div class='serviceimagecontainer2'>
					<div class="pt-2">		
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
            <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
					</div>
				  <a href='6'>
            <div class="button">
              <h3>6 Dogs</h3>
            </div>
					</a>
				</div>

				<div class='serviceimagecontainer1'>
					<div class="plusimagecontainer">		
              <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
              <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
              <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
              <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
              <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	
              <img class="serviceimage" src="asset:assets/images/logo_small.png" alt="logo">	             
					</div>
					<a href='7'>
            <div class="button">
              <h3>6+ Dogs</h3>
            </div>
					</a>	
				</div>			
			</div>
    """;