// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, unnecessary_brace_in_string_interps, avoid_print, sort_child_properties_last, unrelated_type_equality_checks

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jjcentre/controller/login_controller.dart';
import 'package:jjcentre/controller/signup_controller.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/LoginAndSignup/resetpassword_screen.dart';
import 'package:jjcentre/screen/choosefevorite_event.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController pinPutController = TextEditingController();
  LoginController loginController = Get.find();
  SignUpController signUpController = Get.find();
  final _formKey = GlobalKey<FormState>();

  //FirebaseAuth auth = FirebaseAuth.instance;

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
         /* image: DecorationImage(
            image: AssetImage('assets/app_bg.jpeg'),
            // Replace with your image path
            fit: BoxFit
                .cover, // Use BoxFit to adjust the image's coverage
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
                     /* Text(
                        "Forgot Password".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 17,
                          color: WhiteColor,
                        ),
                      ),*/
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,

                        child: Text(
                          "Forgot Password ".tr,
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
              /* decoration: BoxDecoration(
                gradient: gradient.btnGradient,
              ),*/
            ),

        Positioned(
          top: Get.height * 0.22,
          child:Container(
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
              /*Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Divider(
                  color: greycolor,
                ),
              ),*/
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 5, left: 15),
                child: Text(
                  "Create Your New Password".tr,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyMedium,
                    color: BlackColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
                GetBuilder<LoginController>(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: loginController.newPassword,
                      obscureText: loginController.newShowPassword,
                      cursorColor: BlackColor,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontFamily.gilroyMedium,
                        color: BlackColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: greycolor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: greycolor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: greycolor),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            loginController.newShowOfPassword();
                          },
                          child: !loginController.newShowPassword
                              ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/showpassowrd.png",
                              height: 10,
                              width: 10,
                              color: greycolor,
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/HidePassword.png",
                              height: 10,
                              width: 10,
                              color: greycolor,
                            ),
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/Unlock.png",
                            height: 10,
                            width: 10,
                            color: greycolor,
                          ),
                        ),
                        labelText: "Password".tr,
                        labelStyle: TextStyle(
                          color: greycolor,
                          fontFamily: FontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                  );
                }),

              SizedBox(
                height: 10,
              ),
    GetBuilder<LoginController>(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: loginController.newConformPassword,
          obscureText: loginController.conformPassword,
          cursorColor: BlackColor,
          style: TextStyle(
            fontFamily: FontFamily.gilroyMedium,
            fontSize: 14,
            color: BlackColor,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password'.tr;
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: greycolor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: greycolor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: greycolor),
            ),
            suffixIcon: InkWell(
              onTap: () {
                loginController.newConformShowOfPassword();
              },
              child: !loginController.conformPassword
                  ? Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/showpassowrd.png",
                  height: 10,
                  width: 10,
                  color: greycolor,
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/HidePassword.png",
                  height: 10,
                  width: 10,
                  color: greycolor,
                ),
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                "assets/Unlock.png",
                height: 10,
                width: 10,
                color: greycolor,
              ),
            ),
            labelText: "Conform Password".tr,
            labelStyle: TextStyle(
              color: greycolor,
              fontFamily: FontFamily.gilroyMedium,
            ),
          ),
        ),
      );
    }),
              SizedBox(
                height: 20,
              ),
              GestButton(
                Width: Get.size.width,
                height: 50,
                buttoncolor: RedColor1,
                margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                buttontext: "Continue".tr,
                style: TextStyle(
                  fontFamily: "Gilroy Bold",
                  color: WhiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                onclick: () {
                  if (loginController.newPassword.text ==
                      loginController.newConformPassword.text) {
                    loginController.setForgetPasswordApi(
                        ccode: countryCode, mobile: phoneNumber);
                  } else {
                    showToastMessage("Please Enter Valid Password".tr);
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

  forgetPasswordBottomSheet() {
    return Get.bottomSheet(
      GetBuilder<LoginController>(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: 350,
            width: Get.size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Forgot Password".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: FontFamily.gilroyBold,
                    color: BlackColor,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Divider(
                    color: greycolor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 5, left: 15),
                  child: Text(
                    "Create Your New Password".tr,
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
                    controller: loginController.newPassword,
                    obscureText: loginController.newShowPassword,
                    cursorColor: BlackColor,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyMedium,
                      color: BlackColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password'.tr;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          loginController.newShowOfPassword();
                        },
                        child: !loginController.newShowPassword
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/showpassowrd.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/HidePassword.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/Unlock.png",
                          height: 10,
                          width: 10,
                          color: greycolor,
                        ),
                      ),
                      labelText: "Password".tr,
                      labelStyle: TextStyle(
                        color: greycolor,
                        fontFamily: FontFamily.gilroyMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: loginController.newConformPassword,
                    obscureText: loginController.conformPassword,
                    cursorColor: BlackColor,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 14,
                      color: BlackColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password'.tr;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          loginController.newConformShowOfPassword();
                        },
                        child: !loginController.conformPassword
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/showpassowrd.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/HidePassword.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/Unlock.png",
                          height: 10,
                          width: 10,
                          color: greycolor,
                        ),
                      ),
                      labelText: "Conform Password".tr,
                      labelStyle: TextStyle(
                        color: greycolor,
                        fontFamily: FontFamily.gilroyMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestButton(
                  Width: Get.size.width,
                  height: 50,
                  buttoncolor: gradient.defoultColor,
                  margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                  buttontext: "Continue".tr,
                  style: TextStyle(
                    fontFamily: "Gilroy Bold",
                    color: WhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  onclick: () {
                    if (loginController.newPassword.text ==
                        loginController.newConformPassword.text) {
                      loginController.setForgetPasswordApi(
                          ccode: countryCode, mobile: phoneNumber);
                    } else {
                      showToastMessage("Please Enter Valid Password".tr);
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
        );
      }),
    );
  }
}
