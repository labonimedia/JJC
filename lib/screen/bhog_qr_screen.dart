import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model/BhogDetails.dart';
import '../model/BhogDetailsNew.dart';
import '../utils/Colors.dart';

class BhogQRScreen extends StatefulWidget {
  @override
  _BhogQRScreenState createState() => _BhogQRScreenState();
}

class _BhogQRScreenState extends State<BhogQRScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String ticketData;
  int _currentPageIndex = 0;
  late TabController _tabController;
  late TabController _innerTabController1;
  late TabController _innerTabController2;
  late TabController _innerTabController3;

  PageController _pageController = PageController(initialPage: 0);
  HallResponse? hallResponse, hallResponseOther,hallResponseKclub;

  //late ApiResponse apiResponse;
  ApiResponse apiResponse = ApiResponse(
    bhogdata: BhogData(
      bhogdetails: [],
    ),
    responseCode: '',
    result: '',
    responseMsg: '',
  );

  ApiResponse? apiResponseOther;
  ApiResponseNew? apiResponseKlub;
  bool isLoading = true; // Loading flag
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    ticketData =
        "dsadsd;2;22;23;33"; // Initialize the ticketData with default QR code data
    loadData();
    _tabController = TabController(length: 3, vsync: this);
    _innerTabController1 = TabController(length: 2, vsync: this); // Inner tabs for first tab
    _innerTabController2 = TabController(length: 2, vsync: this); // Two tabs
    _innerTabController3 = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    _innerTabController1.dispose();
    _innerTabController2.dispose();
    _innerTabController3.dispose();
    _pageController.dispose();
    super.dispose();
  }

  loadData() async {
    // Load your data here if needed

    try {
      final data = await getbookingInfo();
      final data1 = await getHallBookingInfo();
      final data2 = await getbookingOtherInfo();
      final data3 = await getHallBookingOtherInfo();
      final data4= await getbookingInfoKclub();
      final data5= await getHallBookingInfoKlub();



      setState(() {
        apiResponse = data;
        hallResponse = data1;
        apiResponseOther = data2;
        hallResponseOther = data3;
        apiResponseKlub =data4;
        hallResponseKclub= data5;
        isLoading = false; // Data loaded successfully, stop loading
      });
    } catch (error) {
      setState(() {
        hasError = true; // An error occurred while loading data
        isLoading = false;
      });
    }
  }

  void _nextPage() {
    if (_currentPageIndex < apiResponse.bhogdata!.bhogdetails!.length) {
      // Assuming 3 pages (0, 1, 2)
      _currentPageIndex++;
      _pageController.animateToPage(_currentPageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      _currentPageIndex--;
      _pageController.animateToPage(_currentPageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _nextPage1() {
    if (_currentPageIndex < hallResponse!.bhogData!.hallDetails!.length) {
      // Assuming 3 pages (0, 1, 2)
      _currentPageIndex++;
      _pageController.animateToPage(_currentPageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _previousPage1() {
    if (_currentPageIndex > 0) {
      _currentPageIndex--;
      _pageController.animateToPage(_currentPageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  Future getbookingInfo() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.bhogBookingDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print("sdasd" + response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      ApiResponse bhogResponse = ApiResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
      // showToastMessage(result["ResponseMsg"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future getbookingOtherInfo() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.bhogBookingOtherDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print("sdasd" + response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      ApiResponse bhogResponse = ApiResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
      // showToastMessage(result["ResponseMsg"]);
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future getbookingInfoKclub() async {
    final Uri uri = Uri.parse(Config.baseurlKclub + Config.bhogBookingDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print("sdasd" + response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      ApiResponseNew bhogResponse = ApiResponseNew.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
      // showToastMessage(result["ResponseMsg"]);
    } else {
      throw Exception('Failed to load data');
    }
  }




  Future getHallBookingInfo() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.hallBookingDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
      }),
      headers: {"Content-Type": "application/json"},
    );
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

  Future getHallBookingOtherInfo() async {
    final Uri uri = Uri.parse(Config.baseurl + Config.hallBookingOtherDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
      }),
      headers: {"Content-Type": "application/json"},
    );
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



  Future getHallBookingInfoKlub() async {
    final Uri uri = Uri.parse(Config.baseurlKclub + Config.hallBookingDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
      }),
      headers: {"Content-Type": "application/json"},
    );
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


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Container(
              height: MediaQuery.of(context).size.height * 0.12,
              alignment: Alignment.center,
              child: Text(
                "Booking QR Code".tr,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 18,
                ),
              ),
            ),

            // Main Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              indicatorWeight: 3,
              labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Group Event".tr),
                Tab(text: "Other Event".tr),
                Tab(text: "Karaoke Event".tr),
              ],
            ),

            // Main TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // First Main Tab - Program Booking
                  Column(
                    children: [
                      // Inner TabBar
                      TabBar(
                        controller: _innerTabController1,
                        labelColor: Colors.black,
                        indicatorColor: Colors.blue,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(text: "Indoor"),
                          Tab(text: "Outdoor"),
                        ],
                      ),

                      // Inner TabBarView
                      Expanded(
                        child: TabBarView(
                          controller: _innerTabController1,
                          children: [
                            _buildProgramBookingIndoorContent(isIndoor: true),
                            _buildProgramBookingOutdoorContent(isIndoor: false),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Second Main Tab - Other Program Booking
                  Column(
                    children: [
                      // Inner TabBar
                      TabBar(
                        controller: _innerTabController2,
                        labelColor: Colors.black,
                        indicatorColor: Colors.blue,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(text: "Indoor"),
                          Tab(text: "Outdoor"),
                        ],
                      ),

                      // Inner TabBarView

                      Expanded(
                        child: TabBarView(
                          controller: _innerTabController2,
                          children: [
                            _buildOtherProgramBookingIndoorContent(
                                isIndoor: true),
                            _buildOtherProgramBookingOutdoorContent(
                                isIndoor: false),
                          ],
                        ),
                      ),
                    ],
                  ),


                  Column(
                    children: [
                      // Inner TabBar
                      TabBar(
                        controller: _innerTabController3,
                        labelColor: Colors.black,
                        indicatorColor: Colors.blue,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(text: "Indoor"),
                          Tab(text: "Outdoor"),
                        ],
                      ),

                      // Inner TabBarView

                      Expanded(
                        child: TabBarView(
                          controller: _innerTabController3,
                          children: [
                            _buildKclubProgramBookingIndoorContent(
                                isIndoor: true),
                            _buildKclubProgramBookingOutdoorContent(
                                isIndoor: false),
                          ],
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramBookingOutdoorContent({required bool isIndoor}) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.001,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                        ? Center(child: Text('No data available.'.tr))
                        : (apiResponse?.bhogdata?.bhogdetails ?? []).isEmpty
                            ? Center(child: Text('No data available.'.tr))
                            : Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentPageIndex = index;
                                          });
                                        },
                                        children: apiResponse!
                                            .bhogdata!.bhogdetails!
                                            .map((detail) {
                                          return buildPage(
                                            detail.eventName!,
                                            "0;${detail.eventId};${detail.eventName};${detail.bhogid};${detail.familyCount};${detail.guestCount};${detail.username};${detail.userid};${detail.paymentStatus};${detail.date};${detail.alloption}",
                                            detail.collected!,
                                            detail.pending!,
                                            detail.date!,
                                            detail.time!,
                                            detail.venue_name ?? '',
                                            detail.paymentStatus!,
                                            (int.parse(detail.familyCount!) +
                                                    int.parse(
                                                        detail.guestCount!))
                                                .toString(),
                                            "",
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 150),
                                  ],
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherProgramBookingOutdoorContent({required bool isIndoor}) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.001,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                        ? Center(child: Text('No data available.'.tr))
                        : (apiResponseOther?.bhogdata?.bhogdetails ?? [])
                                .isEmpty
                            ? Center(child: Text('No data available.'.tr))
                            : Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentPageIndex = index;
                                          });
                                        },
                                        children: apiResponseOther!
                                            .bhogdata!.bhogdetails!
                                            .map((detail) {
                                          return buildPage(
                                            detail.eventName!,
                                            "0;${detail.eventId};${detail.eventName};${detail.bhogid};${detail.familyCount};${detail.guestCount};${detail.username};${detail.userid};${detail.paymentStatus};${detail.date};${detail.alloption}",
                                            detail.collected!,
                                            detail.pending!,
                                            detail.date!,
                                            detail.time!,
                                            detail.venue_name ?? '',
                                            detail.paymentStatus!,
                                            (int.parse(detail.familyCount!) +
                                                    int.parse(
                                                        detail.guestCount!))
                                                .toString(),
                                            "",
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 150),
                                  ],
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKclubProgramBookingOutdoorContent({required bool isIndoor}) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.001,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                    ? Center(child: Text('No data available.'.tr))
                    : (apiResponseKlub?.bhogdata?.bhogdetails ?? []).isEmpty
                    ? Center(child: Text('No data available.'.tr))
                    : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          children: apiResponseKlub!
                              .bhogdata!.bhogdetails!
                              .map((detail) {
                            return buildPage(
                              detail.eventName!,
                              "0;${detail.eventId};${detail.eventName};${detail.bhogid};${detail.familyCount};${detail.guestCount};${detail.username};${detail.userid};${detail.paymentStatus};${detail.date};${detail.alloption}",
                              detail.collected!,
                              detail.pending!,
                              detail.date!,
                              detail.time!,
                              detail.venue_name ?? '',
                              detail.paymentStatus!,
                              (int.parse(detail.familyCount!) +
                                  int.parse(
                                      detail.guestCount!))
                                  .toString(),
                              detail.kseats ?? '',
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build Other Program Booking Content
  Widget _buildProgramBookingIndoorContent({required bool isIndoor}) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.001,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                        ? Center(child: Text('No data available.'.tr))
                        : (hallResponse?.bhogData?.hallDetails ?? []).isEmpty
                            ? Center(child: Text('No data available.'.tr))
                            : Form(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentPageIndex = index;
                                          });
                                        },
                                        children: hallResponse!
                                            .bhogData!.hallDetails!
                                            .map((detail) {
                                          return buildQRHallPage(
                                            detail.eventName!,
                                            "1;${detail.eventId};${detail.eventName};${detail.bhogId!};${detail.familyCount};${detail.guestCount};${detail.username};${detail.userId!};${detail.paymentStatus};${detail.date}",
                                            detail.collected!,
                                            detail.pending!,
                                            detail.date!,
                                            detail.time!,
                                            detail.venue_name ?? "",
                                            detail.paymentStatus!,
                                            (int.parse(detail.familyCount!) +
                                                    int.parse(
                                                        detail.guestCount!))
                                                .toString(),
                                            detail.seats!,
                                            ""
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 150),
                                  ],
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherProgramBookingIndoorContent({required bool isIndoor}) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.001,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                        ? Center(child: Text('No data available.'.tr))
                        : (hallResponseOther?.bhogData?.hallDetails ?? [])
                                .isEmpty
                            ? Center(child: Text('No data available.'.tr))
                            : Form(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentPageIndex = index;
                                          });
                                        },
                                        children: hallResponseOther!
                                            .bhogData!.hallDetails!
                                            .map((detail) {
                                          return buildQRHallPage(
                                            detail.eventName!,
                                            "1;${detail.eventId};${detail.eventName};${detail.bhogId!};${detail.familyCount};${detail.guestCount};${detail.username};${detail.userId!};${detail.paymentStatus};${detail.date}",
                                            detail.collected!,
                                            detail.pending!,
                                            detail.date!,
                                            detail.time!,
                                            detail.venue_name ?? "",
                                            detail.paymentStatus!,
                                            (int.parse(detail.familyCount!) +
                                                    int.parse(
                                                        detail.guestCount!))
                                                .toString(),
                                            detail.seats!,
                                            ""
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 150),
                                  ],
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKclubProgramBookingIndoorContent({required bool isIndoor}) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.001,
              child: Container(
                height: Get.height,
                width: Get.size.width,
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                    ? Center(child: Text('No data available.'.tr))
                    : (hallResponseKclub?.bhogData?.hallDetails ?? []).isEmpty
                    ? Center(child: Text('No data available.'.tr))
                    : Form(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          children: hallResponseKclub!
                              .bhogData!.hallDetails!
                              .map((detail) {
                            return buildQRHallPage(
                              detail.eventName!,
                              "1;${detail.eventId};${detail.eventName};${detail.bhogId!};${detail.familyCount};${detail.guestCount};${detail.username};${detail.userId!};${detail.paymentStatus};${detail.date}",
                              detail.collected!,
                              detail.pending!,
                              detail.date!,
                              detail.time!,
                              detail.venue_name ?? "",
                              detail.paymentStatus!,
                              (int.parse(detail.familyCount!) +
                                  int.parse(
                                      detail.guestCount!))
                                  .toString(),
                              detail.seats!,
                              detail.kseats?? '',
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each page with QR code
  Widget buildPage(
      String title,
      String qrData,
      String collected,
      String pending,
      String date,
      String time,
      String venue_name,
      String status,
      String totalcount,
      String kseats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            // Adjust as needed
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Gilroy Bold",
                fontSize: 24,
              ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, size: 40),
              onPressed: _previousPage,
            ),
            SizedBox(width: 20),
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0, // QR code size
                gapless: false,
              ),
            ),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.arrow_forward, size: 40),
              onPressed: _nextPage,
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                "Entered: ${collected}", // Example collected value
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Total Booking: " + totalcount,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              /* Text(
                "Payment for Extras: ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),*/
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: status == "0"
                  ? Text(
                      "Payment for Extras: Pending",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "Payment for Extras: Paid",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              /* Text(
                "Payment for Extras: ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),*/
            ),
          ],
        ),
        SizedBox(height: 10,),
        kseats.isNotEmpty?
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Performance Booking: " + kseats,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              /* Text(
                "Payment for Extras: ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),*/
            ),
          ],
        ): SizedBox(),
      ],
    );
  }

  Widget buildQRHallPage(
      String title,
      String qrData,
      String collected,
      String pending,
      String date,
      String time,
      String venue_name,
      String status,
      String totalcount,
      String seats,
      String kseats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            // Adjust as needed
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Gilroy Bold",
                fontSize: 24,
              ),
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
        SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            totalcount + " Tickets Booked",
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
            "Seats: " + seats,
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
            IconButton(
              icon: Icon(Icons.arrow_back, size: 40),
              onPressed: _previousPage1,
            ),
            SizedBox(width: 20),
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0, // QR code size
                gapless: false,
              ),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.arrow_forward, size: 40),
              onPressed: _nextPage1,
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                "Entered: ${collected}", // Example collected value
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
        SizedBox(height: 20),
        kseats.isNotEmpty?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                "Performance Booking : ${kseats}", // Example collected value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),

          ],
        ): SizedBox(),
      ],
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

  String formatTimeRange(String timeRange) {
    List<String> times = timeRange.split('-'); // Split start and end times
    DateFormat inputFormat = DateFormat("HH:mm:ss"); // 24-hour format
    DateFormat outputFormat = DateFormat("hh:mm a"); // 12-hour AM/PM format

    String startTime =
        outputFormat.format(inputFormat.parse(times[0])); // Convert start time
    String endTime =
        outputFormat.format(inputFormat.parse(times[1])); // Convert end time

    return "$startTime - $endTime"; // Return formatted time range
  }
}

