// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart' as cs;
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
import 'package:jjcentre/model/StallResponse.dart';
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
import '../utils/FullScreenImage.dart';

class SponsorGalleryDetailScreen extends StatefulWidget {
  String? title;
  String? description;
  String? image;
  SponsorGalleryDetailScreen({super.key, this.title, this.description, this.image});
  @override
  _spnsorGalleryState createState() => _spnsorGalleryState();
}

class _spnsorGalleryState extends State<SponsorGalleryDetailScreen> {

  /*String eventName = Get.arguments["title"];
  String image = Get.arguments["image"];
  String description = Get.arguments["description"];*/




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: transparent,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/app_bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: Get.height * 0.30,
              width: double.infinity,
              child: Column(
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
                          "Sponsor Details".tr,
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
                height: Get.height * 0.8,
                width: Get.size.width,
                child:  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          widget.image!,
                          width:
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(padding: EdgeInsets.only(left: 15,right: 15),child: Center(
                          child: Text(
                            widget.title!,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: "Gilroy Bold",
                              fontSize: 18,
                            ),
                          ),
                        ),),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Details",
                                style: TextStyle(
                                  color: BlackColor,
                                  fontFamily: "Gilroy Bold",
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                height: Get.height * 0.4,
                                // Adjust height as needed
                                child: SingleChildScrollView(
                                  child: Text(
                                  widget.description!,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily: "Gilroy Bold",
                                    fontSize: 14,
                                  ),
                                ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
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


