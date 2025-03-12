// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/controller/login_controller.dart';
import 'package:jjcentre/controller/signup_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/AddFamilyMemberScreen.dart';
import 'package:jjcentre/screen/LoginAndSignup/login_screen.dart';
import 'package:jjcentre/screen/welcomepagescreen.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../model/BookingInfo.dart';
import '../utils/scanqr_code.dart';

class HallDetailsScreen extends StatefulWidget {
  @override
  _BhogPaymentState createState() => _BhogPaymentState();
}

class _BhogPaymentState extends State<HallDetailsScreen> {
  SignUpController signUpController = Get.find();
  LoginController loginController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cuntryCode = "";
  File? paymentImage;
  DateTime currentDate = DateTime.now();
  late DateTime currentDateOnly;
  late DateTime givenDate;
  File? reconciliationImage;
  String? path, path1 = null;
  String? networkimage, networkimage1, networkimage2;
  String? base64Image;
  bool _isVisible = true;
  bool _istextVisible = false;
  bool isAllSelected = true;
  int partialCount = 0;
  bool isPaid = false;
  String eventId = Get.arguments["eventId"];
  String eventName = Get.arguments["eventName"];
  String Bhogid = Get.arguments["Bhogid"];
  String fmembercount = Get.arguments["fmembercount"];
  String gcount = Get.arguments["gcount"];
  String userName = Get.arguments["userName"];
  String userId = Get.arguments["userId"];
  String status = Get.arguments["status"];
  String edate = Get.arguments["date"];

  String colected = "0", pending = "0";
  bool isBookingAll = false;
  TextEditingController partialController = TextEditingController();
  String partialcount = "0";
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  BookingResponse bookingResponse = BookingResponse(
      collectedlist: [], responseCode: '', result: '', responseMsg: '');

  @override
  void initState() {
    super.initState();
    currentDateOnly =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    print("currentDate" + currentDateOnly.toString());
    givenDate = DateTime.parse(edate/*"2024-09-12"*/);

    loadData();
  }

