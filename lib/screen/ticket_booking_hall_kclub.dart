import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller/login_controller.dart';
import '../helpar/routes_helpar.dart';
import '../model/BookingInfo.dart';
import '../model/fontfamily_model.dart';
import '../utils/Colors.dart';
import 'bhog_qr_screen.dart';
import 'memberprofilescreen.dart';

class TicketBookingHallScreenKclub extends StatefulWidget {
  @override
  _HallBookingScreenState createState() => _HallBookingScreenState();
}

/*class Seat {
  final String id; // Seat identifier (e.g., "A1")
  bool isSelected; // Whether the seat is selected
  final bool isSold; // Whether the seat is sold
  final String type; // e.g., "bestseller", "available"

  Seat({
    required this.id,
    this.isSelected = false,
    this.isSold = false,
    required this.type,
  });
}

class Section {
  final String name; // Section name (e.g., "Rs. 320 Recliner")
  final List<List<Seat?>> rows; // Rows of seats in this section

  Section({
    required this.name,
    required this.rows,
  });
}*/

class _HallBookingScreenState extends State<TicketBookingHallScreenKclub> {
  LoginController loginController = Get.find();
  bool isLoading = true; // Loading flag
  bool hasError = false;
  TheaterResponse? productResponse;
  int familyMemberCount = 1;
  int familyCount = 0;
  HallResponse? hallResponse;
  int guestCount = 0;
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
  String totalAmount = "0";
  String enabledSectionId = "0";
  bool isVisible = true;
  String userName = "";
  String userId="";
  late List<Seat> selectedSeats;
  TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  double initialScale = 1.0;
  double minScale = 1.0;
  double maxScale =10.0;
  void initState() {
    super.initState();

    //selectedSubCategory = null;
    getBookingStatusApi();
    fetchData();
    //getFamilymemberCntApi();

    getData.read("UserLogin") != null
        ? setState(() {
      if ((getData.read("UserLogin")["memberType"]) != null) {
        print("memberType:" + getData.read("UserLogin")["memberType"]);
        //isPaid = true;
        //enabledSectionId = getData.read("UserLogin")["memberType"];
        userName = getData.read("UserLogin")["name"] ?? "";
        userId= getData.read("UserLogin")["id"].toString();
      }
    })
        : null;
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
      familyMemberCount = familyMemberCountDynamic + 1;
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

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      hasError = false; // Reset error state
    });

    try {
      final data1 = await getTicketDataApi();

      setState(() {
        productResponse = data1;
        isLoading = false;
      });
    } catch (e) {
      // Handle the error appropriately
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<TheaterResponse> getTicketDataApi() async {
    final Uri uri =
    Uri.parse(Config.baseurlKclub + Config.getTicketData + "?eventid=${eventId}");
    print(uri.toString());

    final response = await http.get(
      uri,
      //headers: headers,
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body.toString());
      TheaterResponse responseData = TheaterResponse.fromJson(jsonData);
      //print(responseData.catEventData.elementAt(0).rows.first.seats);
      //print(response.body);

      return responseData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future getBookingStatusApi() async {
    final Uri uri = Uri.parse(Config.baseurlKclub + Config.checkBookingStatus);
    print(uri.toString());
    Map map = {
      "uid": getData.read("UserLogin")["id"].toString(),
      "eid": eventId,
    };

    print("Date" + map.toString());
    final response = await http.post(
      uri,
      body: jsonEncode(map),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (result["Result"] == "1") {
        showToastMessage(result["ResponseMsg"]);
        isVisible = false;

        final data1 = await getHallBookingInfo();
        if (data1 != null) {
          setState(() {
            hallResponse = data1;
          });
        } else {
          print("Error: getHallBookingInfo returned null");
        }


      }
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future getHallBookingInfo() async {
    final Uri uri = Uri.parse(Config.baseurlKclub + Config.hallBookingSingalDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
        "eventId":eventId,
      }),
      headers: {"Content-Type": "application/json"},
    );
    print("URI" + uri.toString());
    print("eventId" + eventId);
    // Check if the request was successful
    print("Hall" + response.body);
    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      HallResponse bhogResponse = HallResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
      // showToastMessage(result["ResponseMsg"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  /*void toggleSeatSelection(Seat? seat) {
    if (seat != null && !seat.isSold!) {
      setState(() {
        seat.isSelected = !seat.isSelected;
      });
    }
  }*/

  void toggleSeatSelection(Seat seat) {
    if (seat.isSold!) return; // Skip if the seat is sold

    seat.isSelected = !seat.isSelected; // Toggle selection
    setState(() {}); // Refresh UI
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;

    int familyCount1 = familyMemberCount; // Number of family members allowed
    List<Seat> selectedSeats = getSelectedSeats();
    for (var section in productResponse?.catEventData ?? []) {
      for (var row in section.rows) {
        for (var seat in row.seats) {
          if (seat != null && seat.isSelected) {

            // Apply family member price for the available family quota
            totalPrice += double.tryParse(section.m_price) ?? 0.0;


          }
        }
      }
    }

    totalAmount = totalPrice.toString();
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth1 = MediaQuery.of(context).size.width;
    double screenHeight1 = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Hall Booking")),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<Seat> selectedSeats = getSelectedSeats();
          if (selectedSeats.isNotEmpty) {
            showToastMessage(
                "Selected Seats: ${selectedSeats.map((seat) => seat.id).join(", ")}");
          } else {
            showToastMessage("No seats selected.");
          }
        },
        child: Icon(Icons.check),
      ),*/
      body: isVisible== true? Padding(
        padding: EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
            ? Center(child: Text("Failed to load data"))
            : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stage Representation
              Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  width: Get.size.width,
                  // Adjust width to match your stage size
                  height: 50,
                  // Height of the stage
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/screen-bg.png',
                      // Replace with your actual asset path
                      fit: BoxFit
                          .cover, // Ensures the image fills the container
                    ),
                  ),
                ),
              ),


              Center(
                child: LayoutBuilder(

                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    double screenHeight = constraints.maxHeight;

                    // Dynamically adjust scale based on screen size
                    double seatGridWidth = 500; // Adjust based on your seat layout width
                    double seatGridHeight = 600; // Adjust based on your seat layout height
                    minScale = screenWidth / seatGridWidth; // Fit screen width

                    return InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: EdgeInsets.all(10),
                      minScale: minScale,
                      maxScale: maxScale,
                      scaleEnabled: true,
                      panEnabled: true,
                      /*child: GestureDetector(
                                  onDoubleTapDown: (details) {
                                    _doubleTapDetails = details;
                                  },
                                  onDoubleTap: () {
                                    if (_transformationController.value.getMaxScaleOnAxis() > minScale) {
                                      _transformationController.value = Matrix4.identity()..scale(minScale);
                                    } else {
                                      final position = _doubleTapDetails!.localPosition;
                                      _transformationController.value = Matrix4.identity()
                                        ..translate(-position.dx * 1.5, -position.dy * 1.5)
                                        ..scale(1.5);
                                    }
                                  },*/
                      child:
                      SizedBox(
                        width: MediaQuery.of(context).size.width,  // Full width
                        height: MediaQuery.of(context).size.width-100, // Full height
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: buildSeatLayout(screenWidth1,screenHeight1),
                        ),
                      ),



                    );
                  },
                ),
              ),
              buildLegend(),
              Text(
                "      Total Price: \₹${calculateTotalPrice().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              Visibility(
                  visible: isVisible,
                  child: GestButton(
                      height: 50,
                      Width: Get.size.width - 40,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      buttoncolor: Colors.pinkAccent,
                      buttontext: "Book Now".tr,
                      style: TextStyle(
                        color: WhiteColor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 15,
                      ),
                      onclick: () {
                        // print(familyCount);

                        selectedSeats =
                            getSelectedSeats();
                        if (selectedSeats.isNotEmpty) {

                          showBookingPopup(
                              context, selectedSeats);

                        } else {
                          showToastMessage(
                              "No seats selected.");
                        }
                      })),

            ],
          ),
        ),
      ): buildQRHallPage(
          hallResponse?.bhogData?.hallDetails?.first.eventName?? '',
          "1;${hallResponse?.bhogData?.hallDetails?.first.eventId};${hallResponse?.bhogData?.hallDetails?.first.eventName};${hallResponse?.bhogData?.hallDetails?.first.bhogId};${hallResponse?.bhogData?.hallDetails?.first.familyCount};${hallResponse?.bhogData?.hallDetails?.first.guestCount};${hallResponse?.bhogData?.hallDetails?.first.username};${hallResponse?.bhogData?.hallDetails?.first.userId!};${hallResponse?.bhogData?.hallDetails?.first.paymentStatus};${hallResponse?.bhogData?.hallDetails?.first.date}",
          hallResponse?.bhogData?.hallDetails?.first.collected?? '0',
          hallResponse?.bhogData?.hallDetails?.first.pending?? '0',
          hallResponse?.bhogData?.hallDetails?.first.date?? '',
          hallResponse?.bhogData?.hallDetails?.first.time?? '',
          hallResponse?.bhogData?.hallDetails?.first.venue_name?? '',
          hallResponse?.bhogData?.hallDetails?.first.paymentStatus?? '0',
          (int.parse(hallResponse?.bhogData?.hallDetails?.first.familyCount?? '0') +
              int.parse(hallResponse?.bhogData?.hallDetails?.first.guestCount?? '0')).toString(),
          hallResponse?.bhogData?.hallDetails?.first.seats?? ''),);
  }


  Widget buildSeatLayout(double width, double height) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...?productResponse?.catEventData.map((section) {
            //bool isSectionEnabled = section.package_id == enabledSectionId; // Check if this section is enabled

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    section.name +" "+section.m_price,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: /*isSectionEnabled
                                    ?*/ Colors.black
                      /*: Colors
                                    .grey*/, // Dim text for disabled sections
                    ),
                  ),
                ),
                Column(
                  children: section.rows.map((row) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0),
                      child: Row(
                        children: row.seats.map((seat) {
                          if (seat == null) {
                            // Add blank space for null seats
                            return SizedBox(
                              width:
                              40, // Width of the blank space
                              child: Container(
                                margin: const EdgeInsets
                                    .symmetric(
                                    horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Colors
                                          .transparent),
                                ),
                              ),
                            );
                          }

                          // Check if seat is clickable based on the section's enabled status
                          return GestureDetector(
                            onTap: /*isSectionEnabled
                                          ?*/ () => toggleSeatSelection(
                                seat)
                            /*: null*/,
                            // Disable click if the section is not enabled
                            child: Container(
                              margin: const EdgeInsets
                                  .symmetric(horizontal: 4),
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: seat?.isSold ?? false
                                    ? Colors.grey
                                    : seat!.isSelected
                                    ? Colors.green
                                    : (seat.type ==
                                    "bestseller"
                                    ? Colors.yellow
                                    : /*isSectionEnabled
                                              ?*/ Colors
                                    .white
                                    /* : Colors
                                              .black12*/),
                                // Dim seat colors for disabled sections
                                border: Border.all(
                                    color: Colors.black),
                                borderRadius:
                                BorderRadius.circular(
                                    4),
                              ),
                              child: Center(
                                child: Text(
                                  seat?.id ?? '',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: seat?.isSold ??
                                        false
                                        ? Colors.black54
                                        : /*isSectionEnabled
                                                  ?*/ Colors.black
                                    /*: Colors
                                                  .grey*/, // Dim text color for disabled sections
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
                Divider(),
              ],
            );
          }),

          /*Visibility(
                      visible: isVisible,
                      child: Text(
                        "     You can book maximum ${familyMemberCount} tickets.",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),*/


          /*if (selectedSeats.isNotEmpty) {


                    if(alloption == "freeForAll"){
                      if (familyCount > 0) {
                        //showToastMessage("Please Select Your Favorite Ticket!".tr);
                        loginController.addBhogFreePaymentImage(
                            " ",
                            "no_image",
                            totalAmount,
                            eventId,
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
                    }else {
                      if (familyMemberCount > 1) {
                        if (familyMemberCount >= familyCount) {
                          if (totalAmount != "0") {
                            Get.toNamed(
                              Routes.bhogPaymentScreen,
                              arguments: {
                                "amount": totalAmount,
                                "mCount": familyCount.toString(),
                                "gCount": guestCount.toString(),
                                "bhogid": eventId,
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
                                eventId,
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

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please check your ticket count is more than your family member count. Your family member count is ${familyMemberCount}. Please add extra member as guest.',
                              ),
                              */ /* action: SnackBarAction(
                                        label: 'Update Member',
                                        onPressed: () {
                                          Get.to(() => MemberProfileScreen());
                                        },
                                      ),*/ /*
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              // Ensures it takes only as much space as necessary
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // Full message text
                                Text(
                                  'Please update your family member list from My Profile before booking. There is no family member added in your account.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                // Add spacing between the text and buttons
                                // Row with two buttons
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  // Align buttons to the right
                                  children: [
                                    // "My Profile" Button
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        Get.off(() =>
                                            MemberProfileScreen()); // Navigate to My Profile
                                      },
                                      child: Text(
                                        'My Profile',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    // "Continue" Button
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        // Add action for Continue button here
                                        if (familyMemberCount >=
                                            familyCount) {
                                          if (totalAmount != "0") {
                                            Get.toNamed(
                                              Routes.bhogPaymentScreen,
                                              arguments: {
                                                "amount": totalAmount,
                                                "mCount": familyCount
                                                    .toString(),
                                                "gCount": guestCount.toString(),
                                                "bhogid": eventId,
                                                "edate": date,
                                                "textname": textname,
                                                "eventName": eventName,
                                                "eventId": eventId
                                              },
                                            );
                                          } else if (familyCount > 0) {
                                            //showToastMessage("Please Select Your Favorite Ticket!".tr);
                                            loginController
                                                .addBhogFreePaymentImage(
                                                " ",
                                                "no_image",
                                                totalAmount,
                                                eventId,
                                                familyCount
                                                    .toString(),
                                                guestCount.toString(),
                                                eventId,
                                                date,
                                                eventName,
                                                textname);
                                          } else {
                                            ScaffoldMessenger.of(
                                                context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Please select number of member for booking .',
                                                ),
                                                duration:
                                                Duration(seconds: 5),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Please check your ticket count is more than your family member count. Your family member count is ${familyMemberCount}. ',
                                              ),
                                              action: SnackBarAction(
                                                label: 'Update Member',
                                                onPressed: () {
                                                  Get.to(() =>
                                                      MemberProfileScreen());
                                                },
                                              ),
                                              duration: Duration(
                                                  seconds: 5),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            backgroundColor: Colors.black,
                            // Customize SnackBar background
                            duration: Duration(
                                seconds:
                                5), // Duration the SnackBar is shown
                          ),
                        );
                      }
                    }


                    //showToastMessage("Selected Seats: ${selectedSeats.map((seat) => seat.id).join(", ")}");
                  } else {
                    showToastMessage("No seats selected.");
                  }*/

          // Your legend widget
        ],
      ),
    );
  }

  Widget buildQRHallPage(String title, String qrData, String collected,
      String pending,String date,String time,String venue_name, String status,String totalcount,String seats) {
    return Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0),child:Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 24,
            ),
          ),
        ),
        Center(
          child: Text(
            "Venue: ${venue_name}",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 16,
            ),
          ),
        ),
        Center(
          child: Text(
            formatDate(date),
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 16,
            ),
          ),
        ),
       Center(
          child: Text(
            formatTimeRange(time),
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 14,
            ),
          ),
        ),


        SizedBox(height: 10),
        Center(
          child: Text(
            totalcount+" Seats Booked",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: Text(
            "Seats: "+seats,
            style: TextStyle(
              color: Colors.cyan,
              fontFamily: "Gilroy Bold",
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0, // QR code size
                gapless: false,
              ),
            ),


          ],
        ),

        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                "Collected: ${collected}", // Example collected value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 45),
              child: Text(
                "Pending: ${pending}", // Example pending value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),

        SizedBox(width: 20),


      ],
    ));
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

  String formatTimeRange(String timeRange) {
    List<String> times = timeRange.split('-'); // Split start and end times
    DateFormat inputFormat = DateFormat("HH:mm:ss"); // 24-hour format
    DateFormat outputFormat = DateFormat("hh:mm a"); // 12-hour AM/PM format

    String startTime = outputFormat.format(inputFormat.parse(times[0])); // Convert start time
    String endTime = outputFormat.format(inputFormat.parse(times[1]));   // Convert end time

    return "$startTime - $endTime"; // Return formatted time range
  }

  void showBookingPopup(BuildContext context, List<Seat> selectedSeats) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Booking Confirm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please Note: Before booking in, ensure the following:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurpleAccent),
              ),
              Text(
                'Are you sure to book these seats?\nOnce book you can not change the seats.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10), // Adds some spacing between the texts
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancle',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
            ),
            // Login Button
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
                // Add your login action here

                //bookTicketOfEvent();

                /* loginController.bookTicketPaymentImage(
                    " ",
                    "no_image",
                    "0",
                    eventId,
                    selectedSeats.length.toString(),
                    "0",
                    eventId,
                    date,
                    eventName,
                    textname,
                    selectedSeats.map((seat) => seat.id).join(", "));*/
                print("object"+totalAmount);
                List<Seat> selectedSeats = getSelectedSeats();
                if (totalAmount != "0.0") {
                  Get.toNamed(
                    Routes.kclubEventPaymentScreen,
                    arguments: {
                      "amount": totalAmount,
                      "mCount": selectedSeats.length.toString(),
                      "gCount": guestCount.toString(),
                      "bhogid": bhogid,
                      "edate": date,
                      "textname": textname,
                      "eventName": eventName,
                      "eventId": eventId,
                      "hall_id":productResponse?.catEventData.first.hall_id,
                      "selected_seat": selectedSeats.map((seat) => seat.id).join(", "),
                    },
                  );
                } else  {
                  //showToastMessage("Please Select Your Favorite Ticket!".tr);
                  //bookTicketOfEvent();



                  loginController.bookFreeTicketPaymentImageKclub(
                      " ",
                      "no_image",
                      "0",
                      eventId,
                      selectedSeats.length.toString(),
                      "0",
                      eventId,
                      date,
                      eventName,
                      textname,
                      selectedSeats.map((seat) => seat.id).join(", "));

                }

              },
            ),
          ],
        );
      },
    );
  }

  // Function to get all selected seats
  List<Seat> getSelectedSeats() {
    List<Seat> selectedSeats = [];
    for (var section in productResponse?.catEventData ?? []) {
      for (var row in section.rows) {
        for (var seat in row.seats) {
          if (seat != null && seat.isSelected) {
            selectedSeats.add(seat);
          }
        }
      }
    }
    return selectedSeats;
  }

  bookTicketOfEvent() async {
    try {
      List<Seat> selectedSeats = getSelectedSeats();
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "event_id": eventId,
        "hall_id": productResponse?.catEventData.first.hall_id,
        "selected_seat": selectedSeats.map((seat) => seat.id).join(", "),

      };

      print("Data" + map.toString());
      Uri uri = Uri.parse(Config.baseurlKclub + Config.bookHallTicket);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage(result["ResponseMsg"]);
        // Get.back();
      }
    } catch (e) {
      print(e.toString());
    }
  }

