import 'dart:convert';
import 'package:bostyfield_app/screen/home.dart';
import 'package:intl/intl.dart';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:bostyfield_app/screen/bookings.dart';
import 'package:bostyfield_app/screen/contactus.dart';
import 'package:bostyfield_app/screen/fieldaccess.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:bostyfield_app/screen/myaccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new EditBooking());
}
class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({required DateTime currentTime, required LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime;
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 0, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex())
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex());
  }
}

class EditBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bosty Fields App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
        backgroundColor: Colors.white,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: EditPage(),
    );
  }
}
class EditPage extends StatefulWidget {

  @override
  _EditPageState createState() => new _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? name;
  void initState(){
    super.initState();
    this._loadUserData();
  }
  Future<void> _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if(user != null) {
      setState(() {
        name = user['firstname'];
      });
    }
  }
  Future<void> _logout() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('services');
    localStorage.remove('access_token');
    localStorage.remove('token_type');
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>Login()));
  }
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.lightGreen[400],
            tabs: [
              Tab(text: 'Date'),
              Tab(text: 'Dogs'),
            ],
          ),
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
                  _logout();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DateTimeUpdate(),
            _Integer(),
          ],
        ),
      ),
    );
  }
}
class _Integer extends StatefulWidget {
  @override
  __IntegerState createState() => __IntegerState();
}
class __IntegerState extends State<_Integer> {
  bool _isLoading = false;
  bool messagecheck = false;
  int _currentIntValue = 1;
  var bookingid;
  var productname;
  var product;
  var message;
  var booking;
  void initState(){
    super.initState();
    this._loadDogData();
  }
  Future<void> _loadDogData() async{
    this.setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var editbooking = jsonDecode(localStorage.getString('editbooking')!);
    editbooking = jsonDecode(editbooking);
    if(editbooking != null) {
      setState(() {
        bookingid = editbooking['id'];
        productname = editbooking['productname'];
        product = editbooking['productname'].split(" ").first;
        _currentIntValue = int.parse(product);
      });
    }
    this.setState(() {
      _isLoading = false;
    });
  }
  Future<void> _updateDogBookingData(value) async{
    this.setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var editbooking = jsonDecode(localStorage.getString('editbooking')!);
    editbooking = jsonDecode(editbooking!);
    if(editbooking != null) {
      setState(() {
        bookingid = editbooking['id'];
        product = value;
        _currentIntValue = value;
      });
      var data = {
        'bookingid' : bookingid,
        'amountofdogs' : product,
      };
      var res = await Network().bookingData(data,context, '/editbooking');
      var body = json.decode(res.body);
      messagecheck = body['edit'] as bool;
      if(messagecheck==true){
        booking = json.encode(body['booking']);
        localStorage.setString('editbooking', json.encode(booking));
        setState(() {
          bookingid = body['booking']['id'];
          productname = body['booking']['productname'];
          product = _currentIntValue;
        });
        message = json.encode(body['message']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$message')));
      }else{
        message = json.encode(body['message']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$message')));
      }
      this.setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.green[600]!))) : Column(
      children: <Widget>[
        Card(
          color: Colors.white,
          margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
            child: Center(child:Container(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Column(
                children: <Widget>[
                  Text('Current Amount: $productname', style: Theme.of(context).textTheme.headline6),
                  NumberPicker(
                    value: _currentIntValue,
                    minValue: 1,
                    maxValue: 6,
                    step: 1,
                    haptics: true,
                    onChanged: (value) => setState(() => _currentIntValue = value),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => setState(() {
                          final newValue = _currentIntValue - 1;
                          _currentIntValue = newValue.clamp(1, 6);
                        }),
                      ),
                      Text('$_currentIntValue Dog(s)'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() {
                          final newValue = _currentIntValue + 1;
                          _currentIntValue = newValue.clamp(1, 6);
                        }),
                      ),
                    ],
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () => _updateDogBookingData(_currentIntValue),
                    child: Card(
                      color: Colors.green[600],
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child:
                      Center(child:Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Update", textAlign: TextAlign.center,
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
      ],
    );
  }
}

class _DateTimeUpdate extends StatefulWidget {
  @override
  __DateTimeUpdateState createState() => __DateTimeUpdateState();
}
class __DateTimeUpdateState extends State<_DateTimeUpdate> {
  bool _isLoading = false;
  bool messagecheck = false;
  void initState(){
    super.initState();
    this._loadDateData();
  }
  var message;
  var bookingdate;
  var bookingtime;
  var datetime;
  var values;
  var updatedate;
  var _selectedTime;
  var _selectedDate;
  var bookingid;
  var booking;
  Future<void> _loadDateData() async{
    this.setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var editbooking = jsonDecode(localStorage.getString('editbooking')!);
    editbooking = jsonDecode(editbooking);
    if(editbooking != null) {
      setState(() {
        final split = editbooking['datetime'].split(' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        datetime = DateTime.tryParse(editbooking['datetime']);
        bookingdate = values[0];
        bookingtime = values[1];
      });
    }
    this.setState(() {
      _isLoading = false;
    });
  }
  Future<void> _updateDateBookingData(bookingdate, bookingtime) async {
    datetime = bookingdate + ' ' + bookingtime;
    datetime = DateTime.tryParse(datetime);
    updatedate = datetime.toString();
    this.setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var editbooking = jsonDecode(localStorage.getString('editbooking')!);
    editbooking = jsonDecode(editbooking!);
    if (editbooking != null) {
      setState(() {
        bookingid = editbooking['id'];
        final split = editbooking['datetime'].split(' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        datetime = DateTime.tryParse(editbooking['datetime']);
        bookingdate = values[0];
        bookingtime = values[1];
      });
      var data = {
        'bookingid': bookingid,
        'datetime': updatedate,
      };
      var res = await Network().bookingData(data,context, '/editbooking');
      var body = json.decode(res.body);
      messagecheck = body['edit'] as bool;
      if (messagecheck == true) {
        booking = json.encode(body['booking']);
        localStorage.setString('editbooking', json.encode(booking));
        setState(() {
          bookingid = body['booking']['id'];
        });
        message = json.encode(body['message']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$message')));
      } else {
        message = json.encode(body['message']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$message')));
      }
      this.setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _cancelBooking() async{
    this.setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var editbooking = jsonDecode(localStorage.getString('editbooking')!);
    editbooking = jsonDecode(editbooking);
    if(editbooking != null) {
        var data = {
          'bookingid' : editbooking['id'],
        };
        var res = await Network().bookingData(data,context, '/deletebooking');
        var body = json.decode(res.body);
        messagecheck = body['refund'] as bool;
        if(messagecheck==true){
          message = json.encode(body['message']);
          localStorage.setString('refundmessage', message!);
        }
    }
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => Bookings()
      ),
    );
    this.setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.green[600]!))) : Column(
      children: <Widget>[
        Card(
          color: Colors.white,
          margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
          child:
          Center(child:Container(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Column(
                children: <Widget>[
                  Text('$bookingdate', style: TextStyle(
                    fontSize: 22.0,
                    height: 1.2,
                  ),),
                  GestureDetector(
                    onTap: () => DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2021, 8, 1),
                        maxTime: DateTime(2021, 12, 31),
                        onConfirm: (date) {
                          setState(() {
                            _selectedDate = DateFormat("yyyy-MM-dd").format(date);
                            bookingdate = _selectedDate;
                          });
                        }, currentTime: datetime, locale: LocaleType.en),
                    child: Card(
                      color: Colors.green[600],
                      margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
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
                  Text('$bookingtime', style: TextStyle(
                    fontSize: 22.0,
                    height: 1.2,
                  ),),
                  GestureDetector(
                    onTap: () => DatePicker.showPicker(context, showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            _selectedTime = DateFormat("HH:mm:ss").format(date);
                            bookingtime = _selectedTime;
                          });
                        }, pickerModel: CustomPicker(currentTime: datetime, locale: LocaleType.en)),
                    child: Card(
                      color: Colors.green[600],
                      margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
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
                  Divider(),
                  GestureDetector(
                    onTap: () =>   _updateDateBookingData(bookingdate, bookingtime),
                    child: Card(
                      color: Colors.green[600],
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
                      child:
                      Center(child:Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Update", textAlign: TextAlign.center,
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
                  Divider(),
                  GestureDetector(
                    onTap: () =>   _cancelBooking(),
                    child: Card(
                      color: Colors.green[600],
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child:
                      Center(child:Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Cancel Booking", textAlign: TextAlign.center,
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
                ]
            ),
          ),
          ),
        ),
      ],
    );
  }

}