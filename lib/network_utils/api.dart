import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bostyfield_app/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final String _url = 'https://bostyfields.co.uk/api';
  var token;

  authData(data, apiUrl) async{
    var fullUrl = _url + apiUrl;
    return await http.post(
        (Uri.parse(fullUrl)),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  bookingData(data,context, apiUrl) async{
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.getString('access_token') == null) {
      return Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }else{
      var token = jsonDecode(localStorage.getString('access_token')!);
      return await http.post(
          (Uri.parse(fullUrl)),
          body: jsonEncode(data),
          headers: {    'Content-type' : 'application/json',
            'Accept' : 'application/json',
            'Authorization' : 'Bearer $token'}
      );
    }
  }

  getPostData(context, apiUrl) async {
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.getString('access_token') == null) {
      return Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }else{
      var token = jsonDecode(localStorage.getString('access_token')!);
      return await http.post(
          (Uri.parse(fullUrl)),
          headers: {    'Content-type' : 'application/json',
            'Accept' : 'application/json',
            'Authorization' : 'Bearer $token'}
      );
    }
  }

  sendPayment(data, context, apiUrl) async{
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.getString('access_token') == null) {
      return Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }else{
      var token = jsonDecode(localStorage.getString('access_token')!);
      return await http.post(
          (Uri.parse(fullUrl)),
          body: jsonEncode(data),
          headers: {    'Content-type' : 'application/json',
            'Accept' : 'application/json',
            'Authorization' : 'Bearer $token'}
      );
    }
  }

  myaccount(data, apiUrl) async{
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('access_token')!);
    return await http.post(
        (Uri.parse(fullUrl)),
        body: jsonEncode(data),
        headers: {    'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'}
    );
  }
  userbookings(context, apiUrl) async{
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.getString('access_token') == null) {
      return Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }else{
      var token = jsonDecode(localStorage.getString('access_token')!);
      return await http.post(
          (Uri.parse(fullUrl)),
          headers: {    'Content-type' : 'application/json',
            'Accept' : 'application/json',
            'Authorization' : 'Bearer $token'}
      );
    }
  }
  userbooking(data, context, apiUrl) async{
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.getString('access_token') == null) {
      return Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }else{
      var token = jsonDecode(localStorage.getString('access_token')!);
      return await http.post(
          (Uri.parse(fullUrl)),
          body: jsonEncode(data),
          headers: {    'Content-type' : 'application/json',
            'Accept' : 'application/json',
            'Authorization' : 'Bearer $token'}
      );
    }
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

}