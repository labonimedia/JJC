// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart'as cs;
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

class StallDetailScreen extends StatefulWidget {
  @override
  _BhogPaymentState createState() => _BhogPaymentState();
}

class _BhogPaymentState extends State<StallDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cuntryCode = "";
  File? paymentImage;
  File? reconciliationImage;
  String? path, path1 = null;
  String? networkimage, networkimage1, networkimage2;
  String? base64Image;
  bool isLoading = true; // Loading flag
  bool hasError = false;
  bool isPaid = false;
  String eventName = Get.arguments["eventName"];
  String image = Get.arguments["image"];
  String stallId = Get.arguments["stallId"];
  String category = Get.arguments["category"];
  StallResponse stallResponse = StallResponse(
      familylist: [], responseCode: '', result: '', responseMsg: '');

  @override
  void initState() {
    super.initState();
    networkimage1 = "";

    loadData();
  }

  loadData() async {
    try {
      final data = await getStallDataApi();
      setState(() {
        stallResponse = data;
        isLoading = false; // Update the state with the new data
      });
    } catch (e) {
      // Handle error appropriately
      print(e.toString());
      hasError = true; // An error occurred while loading data
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: transparent,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/app_bg.png'),
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
                          "Stall Details".tr,
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
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loading indicator
                    : hasError
                        ? Center(
                            child: Text(
                                'Failed to load data. Try again.')) // Show error message
                        : stallResponse.familylist.isEmpty
                            ? Center(
                                child: Text(
                                    'No data available.')) // Handle empty data case
                            : Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        image,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          eventName,
                                          style: TextStyle(
                                            color: BlackColor,
                                            fontFamily: "Gilroy Bold",
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
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
                                              category == "foodStall" ?
                                                "  Menu": "  Details",
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontFamily: "Gilroy Bold",
                                                fontSize: 18,
                                              ),
                                            ),
                                            Container(
                                              height: Get.height * 0.4,
                                              // Adjust height as needed
                                              child: ListView.builder(
                                                itemCount: stallResponse
                                                    .familylist.length,
                                                itemBuilder: (context, index) {
                                                  // Get the current item
                                                  StallItem item = stallResponse
                                                      .familylist[index];

                                                  return ListTile(
                                                    title: /*Text(
                                          '${index + 1}) ${item.itemname}',
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: "Gilroy Bold",
                                          fontSize: 14,
                                        ),
                                      ),*/
                                                        Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        cs.CarouselSlider(
                                                          options:
                                                              cs.CarouselOptions(
                                                            height: 300,
                                                            autoPlay: true,
                                                            enlargeCenterPage:
                                                                true,
                                                            viewportFraction:
                                                                1.0,
                                                            enableInfiniteScroll:
                                                                true,
                                                          ),
                                                          items: [
                                                            "${item.menu_image1!}",
                                                            "${item.menu_image2!}",
                                                            "${item.menu_image3!}",
                                                            "${item.menu_image4!}",
                                                          ].map((imageUrl) {
                                                            return Builder(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    openFullScreenImage(
                                                                        context,
                                                                        imageUrl); // Navigate to full screen on tap
                                                                  },
                                                                  child: imageUrl.isNotEmpty
                                                                      ? Image.network(
                                                                    "${Config.imageUrl}"+imageUrl,
                                                                    width: Get.width,
                                                                    height: 300,
                                                                    fit: BoxFit.fill,
                                                                  )
                                                                      : Container(
                                                                    width: Get.width,
                                                                    height: 300,
                                                                    color: Colors.grey[300], // Placeholder color
                                                                    child: Center(
                                                                      child: Icon(
                                                                        Icons.image_not_supported, // Placeholder icon
                                                                        size: 50,
                                                                        color: Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
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

  void openFullScreenImage(BuildContext context, String imageUrl) {
    if(imageUrl.isEmpty){
     showToastMessage('Image not available') ;
    }else {
      Get.to(() => FullScreenImage(imageUrl: Config.imageUrl + imageUrl));
    }
  }

  Future getStallDataApi() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.stallDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({"sid": stallId}),
      headers: {"Content-Type": "application/json"},
    );
    print(response.body);
    if (response.statusCode == 200) {
      // return parseResponse(response.body);
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      StallResponse bhogResponse = StallResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
