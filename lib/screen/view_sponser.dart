import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jjcentre/model/sponser_details.dart';
import 'package:jjcentre/screen/welcomepagescreen.dart';
import 'package:jjcentre/screen/pay_membership_fee.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller/club_controller.dart';
import '../controller/login_controller.dart';
import '../helpar/routes_helpar.dart';
import '../utils/Colors.dart';

class ViewSponserScreen extends StatefulWidget {
  const ViewSponserScreen({super.key});

  @override
  State<ViewSponserScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<ViewSponserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //ClubDetailsController loginController = Get.find();
  File? paymentImage;
  ResponseDataNew responseData = ResponseDataNew(familyList: []);
  bool isLoading = true; // Loading flag
  bool hasError = false;
  String eventId = Get.arguments["eventId"];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    try {
      final data = await getSponserDataApi(eventId);
      setState(() {
        responseData = data;
        isLoading = false; // Update the state with the new data
      });
    } catch (e) {
      // Handle error appropriately
      setState(() {
        hasError = true; // An error occurred while loading data
        isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/app_bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
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
                        Spacer(),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Sponsor's List".tr,
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
            ),
            Positioned(
              top: Get.height * 0.22,
              left: 0,
              right: 0,
              child: Container(
                //color: Colors.green,
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
                        : responseData.familyList.isEmpty
                            ? Center(
                                child: Text(
                                    'No data available.')) // Handle empty data case
                            : Form(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      /*  Text(
                          "Registered Member".tr,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontFamily: "Gilroy Bold",
                            fontSize: 22,
                          ),
                        ),*/

                                      SizedBox(height: 10),
                                      Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildDetailRow(
                                                'Description',
                                                'Event Description',
                                                'Amount',
                                                '100.00'),
                                            /*_buildDetailRowWithButton(responseData!.familyList[0].description, '100.00'),*/
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: responseData
                                                  .familyList.length,
                                              itemBuilder: (context, index) {
                                                final item = responseData
                                                    .familyList[index];
                                                return _buildDetailRowWithButton(
                                                  item.description,
                                                  item.eTime, // Assuming eTime is in the correct format for display
                                                );
                                              },
                                            ),
                                            SizedBox(height: 16),
                                          ],
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
      /*bottomNavigationBar: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bottom_bar.jpeg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // BottomAppBar with buttons
          BottomAppBar(
            height: 70,
            color: Colors.transparent, // Make the BottomAppBar transparent
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.yellow),
                  onPressed: () {
                    // Add your back button functionality here
                    Get.back();
                  },
                ),

              ],
            ),
          ),
        ],
      ),*/
    );
  }

  Widget _buildDetailRow(
      String title1, String value1, String title2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title1',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(width: 16.0), // Add space between the amount and the button
          Expanded(
            flex: 1,
            child: Text(
              '$title2',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithButton(String description, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            flex: 1,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle pay button click here
              /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pay button clicked!')),
              );*/
              Get.toNamed(
                Routes.sponserPaymentScreen,
                arguments: {
                  "eventId": eventId,
                  "description": description,
                  "amount": amount,
                },
              );
            },
            child: Text('Pay'),
          ),
        ],
      ),
    );
  }

  Future<ResponseDataNew> getSponserDataApi(String eventId) async {
    final Uri uri = Uri.parse(Config.baseurl + Config.sponserDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({"uid": eventId}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return parseResponse(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
