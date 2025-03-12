// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, must_be_immutable, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jjcentre/controller/eventdetails_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/home_screen.dart';
import 'package:jjcentre/screen/memberprofilescreen.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:http/http.dart' as http;
import 'package:qr/qr.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller/eventdetails_controller1.dart';
import '../controller/login_controller.dart';
import '../model/BhogResponse.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../utils/QR.dart';
import '../utils/scanqr_code.dart';
import 'FamilyGuestTable.dart';

class TicketBookingScreenAdmin extends StatefulWidget {
  const TicketBookingScreenAdmin({super.key});

  @override
  State<TicketBookingScreenAdmin> createState() => _TicketDetailsScreenState();
}

var eIndex;

class _TicketDetailsScreenState extends State<TicketBookingScreenAdmin>
    with WidgetsBindingObserver {
  EventDetailsController1 eventDetailsController = Get.find();
  LoginController loginController = Get.find();
  var total = 0.0;
  int totalTicket = 0;
  int currentIndex = 0;
  String eventId = Get.arguments["eventId"];
  String date = Get.arguments["date"];
  String bhogid = Get.arguments["bhogid"];
  String alloption = Get.arguments["alloption"];
  String eventName = Get.arguments["eventName"];
  String memberprice = Get.arguments["memberprice"];
  String guestsprice = Get.arguments["guestsprice"];
  String textname = Get.arguments["textname"];
  String maxmember = Get.arguments["maxmember"];
  String maxguest = Get.arguments["maxguest"];
  String eventStatus = Get.arguments["eventStatus"];
  bool isPaid = false;
  int allowedMember = 0;
  int allowedGuset = 0;
  int familyCount = 0;
  int guestCount = 0;
  int guestAddCount = 0;
  bool isAddVisible = false;
  bool isVisible = true;
  int ticketCount = 0;
  int ticketCountGuest = 0;
  int totalFamilyAmount = 0;
  int totalGuestAmount = 0;
  int totalAddGuestAmount = 0;
  int familyMemberCount = 1;
  String totalAmount = "0";
  String totalAddAmount = "0";
  BhogResponse responseData = BhogResponse(
      familyList: [], responseCode: '', result: '', responseMsg: '');

  void _incrementCounter() {
    setState(() {
      //if (familyCount < allowedMember) {
        familyCount++;
     // }

      totalFamilyAmount = familyCount * int.parse(memberprice);

      int totalAmountInt = totalFamilyAmount;
      totalAmount = totalAmountInt.toString();
      //isVisible= true;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (familyCount > 0) {
        familyCount--;
      }
      totalFamilyAmount = familyCount * int.parse(memberprice);

      int totalAmountInt = totalFamilyAmount;
      totalAmount = totalAmountInt.toString();
    });
  }

  void _incrementFreeCounter() {
    setState(() {
      if (familyCount < 100) {
        familyCount++;
      }

      totalFamilyAmount = familyCount * int.parse(memberprice);

      int totalAmountInt = totalFamilyAmount + totalGuestAmount;
      totalAmount = totalAmountInt.toString();
      //isVisible= true;
    });
  }

  void _decrementFreeCounter() {
    setState(() {
      if (familyCount > 0) {
        familyCount--;
      }
      totalFamilyAmount = familyCount * int.parse(memberprice);

      int totalAmountInt = totalFamilyAmount + totalGuestAmount;
      totalAmount = totalAmountInt.toString();
    });
  }

  void _incrementAddGuestCount() {
    setState(() {
      if (guestAddCount < (allowedGuset - guestCount)) {
        guestAddCount++;
        totalAddGuestAmount = guestAddCount * int.parse(guestsprice);
      }
      //int totalAmountInt = totalFamilyAmount + totalGuestAmount;
      totalAddAmount = totalAddGuestAmount.toString();
    });
  }

  void _decrementAddGuestCount() {
    setState(() {
      if (guestAddCount > 0) {
        setState(() {
          guestAddCount--;
          totalAddGuestAmount = guestAddCount * int.parse(guestsprice);
        });

        totalAddAmount = totalAddGuestAmount.toString();
      }
    });
  }

  void _incrementGuestCount() {
    setState(() {
      if (guestCount < allowedGuset) {
        guestCount++;
        totalGuestAmount = guestCount * int.parse(guestsprice);
      }
      int totalAmountInt = totalFamilyAmount + totalGuestAmount;
      totalAmount = totalAmountInt.toString();
    });
  }

  void _decrementGuestCount() {
    if (guestCount > 0) {
      setState(() {
        guestCount--;
        totalGuestAmount = guestCount * int.parse(guestsprice);
      });
      int totalAmountInt = totalFamilyAmount + totalGuestAmount;
      totalAmount = totalAmountInt.toString();
    }
  }

  Future<BhogResponse> getBhogDataApi() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.eventBookingDetails);
    final response = await http.post(
      uri,
      body: jsonEncode(
          {"uid": getData.read("UserLogin")["id"].toString(), "bid": eventId}),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print(uri.toString());
    print(response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      BhogResponse bhogResponse = BhogResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future getFamilymemberCntApi() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.getFamilyCnt);
    final response = await http.post(
      uri,
      body: jsonEncode({"uid": getData.read("UserLogin")["id"].toString()}),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print("Bhog:" + response.body);

    if (response.statusCode == 200) {
      // Decode the response body

      var result = jsonDecode(response.body);
      int familyMemberCountDynamic = result['familycount'];
      familyMemberCount = familyMemberCountDynamic+1;
      print("Count:${familyMemberCount}");
      /*Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      BhogResponse bhogResponse = BhogResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;*/
    } else {

      throw Exception('Failed to load data');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // The app has resumed from the background (onResume equivalent)
      print("App resumed");
      // You can perform your onResume action here
      getFamilymemberCntApi();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      //preIndex = -1;
      eventDetailsController.mTotal = 0.0;
      eventDetailsController.totalTicket = 0;
      allowedMember = int.parse(maxmember);
      allowedGuset = int.parse(maxguest);
      //print("Date"+date);
    });

    getData.read("UserLogin") != null
        ? setState(() {
      if ((getData.read("UserLogin")["reconciliation_status"]) ==
          "paid") {
        isPaid = true;
      }
    })
        : null;

    loadData();
    getFamilymemberCntApi();
  }

  loadData() async {
    try {
      final data = await getBhogDataApi();
      setState(() {
        responseData = data;

        if (responseData.familyList.isNotEmpty) {
          int totalPacks = responseData.familyList.fold(0, (sum, item) {
            int numberOfPack = int.tryParse(item.gnumberofpack ?? '0') ?? 0;
            return sum + numberOfPack;
          });

          int totalAmountPack = responseData.familyList.fold(0, (sum, item) {
            int amount = int.tryParse(item.amount ?? '0') ?? 0;
            return sum + amount;
          });

          familyCount = int.tryParse(responseData.familyList.first.numberofpack ?? '0') ?? 0;
          guestCount = totalPacks;
          totalFamilyAmount = familyCount * (int.tryParse(memberprice) ?? 0);
          totalGuestAmount = guestCount * (int.tryParse(guestsprice) ?? 0);
          totalAmount = totalAmountPack.toString();

          isVisible = false;
        }
      });
    } catch (e) {
      // Handle error appropriately
      print(e.toString());
    }
  }

  cancleBooking() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.cancleBooking);
    final response = await http.post(
      uri,
      body: jsonEncode(
          {"uid": getData.read("UserLogin")["id"].toString(), "bid": eventId}),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print(response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      showToastMessage('Booking is Cancel successfully!');
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Booking Details".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 16,
            color: BlackColor,
          ),
        ),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
          color: BlackColor,
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          // This captures the correct BuildContext
          return GetBuilder<EventDetailsController>(
            builder: (controller) {
              return Visibility(
                visible: isVisible,
                child: eventStatus == "0"
                    ? GestButton(
                  height: 50,
                  Width: Get.size.width,
                  margin:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  buttoncolor: Colors.pinkAccent,
                  buttontext:
                  "${"Book Now".tr} : ${currency}${totalAmount}",
                  style: TextStyle(
                    color: WhiteColor,
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 15,
                  ),
                  onclick: () {





                            if (totalAmount != "0") {
                              Get.toNamed(
                                Routes.bhogPaymentScreen,
                                arguments: {
                                  "amount": totalAmount,
                                  "mCount": familyCount.toString(),
                                  "gCount": guestCount.toString(),
                                  "bhogid": bhogid,
                                  "edate": date,
                                  "textname": textname,
                                  "eventName": eventName,
                                  "eventId": eventId
                                },
                              );
                            } else if (familyCount > 0) {
                              //showToastMessage("Please Select Your Favorite Ticket!".tr);
                              loginController.addBhogFreePaymentImage(
                                  null,
                                  "no_image",
                                  totalAmount,
                                  bhogid,
                                  familyCount.toString(),
                                  guestCount.toString(),
                                  eventId,
                                  date,
                                  eventName,
                                  textname);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please select number of member for booking .',
                                  ),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            }







                  },
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "   Booking closed",
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 20,
                        color: BlackColor,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      body: GetBuilder<EventDetailsController>(builder: (context) {
        return eventDetailsController.isLoading
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  eventName,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 20,
                    color: BlackColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                /*Text(
                  "${textname} Booking ",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 16,
                    color: BlackColor,
                  ),
                ),*/
                SizedBox(
                  height: 0,
                ),
                responseData.familyList.isEmpty
                    ? Column(
                  children: [
                    Text(
                      "Book your ticket for ${textname} ",
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 14,
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),


                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Text(
                                "You can book max [ ${maxmember} ] ticket. \n"
                                    "Rs. [ ${memberprice} ] is chargebale for each ticket.\n"

                                    "${int.parse(eventDetailsController.eventInfo?.eventData?.totalTicket.toString() ?? "0") - int.parse(eventDetailsController.eventInfo?.eventData?.totalBookTicket.toString() ?? "0")} spots left",
                                style: TextStyle(
                                  fontFamily:
                                  FontFamily.gilroyBold,
                                  fontSize: 10,
                                  color: BlackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Table(
                            border: TableBorder.all(),
                            // Add borders around the table
                            columnWidths: {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                            },
                            children: [
                              // Header Row
                              TableRow(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300]),
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('Description',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('Qty',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('Amount',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                ],
                              ),
                              // First row: Family members
                              TableRow(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(
                                        'Ticket Booking',
                                        style: TextStyle(
                                            fontSize: 16)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        Flexible(
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.remove),
                                            onPressed:
                                            _decrementCounter,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                              ' $familyCount',
                                              style: TextStyle(
                                                  fontSize:
                                                  16)),
                                        ),
                                        Flexible(
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.add),
                                            onPressed:
                                            _incrementCounter,
                                            color:
                                            Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(
                                        totalFamilyAmount
                                            .toStringAsFixed(
                                            2),
                                        style: TextStyle(
                                            fontSize: 16)),
                                  ),
                                ],
                              ),
                              // Second row: Guests

                              // Total row
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey[
                                  300], // Adding a background color for the total row
                                ),
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(
                                        'Total Amount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('',
                                        style: TextStyle(
                                            fontSize: 16)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(totalAmount,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            " *Ticket booking is subjected to availabilty. \n"
                                "* Amount paid for Ticket is non-refundable.\n"
                                "* Please display the QR Code at the time of Check-In.",
                            style: TextStyle(
                              fontFamily:
                              FontFamily.gilroyBold,
                              fontSize: 10,
                              color: BlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                )
                    :

                Column(
                  children: [
                    Text(
                      "Your ${textname} is booked",
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 14,
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    alloption == "freeForAll"
                        ? SizedBox()
                        : responseData.familyList.first.status ==
                        "0"
                        ? Text(
                      ' payment varification status: pending',
                      style: TextStyle(fontSize: 18),
                    )
                        : Text(
                      ' payment varification status: confirm',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),

                    // Update the state with the new data
                     Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Text(
                                "You can book max [ ${maxmember} ]. \n"
                                    "Rs. [ ${memberprice} ] is chargebale for each ticket.\n",
                                   /* "Rs. [ ${guestsprice} ] is chargebale for each guest.",*/
                                style: TextStyle(
                                  fontFamily:
                                  FontFamily.gilroyBold,
                                  fontSize: 10,
                                  color: BlackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Table(
                            border: TableBorder.all(),
                            // Add borders around the table
                            columnWidths: {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                            },
                            children: [
                              // Header Row
                              TableRow(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300]),
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('Description',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('Qty',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('Amount',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                ],
                              ),
                              // First row: Family members
                              TableRow(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(
                                        'Ticket Booking',
                                        style: TextStyle(
                                            fontSize: 16)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                              ' $familyCount',
                                              style: TextStyle(
                                                  fontSize:
                                                  16)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(
                                        totalFamilyAmount
                                            .toStringAsFixed(
                                            2),
                                        style: TextStyle(
                                            fontSize: 16)),
                                  ),
                                ],
                              ),
                              // Second row: Guests

                              // Total row
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey[
                                  300], // Adding a background color for the total row
                                ),
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(
                                        'Total Amount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text('',
                                        style: TextStyle(
                                            fontSize: 16)),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(totalAmount,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          eventStatus == "0"
                              ? /*Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle booking logic here
                                print(
                                    'Booking $ticketCount ticket(s)');

                                setState(() {
                                  isAddVisible =
                                  !isAddVisible;
                                });
                              },
                              child: Text(
                                  'Add More Guest'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle booking logic here

                                Get.snackbar(
                                  'Cancel Booking',
                                  'Do you want to cancel the booking?',
                                  snackPosition:
                                  SnackPosition
                                      .BOTTOM,
                                  mainButton:
                                  TextButton(
                                    onPressed: () {
                                      // Add logic here to cancel the booking
                                      cancleBooking();
                                    },
                                    child: Text(
                                        'Cancel Booking',
                                        style: TextStyle(
                                            color: Colors
                                                .red)),
                                  ),
                                );
                              },
                              child: Text(
                                  'Cancel Booking'),
                            ),
                          ])*/
                          SizedBox()
                              : Text(
                            "  Booking closed",
                            style: TextStyle(
                              fontFamily:
                              FontFamily.gilroyBold,
                              fontSize: 20,
                              color: BlackColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: isAddVisible,
                            child: Column(
                              children: [
                                Table(
                                  border: TableBorder.all(),
                                  // Add borders around the table
                                  columnWidths: {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                  },
                                  children: [
                                    // Header Row
                                    TableRow(
                                      decoration:
                                      BoxDecoration(
                                          color: Colors
                                              .grey[300]),
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                              'Description',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold)),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text('Qty',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold)),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                              'Amount',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold)),
                                        ),
                                      ],
                                    ),
                                    // First row: Family members

                                    // Second row: Guests

                                    // Total row
                                    TableRow(
                                      decoration:
                                      BoxDecoration(
                                        color: Colors.grey[
                                        300], // Adding a background color for the total row
                                      ),
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                              'Total Amount',
                                              style: TextStyle(
                                                  fontSize:
                                                  16,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold)),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text('',
                                              style: TextStyle(
                                                  fontSize:
                                                  16)),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                              totalAddAmount,
                                              style: TextStyle(
                                                  fontSize:
                                                  16,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestButton(
                                  height: 50,
                                  Width: Get.size.width,
                                  margin:
                                  EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10),
                                  buttoncolor:Colors.pinkAccent,
                                  buttontext:
                                  "${"Book Now".tr} : ${currency}${totalAddAmount}",
                                  style: TextStyle(
                                    color: WhiteColor,
                                    fontFamily:
                                    FontFamily.gilroyBold,
                                    fontSize: 15,
                                  ),
                                  onclick: () {
                                    if (totalAddAmount !=
                                        "0") {
                                      Get.toNamed(
                                        Routes
                                            .bhogPaymentScreen,
                                        arguments: {
                                          "amount":
                                          totalAddAmount,
                                          "mCount":
                                          familyCount
                                              .toString(),
                                          "gCount":
                                          guestAddCount
                                              .toString(),
                                          "bhogid": bhogid,
                                          "edate": date,
                                          "textname":
                                          textname,
                                          "eventName":
                                          eventName,
                                          "eventId": eventId
                                        },
                                      );
                                    } else {
                                      showToastMessage(
                                          "Please Select number of guest to add!"
                                              .tr);
                                      /*   loginController.addBhogFreePaymentImage(
                                        " ",
                                        "no_image",
                                        totalAddAmount,
                                        bhogid,
                                        familyCount.toString(),
                                        guestCount.toString(),
                                        eventId,
                                        eventName,
                                        textname)*/
                                      ;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            " *Ticket booking is subjected to availabilty. \n"
                                "* Amount paid for additional Ticket is non-refundable.\n"
                                "* Please display the QR Code at the time of Check-In.",
                            style: TextStyle(
                              fontFamily:
                              FontFamily.gilroyBold,
                              fontSize: 10,
                              color: BlackColor,
                            ),
                          ),
                          GestButton(
                            height: 50,
                            Width: Get.size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            buttoncolor:Colors.pinkAccent,
                            buttontext:
                            "${"View QR Code".tr}",
                            style: TextStyle(
                              color: WhiteColor,
                              fontFamily:
                              FontFamily.gilroyBold,
                              fontSize: 15,
                            ),
                            onclick: () {
                              Get.to(() => TicketQrCode(
                                  ticketData:
                                  '0;${eventId};${eventName};$eventId;$familyCount;$guestCount;${getData.read("UserLogin")["name"]};${getData.read("UserLogin")["id"].toString()};${responseData.familyList.first.status};$date;$alloption',eventId: eventId ,eventype:"admin"));
                            },
                          ),
                          /*GestButton(
                                height: 50,
                                Width: Get.size.width,
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                buttoncolor: gradient.defoultColor,
                                buttontext: "${"Scan QR Code".tr}",
                                style: TextStyle(
                                  color: WhiteColor,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                ),
                                onclick: () {

                                  _scanQR();


                                },
                              ),*/
                        ],
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        )
            : Center(
          child: CircularProgressIndicator(
            color: gradient.defoultColor,
          ),
        );
      }),
    );
  }

  void _scanQR() async {
    /* final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerPage()),
    );*/
    final result = await Get.to(QRScannerPage());
    if (result != null) {
      // Process the scanned data
      _processScannedData(result);
    }
  }

  void _processScannedData(String qrData) {
    // Decode and use the QR code data
    final params = qrData.split(';'); // Example: split by semicolon
    final eventId = params[0];
    final userName = params[1];
    final date = params[2];
    final time = params[3];
    final gcount = params[4];

    // Use the retrieved parameters
    print('Event ID: $eventId');
    print('User Name: $userName');
    print('Bhogid: $date');
    print('fmembercount: $time');
    print('guestcount: $gcount');
  }
}
