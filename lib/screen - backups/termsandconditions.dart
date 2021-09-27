import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bostyfield_app/network_utils/api.dart';
import 'package:bostyfield_app/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bostyfield_app/screen/login.dart';
import 'package:bostyfield_app/screen/register.dart';

class Termsandconditions extends StatefulWidget {
  @override
  _TermsandconditionsState createState() => _TermsandconditionsState();
}

class _TermsandconditionsState extends State<Termsandconditions> {
  bool _isLoading = false;

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bosty Fields App',
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 2000,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 200),
                  child: Center(
                    child: Text('BOSTY FIELDS TERMS AND CONDITIONS.'
                        '\n \nThese Terms and Conditions are in place to protect the interests of everyone using our fields - to protect other users dogs, their children and everyones’ stress free enjoyment of the fields.\n \nWe require all users of the fields to agree to our Terms and Conditions prior to making their first booking. We will meet each new customer at the gate entrance at the booked time to ensure agreement with these Terms and Conditions. Entry to the fields ahead of this meeting is strictly forbidden and could lead to an immediate ban.\n \n 1. Entering/Leaving the fields\nPlease do not arrive early for your booking. We have allowed 10 minutes between bookings to allow for site inspections, free flow of traffic in and out of the fields and to avoid congestion on the access road.On arrival, stop on the tarmac, walk to the gate and check that the field is empty. Unlock the gate with your code, which you will have received on the day of your booking, taking great care with the locks. Please do not drop the locks on the floor or place in your vehicle.Please drive onto the car park: you are not permitted to drive on the grass. Please lock the gate behind you before getting your dog out of the car and keep the gate locked at all times whilst you are in the field.Your booking is 50 minutes long, do not stay beyond this and please lock the gate when you leave. If you arrive late for your booking, you cannot extend your allotted time, you must still leave on time ie 10 to the hour in Wenlock and 5 past the hour in Linley.You must not allow anyone else to drive into the car park whilst you are in the field or allow anyone else to enter the field, even if you are leaving. As owners, we will not enter the field whilst you are in there unless there is an urgent need – this ensures your quiet, undisturbed enjoyment.Please note there is only planning permission for TWO cars to be parked in each field.\n \n2. Inside the Fields\nALL users must remove dog poop after their dogs have used the fields. We provide four dog poop bins per field and free poop bags. Place all dog poop in the GREEN bins provided, normal litter in the BLACK bins on the car park. There are zero excuses for leaving the field dirty and users can be banned for neglecting this rule.Please do not allow children or dogs to climb the fences. Our fences are checked regularly to ensure safety and security of the fields, which is of prime importance to the majority of users.During winter we provide a field shelter for inclement weather, please ensure you do not damage the shelter or its contents.Water is available on site but should be restricted to use on the gravel area provided to prevent mud forming. Please only use the hose over the gravel area.Please discourage your dog from digging the grass. We have provided digging areas in both fields and digging should be restricted to these areas.No work will be carried out by us inside the field without your prior consent, during your slot.\n \n3. Booking\nBooking can only be made via our website at www.bostyfields.co.uk Registration requires your FIRST and LAST names. Any problems with registration or making a booking can be reported to us via our phone on 07501 349292 or by private message on our Facebook page - Bosty Fields : Secure Dog Park Bookings are not transferable. The person making the booking must be present at all times during the booking and must ensure anyone else attending signs a copy of our Terms and Conditions prior to using the fields. No sub letting of the fields is allowed. Please do not bring more dogs than you have booked for without prior agreement with Sara or Dave.\n \n4. Payment\nPayment can only be made via the website. Refunds will only be given if you cancel more than 24 hours prior to your booked time. Cash will only be taken when you have arrived with more dogs than you have booked for, subject to prior agreement with Sara or Dave.\n \n5. Cancellation Policy\n 24 hours notice is required for all cancellations to receive an automatic refund. This allows us to offer the slot for other customers. Cancellations more than 24 hours ahead of the booked time are made by you in your bookings page on the website. Refunds for cancellations with less than 24 hours notice are at our discretion. \n \n 6. Liability \n No responsibility will be taken by the land owner for damage or injury sustained to property, individuals or animals whilst using the fields or on the property. All vehicles parked on the property are left entirely at the owners risk. No responsibility for damage or accidents will be taken by Bosty Fields. \n \n Any breakages or damage to the field and fences will be paid for by the dog owner. All dogs using Bosty Fields must be fully up to date with booster vaccinations. Users of the facility must ensure they do not bring their dog if they are sick or have a communicable disease.As owners and operators of the facility we reserve the right to refuse admission at any time. Anyone caught in breach of these terms and conditions may be subject to sanctions. We operate a three strike rule, if you reach three strikes you will be banned from using our facility for a minimum of three months.We operate this system to protect the interests of everyone using our fields - to protect other users dogs, their children and everyones’ enjoyment of the fields.'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

