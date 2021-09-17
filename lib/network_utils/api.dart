import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final String _url = 'https://bostyfields.co.uk/api';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('access_token')!);
    return token;
  }

  authData(data, apiUrl) async{
    var fullUrl = _url + apiUrl;
    return await http.post(
        (Uri.parse(fullUrl)),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  bookingData(data, apiUrl) async{
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

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
        (Uri.parse(fullUrl)),
        headers: _setHeaders()
    );
  }

  getPostData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('access_token')!);
    return await http.post(
        (Uri.parse(fullUrl)),
        headers: {    'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'}
    );
  }

  sendPayment(data, apiUrl) async{
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('access_token')!);
    return await http.post(
        (Uri.parse(fullUrl)),
        body: jsonEncode(data),
        headers: {'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'}
    );
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
  userbookings(apiUrl) async{
    var fullUrl = _url + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('access_token')!);
    return await http.post(
        (Uri.parse(fullUrl)),
        headers: {    'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'}
    );
  }
  userbooking(data, apiUrl) async{
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
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

}