  loadData() async {
    try {
      final data = await getbookingInfo();
      setState(() {
        bookingResponse = data;
        if (bookingResponse.collectedlist.isEmpty) {
        } else {
          colected = bookingResponse.collectedlist.first.collectedCnt;
          pending = bookingResponse.collectedlist.first.pendingCnt;

          if (bookingResponse.collectedlist.first.isAllFlag == "1") {
            _isVisible = false;
          }
        }
      });
    } catch (e) {
      // Handle error appropriately
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: transparent,
        height: Get.height,
        decoration: BoxDecoration(
         /* image: DecorationImage(
            image: AssetImage('assets/app_bg.jpeg'),
            fit: BoxFit.cover,
          ),*/
          color: Colors.pinkAccent
        ),
        child: Stack(
          children: [
            Container(
              height: Get.height * 0.25,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.03),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(13),
                          margin: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/back.png',
                            color: WhiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF000000).withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Ticket Distribution".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Gilroy Bold",
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            currentDateOnly == givenDate
                ? Positioned(
              top: Get.height * 0.22,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            eventName,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: "Gilroy Bold",
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            formatDate(edate),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Gilroy Bold",
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "Name: " + userName,
                                style: TextStyle(
                                  color: BlackColor,
                                  fontFamily: "Gilroy Bold",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        /*Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            // Family Members
                            Column(
                              children: [
                                Text(
                                  "Family Members:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 80,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    border:
                                    Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$fmembercount",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Guests
                            Column(
                              children: [
                                Text(
                                  "Guest",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 80,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    border:
                                    Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$gcount",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
*/
                        // Payment Status

                        status == "0"
                            ? Text(
                          "Payment Status: Pending",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                            : Text(
                          "Payment Status: Paid",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 40),
                        // Total Pax
                        Text(
                          "Total Tickets: " +
                              (int.parse(fmembercount) +
                                  int.parse(gcount))
                                  .toString(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Entered: ${colected}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 60),
                            Text(
                              "Pending: ${pending}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Booking Buttons (All / Partial)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, // Background color
                                foregroundColor: Colors.white, // Text color
                                padding: EdgeInsets.only(
                                    left: 30, right: 30.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isAllSelected = true;
                                  // Toggle the checkbox state
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "All",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10),
                                  // Space between text and checkbox
                                  Checkbox(
                                    value: isAllSelected,
                                    // Bind the checkbox to a state variable
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isAllSelected = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 40),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                // Background color
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.only(
                                    top: 12,
                                    bottom: 12,
                                    left: 40,
                                    right: 40.0),
                                // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isAllSelected = false;
                                  partialCount = 0;
                                });
                              },
                              child: Text(
                                "Partial",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        // Partial Count (if partial is selected)
                        if (!isAllSelected)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (partialCount > 0) partialCount--;
                                  });
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Center(
                                  child: Text(
                                    "$partialCount",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {

                                    if (status == "0"){
                                      if (partialCount < (int.parse(fmembercount) - int.parse(colected))){
                                        partialCount++;
                                      }
                                    }
                                    else if (partialCount < (int.parse(fmembercount) + int.parse(gcount) - int.parse(colected)))
                                      partialCount++;
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),

                        SizedBox(height: 20),

                        Visibility(
                          visible: _isVisible,
                          child:   GestButton(
                            Width: Get.size.width,
                            height: 50,
                            buttoncolor: Colors.pinkAccent,
                            margin: EdgeInsets.only(
                                top: 15,
                                left: 30,
                                right: 30),
                            buttontext: "Submit".tr,
                            style: TextStyle(
                              fontFamily:
                              FontFamily.gilroyBold,
                              color: WhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            onclick: () {
                              //print("Hello dsfds"+status);
                              // bookingConfirm();
                              if (status == "0" && partialCount <= (int.parse(fmembercount) - int.parse(colected))) {
                                if (partialCount > 0 && isAllSelected == false) {
                                  bookingConfirm();
                                } else {
                                  if ((int.parse(fmembercount) - int.parse(colected)) ==
                                      0) {
                                    showToastMessage(
                                        "You have collected all your tickets already!");
                                  } else {
                                    showToastMessage(
                                        "Your payment is pending. You are allowed only for ${(int.parse(fmembercount) - int.parse(colected))} member of your family!");
                                  }
                                }
                              } else {
                                bookingConfirm();
                                //showToastMessage("Your payment is pending. You are allowed only for ${(int.parse(fmembercount) - int.parse(colected))} member of your family!");
                              }
                            },
                          )

                        ),

                        Visibility(
                          visible: !_isVisible,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                " You have collected all your tickets already!",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: WhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            )
                : Positioned(
              top: Get.height * 0.22,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 100),
                        Center(
                          child: Text(
                            "No Event is planned for today!",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: WhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String formatDate(String dateString) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateTime.parse(dateString);

      // Format the parsed date
      return DateFormat('EEE, dd MMM yyyy').format(parsedDate);
    } catch (e) {
      // Handle invalid date input
      return "Invalid date";
    }
  }
  Future<void> bookingConfirm() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.hallBooking);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": userId,
        "bid": Bhogid,
        "isAllSelected": isAllSelected,
        "partialCount": partialCount,
        "eventid": eventId,
        "date": edate,
        "totalCount": (int.parse(fmembercount) + int.parse(gcount)).toString()
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print("sdasd" + response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      var result = jsonDecode(response.body);
      showToastMessage(result["ResponseMsg"]);
      Get.back();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<BookingResponse> getbookingInfo() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.hallBookingInfo);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": userId,
        "bid": Bhogid,
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print("sdasd" + response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      BookingResponse bhogResponse = BookingResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
      //showToastMessage(result["ResponseMsg"]);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