// Example: Display selected seats
  void displaySelectedSeats() {
    List<Seat> selectedSeats = getSelectedSeats();
    print("Selected Seats:");
    for (var seat in selectedSeats) {
      print("Seat ID: ${seat.id}");
    }
  }

  Widget buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildLegendItem(Colors.white70, "Available"),
          buildLegendItem(Colors.green, "Selected"),
          buildLegendItem(Colors.grey, "Booked"),
          // buildLegendItem(Colors.yellow, "Bestseller"),
        ],
      ),
    );
  }

  Widget buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Text(label),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color, // Dim seat colors for disabled sections
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}



class Seat {
  final String? id;
  final String? type;
  final bool? isSold;
  bool isSelected; // Add this

  Seat({this.id, this.type, this.isSold, this.isSelected = false});

  /* factory Seat.fromJson(Map<String, dynamic>? json) {
    if (json == null) return null!;
    return Seat(
      id: json['id'],
      type: json['type'],
      isSold: json['isSold'],
      isSelected: false, // Default value
    );
  }*/

  factory Seat.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Seat(); // Return a default Seat object for null cases
    }
    return Seat(
      id: json['id'] as String?,
      type: json['type'] as String?,
      isSold: json['isSold'] as bool?,
      isSelected: false,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'id': id,
      'type': type,
      'isSelected': isSelected,
      'isSold': isSold,
    };
  }
}