class HallResponse {
  final String? responseCode;
  final String? result;
  final String? responseMsg;
  final HallData? bhogData;

  HallResponse({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.bhogData,
  });

  factory HallResponse.fromJson(Map<String, dynamic> json) {
    return HallResponse(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
      bhogData:
          json['bhogdata'] != null ? HallData.fromJson(json['bhogdata']) : null,
    );
  }
}

class HallData {
  final List<HallDetail>? hallDetails;

  HallData({this.hallDetails});

  factory HallData.fromJson(Map<String, dynamic> json) {
    return HallData(
      hallDetails: (json['bhogdetails'] as List<dynamic>?)
          ?.map((e) => HallDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HallDetail {
  final String? id;
  final String? eventId;
  final String? seats;
  final String? bhogId;
  final String? eventName;
  final String? guestCount;
  final String? familyCount;
  final String? username;
  final String? userId;
  final String? paymentStatus;
  final String? date;
  final String? flag;
  final String? collected;
  final String? pending;
  final String? time;
  final String? venue_name;
  final String? kseats;

  HallDetail({
    this.id,
    this.eventId,
    this.seats,
    this.bhogId,
    this.eventName,
    this.guestCount,
    this.familyCount,
    this.username,
    this.userId,
    this.paymentStatus,
    this.date,
    this.flag,
    this.collected,
    this.pending,
    this.time,
    this.venue_name,
    this.kseats,
  });

  factory HallDetail.fromJson(Map<String, dynamic> json) {
    return HallDetail(
      id: json['id'],
      eventId: json['eventId'],
      seats: json['seats'],
      bhogId: json['bhogid'],
      eventName: json['eventName'],
      guestCount: json['guestCount'],
      familyCount: json['familyCount'],
      username: json['username'],
      userId: json['userid'],
      paymentStatus: json['paymentStatus'],
      date: json['date'],
      flag: json['flag'],
      collected: json['collected'],
      pending: json['pending'],
      time: json['time'] as String?,
      venue_name:
          json['venue_name'] != null ? json['venue_name'] as String? : null,
      kseats:
      json['kseats'] != null ? json['kseats'] as String? : null,
    );
  }
}
