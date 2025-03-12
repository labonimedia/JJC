// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, sort_child_properties_last


import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

import '../utils/scanqr_code.dart';



class QRScannerScreen extends StatefulWidget {
  @override
  _BhogPaymentState createState() => _BhogPaymentState();
}

class _BhogPaymentState extends State<QRScannerScreen> {
  SignUpController signUpController = Get.find();
  LoginController loginController=Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cuntryCode = "";
  File? paymentImage;
  File? reconciliationImage;
  String? path,path1=null;
  String? networkimage,networkimage1,networkimage2;
  String? base64Image;
  bool _isVisible = true;
  bool _istextVisible = false;
  bool isPaid =false;


  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  @override
  void initState() {
    super.initState();

  }











  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
      exit(0);
    },

    child:Scaffold(
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
              height: Get.height * 0.30,
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
                          exit(0);
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

                      InkWell(
                        onTap: () {
                          logoutSheet();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(13),
                          margin: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/Logout.png',
                            color: WhiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF000000).withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Scan QR Code".tr,
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
            Positioned(
              top: Get.height * 0.22,
              child: Container(
                height: Get.height ,
                width: Get.size.width,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 220,
                        ),









                        Visibility(
                          visible: _isVisible,
                          child: GestButton(
                            Width: Get.size.width,
                            height: 50,
                            buttoncolor: Colors.pinkAccent,
                            margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                            buttontext: "Scan QR".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: WhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            onclick: () {

                              _scanQR();

                            },
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
          ],
        ),
      ),
    ),
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
    try {
      // Decode and use the QR code data
      final params = qrData.split(';');

      // Ensure the minimum required parameters are present
      if (params.length < 10) {
        throw FormatException("QR data format is incorrect. Expected at least 10 values.");
      }

      final eventType = params[0];

      // Extract common fields
      final eventId = params[1];
      final eventName = params[2];
      final bhogId = params[3];
      final fmemberCount = params[4];
      final gcount = params[5];
      final userName = params[6];
      final userId = params[7];
      final status = params[8];
      final date = params[9];

      // Validate numeric fields
      if (!_isNumeric(eventType) || !_isNumeric(eventId) || !_isNumeric(bhogId)) {
        throw FormatException("Invalid number format in QR code data.");
      }

      if (eventType == "0") {
        final alloption = params.length > 10 ? params[10] : "";
        print('Processing Other Event...');

        Get.toNamed(
          Routes.bhogDetailsScreen,
          arguments: {
            "eventId": eventId,
            "eventName": eventName,
            "Bhogid": bhogId,
            "fmembercount": fmemberCount,
            "gcount": gcount,
            "userName": userName,
            "userId": userId,
            "status": status,
            "date": date,
            "alloption": alloption,
          },
        );
      } else {
        print('Processing Hall Event...');

        Get.toNamed(
          Routes.hallDetailsScreen,
          arguments: {
            "eventId": eventId,
            "eventName": eventName,
            "Bhogid": bhogId,
            "fmembercount": fmemberCount,
            "gcount": gcount,
            "userName": userName,
            "userId": userId,
            "status": status,
            "date": date,
          },
        );
      }
    } catch (e, stackTrace) {
      print("Error processing QR data: $e");
      print("StackTrace: $stackTrace");

      // Show error message to the user
      Get.snackbar(
        "QR Scan Error",
        e is FormatException ? e.message : "An unexpected error occurred.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

// Helper function to check if a string is numeric
  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }


  Future logoutSheet() {
    return Get.bottomSheet(
      Container(
        height: 220,
        width: Get.size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Logout".tr,
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.gilroyBold,
                color: RedColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Divider(
                color: greytext,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Are you sure you want to log out?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Cancle".tr,
                        style: TextStyle(
                          color: gradient.defoultColor1,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFeef4ff),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      setState(() async {
                        save('isLoginBack', true);
                        getData.remove('Firstuser');
                        getData.remove("UserLogin");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      });
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Logout".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: gradient.redgradient,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

}