// Model for Row
class RowData {
  final String rowName;
  final List<Seat?> seats;

  RowData({required this.rowName, required this.seats});

  factory RowData.fromJson(Map<String, dynamic> json) {
    return RowData(
      rowName: json['rowName'],
      seats: (json['seats'] as List).map((seat) {
        if (seat == null) {
          return null; // Preserve null values
        }
        return Seat.fromJson(seat);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rowName': rowName,
      'seats': seats.map((seat) => seat?.toJson()).toList(),
    };
  }
}

// Model for Section
class Section {
  final String name;
  final String package_id;
  final String m_price;
  final String g_price;
  final String hall_id;
  final List<RowData> rows;

  Section(
      {required this.name,
        required this.package_id,
        required this.m_price,
        required this.g_price,
        required this.hall_id,
        required this.rows});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      name: json['name'],
      package_id: json['package_id'],
      m_price: json['m_price'],
      g_price: json['g_price'],
      hall_id: json['hall_id'],
      rows: (json['rows'] as List).map((row) => RowData.fromJson(row)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'package_id': package_id,
      'm_price': m_price,
      'g_price': g_price,
      'hall_id': hall_id,
      'rows': rows.map((row) => row.toJson()).toList(),
    };
  }
}

// Model for the overall response
class TheaterResponse {
  final String responseCode;
  final String result;
  final String responseMsg;
  final List<Section> catEventData;

  TheaterResponse({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.catEventData,
  });

  factory TheaterResponse.fromJson(Map<String, dynamic> json) {
    return TheaterResponse(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
      catEventData: (json['CatEventData'] as List)
          .map((section) => Section.fromJson(section))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseCode': responseCode,
      'Result': result,
      'ResponseMsg': responseMsg,
      'CatEventData': catEventData.map((section) => section.toJson()).toList(),
    };
  }
}
