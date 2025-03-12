// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, unnecessary_string_interpolations, sort_child_properties_last

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jjcentre/controller/signup_controller.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/LoginAndSignup/login_screen.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:http/http.dart' as http;
class ResetPasswordScreen extends StatelessWidget {
  SignUpController signUpController = Get.find();
  TextEditingController number = TextEditingController();
  String cuntryCode = "";
  final _formKey = GlobalKey<FormState>();

  static String verifay = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       // color: transparent,
        height: Get.height,
        decoration: BoxDecoration(
          /*image: DecorationImage(
            image: AssetImage('assets/app_bg.png'),
            // Replace with your image path
            fit: BoxFit
                .fill, // Use BoxFit to adjust the image's coverage
          ),*/
          color: Colors.pinkAccent,
        ),
        child: Stack(
          children: [
            /*Container(
              height: Get.height * 0.35,
              width: double.infinity,
              child: Column(
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
                      SizedBox(
                        width: Get.width * 0.25,
                      ),
                      Text(
                        "Reset Password".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 17,
                          color: WhiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.size.height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyMedium,
                          fontSize: 15,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(LoginScreen());
                        },
                        child: Text(
                          " Login Now".tr,
                          style: TextStyle(
                            color: Color(0xFFFBBC04),
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.size.height * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Image.asset(
                      "assets/Rectangle326.png",
                      height: 25,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                gradient: gradient.btnGradient,
              ),
            ),*/

            Container(
              height: Get.height * 0.30,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(
                        width: Get.width * 0.43,
                      ),

                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,

                        child: Text(
                          "Reset Password ".tr,
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
                height: Get.size.height,
                width: Get.size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    // SizedBox(
                    //   height: Get.height * 0.005,
                    // ),
                    Text(
                      "Please enter your phone number to request a\npassword reset"
                          .tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: BlackColor,
                        fontFamily: "Gilroy Medium",
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: IntlPhoneField(
                          keyboardType: TextInputType.number,
                          cursorColor: BlackColor,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialCountryCode: 'IN',
                          controller: number,
                          onChanged: (value) {
                            cuntryCode = value.countryCode;
                          },
                          onCountryChanged: (value) {
                            number.text = '';
                          },
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: greycolor,
                          ),
                          dropdownTextStyle: TextStyle(
                            color: greycolor,
                          ),
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: BlackColor,
                          ),
                          decoration: InputDecoration(
                            helperText: null,
                            labelText: "Mobile Number".tr,
                            labelStyle: TextStyle(
                              color: greycolor,
                              fontFamily: FontFamily.gilroyMedium,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (p0) {
                            if (p0!.completeNumber.isEmpty) {
                              return 'Please enter your number'.tr;
                            } else {}
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestButton(
                      Width: Get.size.width,
                      height: 50,
                      buttoncolor: Colors.pinkAccent,
                      margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                      buttontext: "Submit".tr,
                      style: TextStyle(
                        fontFamily: "Gilroy Bold",
                        color: WhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      onclick: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          String? validationResponse = validateMobile(number.text);
                          if (number.text.length ==  10) {
                            signUpController.checkMobileInResetPassword(
                                number: number.text, cuntryCode: cuntryCode);
                          }else{
                            showToastMessage('Please enter valid Mobile Number');
                          }
                        }
                      },
                    ),
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
            )
          ],
        ),
      ),
    );
  }
}

String? validateMobile(String value) {
  // Indian Mobile number are of 10 digits only
  String pattern = r'^[6-9]\d{9}$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}


Future<void> sendOTP(
  String phonNumber,
  String cuntryCode,
) async {


  String baseUrl = "https://2factor.in/API/V1/d5e40971-765b-11ef-8b17-0200cd936042/SMS";
  String phoneNumber = '${cuntryCode + phonNumber}';  // This will be dynamically replaced
  String message = "AUTOGEN/OTP1";  // The rest of the message or OTP code

// Construct the URL dynamically
  String requestUrl = "$baseUrl/$phoneNumber/$message";

// Use the request URL in your HTTP request
  Uri uri = Uri.parse(requestUrl);

// Example for making an HTTP GET request
  var response = await http.get(uri);
  print(response.body);
  if (response.statusCode == 200) {
    // Handle successful response
  } else {
    // Handle error
  }




}
