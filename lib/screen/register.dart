import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:bostyfield_app/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:bostyfield_app/screen/termsandconditions.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var firstname;
  var lastname;
  var contactnumber;
  var token;
  bool agree = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
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
  @override
  void initState(){
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.lightGreen[600],
        child: Stack(
        children: <Widget>[
          Material(
            child: Container(
              color: Colors.lightGreen[600],
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            elevation: 4.0,
                            color: Colors.white,
                            margin: EdgeInsets.only(top:70, left: 20, right: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextFormField(
                                      style: TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (emailValue) {
                                        if (emailValue!.isEmpty) {
                                          return 'Please enter email';
                                        }
                                        email = emailValue;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.insert_emoticon,
                                          color: Colors.grey,
                                        ),
                                        hintText: "First Name",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (fname) {
                                        if (fname!.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        firstname = fname;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.insert_emoticon,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Last Name",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (lname) {
                                        if (lname!.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        lastname = lname;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Phone",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (phonenumber) {
                                        contactnumber = phonenumber;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (passwordValue) {
                                        if (passwordValue!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        password = passwordValue;
                                        return null;
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5, right:5),
                                          child: Checkbox(
                                            value: agree,
                                            onChanged: (value) {
                                              setState(() {
                                                agree = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) => Termsandconditions()));
                                            },
                                            child: Text(
                                              'I accept the terms and conditions.',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: FlatButton(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8, left: 10, right: 10),
                                          child: Text(
                                            _isLoading? 'Processing...' : 'Register',
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        color: Colors.lightGreen[600],
                                        disabledColor: Colors.grey,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                            new BorderRadius.circular(20.0)),
                                        onPressed: () {
                                          if (agree && _formKey.currentState!.validate()) {
                                              _register();
                                          }else{
                                            _showMsg('You need to accept the terms and conditions.');
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                'Already Have an Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _register()async{
    setState(() {
      _isLoading = true;
    });

    token = await FirebaseMessaging.instance.getToken();

    var data = {
      'email' : email,
      'password': password,
      'contactnumber': contactnumber,
      'firstname': firstname,
      'lastname': lastname,
      'token' : token,
    };

    var res = await Network().authData(data, '/register');
    var body = json.decode(res.body);
    if(body['success']==true){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('access_token', json.encode(body['access_token']));
      localStorage.setString('token_type', json.encode(body['token_type']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Home()
        ),
      );
    }else{
      var email = body['email']?[0];
      if(email!=null){
        _showMsg(body['email'][0]);
      };
      var firstname = body?['firstname']?[0];
      if(firstname!=null){
        _showMsg(body['firstname'][0]);
      };
      var lastname = body?['lastname']?[0];
      if(lastname!=null){
        _showMsg(body['lastname'][0]);
      };
      var contactnumber = body?['contactnumber']?[0];
      if(contactnumber!=null){
        _showMsg(body['contactnumber'][0]);
      };
      var password = body?['password']?[0];
      if(password!=null){
        _showMsg(body['password'][0]);
      };
    }
    setState(() {
      _isLoading = false;
    });
  }
}