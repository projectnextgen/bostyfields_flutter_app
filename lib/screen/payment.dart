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
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:bostyfield_app/.env.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bostyfield_app/.env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //imp line need to be added first
  FlutterError.onError = (FlutterErrorDetails details) {
    //this line prints the default flutter gesture caught exception in console
    //FlutterError.dumpErrorToConsole(details);
    print("Error From INSIDE FRAME_WORK");
    print("----------------------");
    print("Error :  ${details.exception}");
    print("StackTrace :  ${details.stack}");
  };
  runApp(new PaymentScreen());
}

class PaymentScreen extends StatefulWidget {
  @override
  PaymentScreenState createState() => new PaymentScreenState();
}
// payment_screen.dart
class PaymentScreenState extends State<PaymentScreen>{
  bool _isLoading = false;
  int? bookingid;
  String? name;
  String? email;
  String? amount;
  String? fieldname;
  String? productname;
  String? datetime;
  String? message;
  var paymentMethod;
  var booking;
  var data;
  var user;
  var error;
  var _enabled = true;
  var paymentIntent;
  CardDetails _card = CardDetails();
  final _formKey = GlobalKey<FormState>();
  Future<String> getData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    user = jsonDecode(localStorage.getString('user')!);
    booking = jsonDecode(localStorage.getString('booking')!);
    var messagecheck = localStorage.getString('outstandingamount');
    if(messagecheck != null) {
      var message = localStorage.getString('outstandingamount')!;
      _showMsg(message);
      localStorage.remove('outstandingamount');
    }
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
              ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
            key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          maxLength: 16,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(hintText: 'Card Number'),
                          onChanged: (number) {
                            setState(() {
                              _card = _card.copyWith(number: number);
                            });
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        width: 80,
                        child: TextFormField(
                          maxLength: 2,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(hintText: 'Exp. Mth'),
                          onChanged: (number) {
                            setState(() {
                              _card = _card.copyWith(
                                  expirationMonth: int.tryParse(number));
                            });
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                              return null;
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        width: 80,
                        child: TextFormField(
                          maxLength: 2,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(hintText: 'Exp. Year'),
                          onChanged: (number) {
                            setState(() {
                              _card = _card.copyWith(
                                  expirationYear: int.tryParse(number));
                            });
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        width: 80,
                        child: TextFormField(
                          maxLength: 3,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(hintText: 'CVC'),
                          onChanged: (number) {
                            setState(() {
                              _card = _card.copyWith(cvc: number);
                            });
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                            },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child:
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                        _isLoading = true;
                        }),
                        if (_formKey.currentState!.validate()) {
                          handlePayPress(),
                        }else{
                          setState(() {
                            _isLoading = false;
                          }),
                        },
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.green[600],
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                        margin: EdgeInsets.only(top: 25, left: 30, right: 30),
                        child:
                        Center(child:Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                _isLoading ? "Processing" : "Pay" , textAlign: TextAlign.center,
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
                  ),
                  Row(
                    children: [
                        Expanded(child: Image.asset("assets/images/acceptedcards.png")),
                      ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setError(error) {
    _showMsg(error);
    setState(() {
      _isLoading = false;
    });
  }
  Future<void> handlePayPress() async {

    await Stripe.instance.dangerouslyUpdateCardDetails(_card);

    try {
      Stripe.publishableKey = stripePublishableKey;
      final paymentMethod =
      await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
      ));
      paymentIntent = confirmIntent(paymentMethod);
      print(paymentIntent);
      return;
    } on StripeException catch (e) {
      message = e.error.message.toString();
      error = e.error.stripeErrorCode.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $message')));
      setState(() {
        _isLoading = false;
      });
      return error;
    }
  }
  Future<void> confirmIntent(paymentMethod) async {
    print(paymentMethod.id);
    var data = {
      'id': paymentMethod.id,
      'bookingid': bookingid,
      'amount': amount,
    };
    var res = await Network().sendPayment(data, '/payment');
    var result = json.decode(res.body);
    if (result['success'] == true) {
      print(result);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('booking', json.encode(result['booking']));
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Success()
        ),
      );
    }
    if (result['success'] == false){
      print(result);
      error = result['error'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
      setState(() {
        _isLoading = false;
      });
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
