// main.dart
import 'dart:async';
import 'dart:convert';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:bostyfield_app/screen/bookings.dart';
import 'package:bostyfield_app/screen/contactus.dart';
import 'package:bostyfield_app/screen/fieldaccess.dart';
import 'package:bostyfield_app/screen/myaccount.dart';
import 'package:bostyfield_app/screen/success.dart';
import 'package:bostyfield_app/screen/home.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:bostyfield_app/.env.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  @override
  PaymentScreenState createState() => new PaymentScreenState();
}
// payment_screen.dart
class PaymentScreenState extends State<PaymentScreen>{
  bool _isLoading = false;
  bool _validcard = false;
  int? bookingid;
  String? name;
  String? email;
  String? amount;
  String? fieldname;
  String? productname;
  String? datetime;
  String? booking;
  var paymentMethod;
  var data;

  Future<String> getData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    var booking = jsonDecode(localStorage.getString('booking')!);
    if(user != null) {
      setState(() {
        name = user['firstname'];
        email = user['email'];
      });
    }
    if(booking != null) {
      setState(() {
        bookingid = booking['id'];
        fieldname = booking['fieldname'];
        productname = booking['productname'];
        datetime = booking['datetime'];
        amount = booking['amount'];
      });
    }
    setState(() {
      _isLoading = false;
    });
    return "Success!";
  }
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
    this.getData();
  }

  void setError(error) {
    _showMsg(error);
    setState(() {
      _isLoading = false;
    });
  }
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
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Home()
                  ),
                );
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

      body: _isLoading ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.green[600]!))) : Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 15, bottom:5.0),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text(
                    name ?? "Name", textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize:18.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    email ?? "Email", textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize:18.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              )
          ),
          Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text(
                    fieldname ?? "Field Name", textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize:18.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    productname ?? "Product Name", textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize:18.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    datetime ?? "Date & Time", textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize:18.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    "£ $amount", textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize:18.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              )
          ),
          Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CardField(
                    onCardChanged: (card) {
                      print(card!.complete);
                      if(card.complete == true){
                        _validcard = true;
                      }else{
                        _validcard = false;
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      if(_validcard == true) {
                        WidgetsFlutterBinding.ensureInitialized();
                        Stripe.publishableKey = stripePublishableKey;
                        final paymentMethod =
                        await Stripe.instance.createPaymentMethod(PaymentMethodParams.card());
                        var data = {
                          'id': paymentMethod.id,
                          'bookingid': bookingid,
                          'amount': amount,
                        };
                        processpayment(data);
                      }else{
                        setState(() {
                          _isLoading = false;
                        });
                        _showMsg('Please complete the card details');
                      };
                    },
                    child: Text('Pay',  style: TextStyle(
                      color: Colors.green,
                      fontSize:20.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/stripe.png'
                      ),
                    ]
                  )
                ],
              )
          )
        ],
      ),
    );
  }

void processpayment(data) async {
    setState(() {
      _isLoading = true;
    });
    var res = await Network().sendPayment(data, '/payment');
    var result = json.decode(res.body);
    if (result['success'] == true) {
      print(json.encode(result['booking']));
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('booking', json.encode(result['booking']));
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Success()
        ),
      );
    }else{
      _isLoading = false;
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
