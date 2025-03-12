// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, sort_child_properties_last


import 'dart:convert';
import 'dart:io';
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
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';

import '../Api/config.dart';
import 'bottombar_screen.dart';

class PayMembershipFeeScreen extends StatefulWidget {
  @override
  _PayMembershipFeeState createState() => _PayMembershipFeeState();
}

class _PayMembershipFeeState extends State<PayMembershipFeeScreen> {
  SignUpController signUpController = Get.find();
  LoginController loginController=Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cuntryCode = "";
  File? paymentImage;
  File? reconciliationImage;
  String? path,path1,path2;
  String? networkimage,networkimage1,networkimage2;
  String? base64Image;
  @override
  void initState() {
    super.initState();
    networkimage1 = Config.imageUrl + (getData.read("UserLogin")["membership_photo"] ?? "");
    networkimage2 = Config.imageUrl+ (getData.read("UserLogin")["reconciliation_photo"] ?? '');
  }




  Future<void> pickImage(ImageSource source, bool isPaymentImage) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);


    if (pickedFile != null) {
      path = pickedFile.path;

      File imageFile = File(path.toString());
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      //loginController.addPaymentImage(base64Image);
      setState(() {
        if (isPaymentImage) {
          path1 = pickedFile.path;
          paymentImage = File(pickedFile.path);
          //signUpController.uploadImage(image,'pay_image');
          loginController.addPaymentImage(base64Image,"pay_image","","");
        } else {
          path2 = pickedFile.path;
          reconciliationImage = File(pickedFile.path);
          // signUpController.uploadImage(image,'rec_image');
          loginController.addPaymentImage(base64Image,"rec_image","","");
        }

      });
    }

    /* if (image != null) {
      setState(() {
        if (isPaymentImage) {
          paymentImage = File(image.path);
          signUpController.uploadImage(image,'pay_image');
        } else {
          reconciliationImage = File(image.path);
          signUpController.uploadImage(image,'rec_image');
        }

      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: transparent,
        height: Get.height,
        child: Stack(
          children: [
            Container(
              height: Get.height * 0.35,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.03),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          getData.read('isLoginBack')
                              ? Get.to(AddFamilyMemberScreen())
                              : Get.back();
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
                        "Membership Status".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 17,
                          color: WhiteColor,
                        ),
                      )
                    ],
                  ),
                  /*   SizedBox(
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
                          " Login Now",
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
                  )
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Image.asset(
                      "assets/Rectangle326.png",
                      height: 25,
                    ),
                  ),,*/
                ],
              ),
              decoration: BoxDecoration(
                gradient: gradient.btnGradient,
              ),
            ),
            Positioned(
              top: Get.height * 0.22,
              child: Container(
                height: Get.height * 0.8,
                width: Get.size.width,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Membership 2024-25".tr,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Bold",
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        /*  Text(
                          "Create your free account in seconds".tr,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Medium",
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),*/
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["membership_status"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
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
                              /* prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/Profile.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              ),*/
                              labelText: "Membership Status".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["membership_date"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              border: OutlineInputBorder(
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
                              labelText: "Date".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["reconciliation_status"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
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
                              /* prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/Profile.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              ),*/
                              labelText: "Reconciliation Status".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["reconciliation_date"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            decoration: InputDecoration(
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
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              labelText: "Date".tr,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Other form fields for family members...

                              SizedBox(height: 20),
                              Text('Payment Image'),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        pickImage(ImageSource.gallery, true),
                                    child: Text('Choose File'),
                                  ),
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: path1 == null
                                        ? networkimage1 != ""
                                        ?  Image.network(
                                      "${networkimage1 ?? ""}",
                                      fit: BoxFit.cover,

                                    )
                                        :  Image.asset(
                                      "assets/profile-default.png",
                                      fit: BoxFit.cover,

                                    )
                                        : paymentImage != null
                                        ? Image.file(paymentImage!,
                                        width: 100, height: 100)
                                        : Text('No file chosen'),

                                  ),
                                  /* paymentImage != null
                                      ? Image.file(paymentImage!,
                                          width: 100, height: 100)
                                      : Text('No file chosen'),*/
                                ],
                              ),

                              SizedBox(height: 20),
                              Text('Reconciliation Image'),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        pickImage(ImageSource.gallery, false),
                                    child: Text('Choose File'),
                                  ),
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: path2 == null
                                        ? networkimage2 != ""
                                        ?  Image.network(
                                      "${networkimage2 ?? ""}",
                                      fit: BoxFit.cover,

                                    )
                                        :  Image.asset(
                                      "assets/profile-default.png",
                                      fit: BoxFit.cover,

                                    )
                                        : reconciliationImage != null
                                        ? Image.file(reconciliationImage!,
                                        width: 100, height: 100)
                                        : Text('No file chosen'),

                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestButton(
                          Width: Get.size.width,
                          height: 50,
                          buttoncolor: gradient.defoultColor,
                          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                          buttontext: "Continue".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: WhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          onclick: () {

                            if(getData.read("UserLogin")["membership_status"] == 'paid')
                            {
                              Get.offAll(BottomBarScreen());
                            }else {
                              showToastMessage(
                                  "Your membership fee is not paid yet. Kindly contact admin !".tr);
                            }

                          },
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
    );
  }
}
