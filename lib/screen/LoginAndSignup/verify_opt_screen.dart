// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, unnecessary_brace_in_string_interps, avoid_print, sort_child_properties_last, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';

class VerifyOtpScreen extends StatefulWidget {
  @override
  State<VerifyOtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController pinPutController = TextEditingController();
  TextEditingController name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String code = "";
  String phoneNumber = Get.arguments["number"];
  String countryCode = Get.arguments["cuntryCode"];
  String rout = Get.arguments["route"];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: Container(
          //color: transparent,
          height: Get.height,
          decoration: BoxDecoration(
            /*image: DecorationImage(
              image: AssetImage('assets/app_bg.jpeg'),
              // Replace with your image path
              fit: BoxFit.cover, // Use BoxFit to adjust the image's coverage
            ),*/
            color: Colors.pinkAccent,
          ),
          child: Stack(
            children: [
              Container(
                height: Get.height * 0.30,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.05),
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
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(left: 10),
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
                        SizedBox(
                          width: Get.width * 0.23,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Verify OTP".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Gilroy Bold",
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Get.height * 0.22,
                child: Container(
                  height: Get.height * 0.8,
                  width: Get.size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 5, left: 15),
                        child: Text(
                          "Verify OTP to reset password".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: BlackColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: name,
                          keyboardType: TextInputType.number,
                          cursorColor: BlackColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: BlackColor,
                          ),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                "assets/Profile.png",
                                height: 10,
                                width: 10,
                                color: greycolor,
                              ),
                            ),
                            labelText: "Enter OTP".tr,
                            labelStyle: TextStyle(
                              color: greycolor,
                              fontFamily: FontFamily.gilroyMedium,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter OTP'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestButton(
                        Width: Get.size.width,
                        height: 50,
                        buttoncolor: Colors.pinkAccent,
                        margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                        buttontext: "Verify".tr,
                        style: TextStyle(
                          fontFamily: "Gilroy Bold",
                          color: WhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        onclick: () {
                          if (name.text.isNotEmpty) {
                            verifyOtp(name.text);
                          } else {
                            showToastMessage("Please Enter OTP".tr);
                          }
                        },
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyOtp(String otp) async {
    String baseUrl =
        "https://2factor.in/API/V1/d5e40971-765b-11ef-8b17-0200cd936042/SMS/VERIFY3";
    String phoneNumberNew =
        '${countryCode + phoneNumber}'; // This will be dynamically replaced
    //String message = "AUTOGEN/OTP1";  // The rest of the message or OTP code

// Construct the URL dynamically
    String requestUrl = "$baseUrl/$phoneNumberNew/$otp";
    print(requestUrl);
// Use the request URL in your HTTP request
    Uri uri = Uri.parse(requestUrl);

// Example for making an HTTP GET request
    var response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      // Handle successful response
      var result = jsonDecode(response.body);
      if (result["Status"] == "Success") {
        showToastMessage("OTP Verified Successfully!");

        Get.toNamed(Routes.otpScreen, arguments: {
          "number": phoneNumber,
          "cuntryCode": countryCode,
          "route": rout,
        });
      } else {
        showToastMessage('OTP Verification Error! ${result["Details"]}');
      }
    } else {
      // Handle error
    }
  }
}
