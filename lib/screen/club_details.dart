// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, deprecated_member_use, must_be_immutable, sized_box_for_whitespace, avoid_unnecessary_containers
import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jjcentre/screen/seeAll/gallery_view.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller/club_controller.dart';
import '../controller/club_signup_controller.dart';
import '../controller/eventdetails_controller.dart';
import '../controller/eventdetails_controller1.dart';
import '../controller/home_controller.dart';
import '../helpar/routes_helpar.dart';
import '../model/ResponseData.dart';
import '../model/fontfamily_model.dart';
import '../utils/Colors.dart';
import '../utils/Custom_widget.dart';
import '../utils/group_image_screen.dart';
import '../utils/story_details.dart';
import 'LoginAndSignup/login_screen.dart';
import 'club_membership_screen.dart';

class ClubDetailsScreen extends StatefulWidget {
  final String? orgImg;
  final String? orgId;
  final String? orgName;
  final String? orgAddresss;

  ClubDetailsScreen(
      {super.key, this.orgImg, this.orgId, this.orgName, this.orgAddresss});

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HomePageController homePageController = Get.find();
  ClubSignUpController signUpController = Get.find();
  EventDetailsController1 eventDetailsController = Get.find();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController comment = TextEditingController();
  String cuntryCode = "";
  bool isConnected = true; // Track internet connectivity status
  late StreamSubscription<ConnectivityResult> connectivitySubscription;


  final List<Story> stories = [
    Story(
      title: "Achievement 1",
      description: "This is a short description of the achievement...",
      imageUrl: "http://143.244.139.253/images/gallery/17393563703.jpeg",
      fullDescription: "This is the full description of achievement 1...",
    ),
    Story(
      title: "Achievement 2",
      description: "A great milestone reached...",
      imageUrl: "http://143.244.139.253/images/gallery/17393563703.jpeg",
      fullDescription: "This is the detailed story of how we achieved this...",
    ),
    Story(
      title: "Story 1",
      description: "An inspiring journey...",
      imageUrl: "http://143.244.139.253/images/gallery/17393563703.jpeg",
      fullDescription: "Full story details go here...",
    ),
  ];


  //String? clubName = widget.orgName;
  final List<String> galleryImages = [
    'https://example.com/image1.jpg',
  ];
  final String clubDescription =
      "This is the club description. It provides details about the club.";
  final List<String> events = [
    "Event 1 - 20th September",
    "Event 2 - 25th September",
    "Event 3 - 30th September",
  ];
  final String contactInfo = "Email: club@example.com\nPhone: +1234567890";

  //final String address = "123 Club Street, City, Country";
  late List<Club> clubs = [];
  ResponseData? responseData;
  bool isLoading = true; // Loading flag
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    loadData();
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    // Check for internet connectivity at the start
    _checkInternetConnection();
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription
        .cancel(); // Cancel subscription when the widget is disposed
  }

  Future<void> _checkInternetConnection() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      isConnected = (result != ConnectivityResult.none);
    });
  }

  loadData() async {
    try {
      final data = await getClubDataApi(widget.orgId);
      final data1 = await getClubData(widget.orgId);
      setState(() {
        clubs = data;
        responseData = data1;
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

   /* if (getData.read("UserLogin") != null) {
      //Get.to(() => MyClubScreen());
    } else {
      showLoginPopup(context);
    }*/
  }


  void showLoginPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aami Bengali'),
          content: Text('Are you a member of this club? Please login.'),
          actions: <Widget>[
            // Close Button
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
            ),
            // Login Button
            TextButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
                // Add your login action here
                print("Navigate to login page");
                Get.to(() => LoginScreen());
                // Example: You can navigate to the login page using GetX or Navigator
                // Get.to(LoginPage());
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /*responseData?.homeData.bannerList.isNotEmpty ?? false
          ?*/ CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(7),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back,
                        color: WhiteColor,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF000000).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  expandedHeight: Get.height * 0.29,
                  bottom: PreferredSize(
                    child: Container(),
                    preferredSize: Size(0, 20),
                  ),
                  flexibleSpace: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: Get.height * 0.34,
                          width: double.infinity,
                          child: cs.CarouselSlider(
                            options: cs.CarouselOptions(
                              height: Get.size.height / 3,
                              viewportFraction: 1,
                              autoPlay: true,
                            ),
                            items: (responseData?.homeData.bannerList ?? []).isNotEmpty
                                ? responseData!.homeData.bannerList.map<Widget>((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: Get.size.width,
                                    decoration: const BoxDecoration(color: Colors.transparent),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/ezgif.com-crop.gif",
                                      fit: BoxFit.fill,
                                      image: i.img != null && i.img!.isNotEmpty
                                          ? Config.imageUrl + i.img!
                                          : "https://example.com/default_image.png", // Default image URL
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/banner_club.jpg", // Local fallback image
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }).toList()
                                : [
                              // Show a default placeholder if bannerList is empty or null
                              Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: Get.size.width,
                                    decoration: const BoxDecoration(color: Colors.transparent),
                                    child: Image.asset(
                                      "assets/banner_club.jpg", // Local fallback image
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          decoration: BoxDecoration(
                            color: transparent,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(50),
                            ),
                          ),
                        ),
                        bottom: -1,
                        left: 0,
                        right: 0,
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: Colors.white, // Set background color
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: isConnected
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Club Name

                              SizedBox(height: 10),

                              Center(
                                child: Text(
                                  "Welcome To",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  // This will center the Image inside its available space//${Config.imageUrl}
                                  child: Image.network(
                                    (clubs.isNotEmpty)
                                        ? "${Config.imageUrl}${clubs.first.img}"
                                        : "https://example.com/default_image.png", // Replace with your default image URL
                                    width: 150,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/ic_launcher.png", // Local default image
                                        width: 150,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              Center(
                                child: Text(
                                  widget.orgName!,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Center(
                                child: Text(
                                  clubs.isNotEmpty ? (clubs.first.location ?? "") : "",
                                )
                              ),
                              SizedBox(height: 16),

                              getData.read("UserLogin") == null ?
                              GestButton(
                                Width: Get.size.width,
                                height: 50,
                                buttoncolor: Colors.pinkAccent,
                                margin: EdgeInsets.only(
                                    top: 15, left: 30, right: 30),
                                buttontext: "Member's Login".tr,
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyBold,
                                  color: WhiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                onclick: () {
                                  Get.to(() => LoginScreen());
                                },
                              ): SizedBox(),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              // Club Description
                              Center(
                                child: Text(
                                  'About Us',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                clubs.isNotEmpty ? (clubs.first.about?? ""): "",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 16),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              responseData?.homeData.executiveList != null && responseData!.homeData!.executiveList!.isNotEmpty
                                  ?Column(children: [
                                Center(
                                  child: Text(
                                    'Excutive Committee Members',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: FontFamily.gilroyMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // Set the scroll direction to horizontal
                                    itemCount: responseData!
                                        .homeData.executiveList.length,
                                    itemBuilder: (context, index) {
                                      final event = responseData!
                                          .homeData.executiveList[index];
                                      return /*Card(
                                    margin: EdgeInsets.all(10),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:*/ /*Container(
                                      width: 240, // Set a fixed width for the Card
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Event Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: (event.img != null && event.img!.isNotEmpty)
                                                ? Image.network(
                                              Config.imageUrl + event.img!,
                                              height: 150,
                                              width: double.infinity, // Fill all available width
                                              fit: BoxFit.fill, // Fit image to fill the area
                                            )
                                                : Image.asset(
                                              'assets/profile-default.png',
                                              height: 150,
                                              width: double.infinity, // Fill all available width
                                              fit: BoxFit.fill, // Fit image to fill the area
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                // Event Title
                                                Text(
                                                  event.name!,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 8),
                                                // Event Date
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.date_range, size: 16),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      event.executive!,
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                // You can add more information here
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),*/
                                        Container(
                                          width:
                                          180, // Set a fixed width for the card
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            // Center content vertically
                                            children: [
                                              // Circular Image
                                              CircleAvatar(
                                                radius:
                                                50, // Radius of the circular image
                                                backgroundImage: (event.img !=
                                                    null &&
                                                    event.img!.isNotEmpty)
                                                    ? NetworkImage(
                                                    Config.imageUrl +
                                                        event.img!)
                                                as ImageProvider<
                                                    Object> // Use NetworkImage for online images
                                                    : AssetImage(
                                                    'assets/profile-default.png')
                                                as ImageProvider<
                                                    Object>, // Default image from assets
                                              ),
                                              SizedBox(height: 10),
                                              // Space between image and text
                                              // Name
                                              Text(
                                                event.name!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign
                                                    .center, // Center align text
                                              ),
                                              SizedBox(height: 4),
                                              // Space between name and role
                                              // Role
                                              Text(
                                                event.executive!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors
                                                      .grey, // Grey color for role text
                                                ),
                                                textAlign: TextAlign
                                                    .center, // Center align text
                                              ),
                                            ],
                                          ),
                                        );
                                      // );
                                    },
                                  ),
                                ),

                                Divider(
                                  color: Colors.black, // Line color
                                  thickness: 1, // Line thickness
                                  indent: 10, // Left spacing
                                  endIndent: 10, // Right spacing
                                ),

                              ],):SizedBox(),

                              // Events

                              responseData?.homeData.latestEvent != null && responseData!.homeData!.latestEvent!.isNotEmpty
                                  ?Column(children: [

                                Center(
                                  child: Text(
                                    'Centre Program',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: FontFamily.gilroyMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 280,
                                  width: Get.width, // Set height for the ListView
                                  child: Center(
                                    child: ListView.builder(
                                      scrollDirection: Axis
                                          .horizontal, // Scroll horizontally
                                      itemCount: responseData!
                                          .homeData.latestEvent.length,
                                      itemBuilder: (context, index) {
                                        final event = responseData!
                                            .homeData.latestEvent[index];
                                        return InkWell(
                                          onTap: () async {
                                            await eventDetailsController
                                                .getEventData(
                                              eventId: event.eventId,
                                            );
                                            Get.toNamed(
                                              Routes.eventDetailsScreen1,
                                              arguments: {
                                                "eventId": responseData!
                                                    .homeData.latestEvent[index]
                                                    .eventId,
                                                "bookStatus": responseData!.homeData.latestEvent[index].flag,
                                                "maxmember":
                                                homePageController
                                                    .homeInfo
                                                    ?.homeData
                                                    .mainData
                                                    .maxmember,
                                                "maxguest": homePageController
                                                    .homeInfo
                                                    ?.homeData
                                                    .mainData
                                                    .maxguest
                                              },
                                            );
                                          },
                                          child: Container(
                                            width:
                                            200, // Set the width for each card
                                            margin: EdgeInsets.all(10),
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                // Center the content horizontally
                                                children: [
                                                  // Event Image
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(10),
                                                      topRight:
                                                      Radius.circular(10),
                                                    ),
                                                    child: Image.network(
                                                      Config.imageUrl +
                                                          event.eventImg,
                                                      height: 150,
                                                      width: 200,
                                                      // Set width to match the card width
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      // Center align content inside Column
                                                      children: [
                                                        // Event Title
                                                        Text(
                                                          event.eventTitle,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                          ),
                                                          textAlign: TextAlign
                                                              .center, // Center align text
                                                        ),
                                                        SizedBox(height: 8),

                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          // Center align Row content
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .location_on,
                                                                size: 16),
                                                            SizedBox(
                                                                width: 5),
                                                            Expanded(
                                                              child: Text(
                                                                event
                                                                    .eventPlaceName,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    14),
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                // Center align text inside Expanded
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16),

                                Divider(
                                  color: Colors.black, // Line color
                                  thickness: 1, // Line thickness
                                  indent: 10, // Left spacing
                                  endIndent: 10, // Right spacing
                                ),

                              ],):SizedBox(),

                              // Events

                              responseData?.homeData.socialEvent != null && responseData!.homeData!.socialEvent!.isNotEmpty
                                  ?Column(children: [
                                Center(
                                  child: Text(
                                    'Social Events'.tr,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: FontFamily.gilroyMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 280,
                                  width: Get.width, // Set height for the ListView
                                  child: Center(
                                    child: ListView.builder(
                                      scrollDirection: Axis
                                          .horizontal, // Scroll horizontally
                                      itemCount: responseData!
                                          .homeData.socialEvent.length,
                                      itemBuilder: (context, index) {
                                        final event = responseData!
                                            .homeData.socialEvent[index];
                                        return InkWell(
                                          onTap: () async {
                                            await eventDetailsController
                                                .getEventData(
                                              eventId: event.eventId,
                                            );
                                            Get.toNamed(
                                              Routes.eventDetailsScreen1,
                                              arguments: {
                                                "eventId": responseData!
                                                    .homeData.socialEvent[index]
                                                    .eventId,
                                                "bookStatus": responseData!.homeData.socialEvent[index].flag,
                                                "maxmember":
                                                homePageController
                                                    .homeInfo
                                                    ?.homeData
                                                    .mainData
                                                    .maxmember,
                                                "maxguest": homePageController
                                                    .homeInfo
                                                    ?.homeData
                                                    .mainData
                                                    .maxguest
                                              },
                                            );
                                          },
                                          child: Container(
                                            width:
                                            200, // Set the width for each card
                                            margin: EdgeInsets.all(10),
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                // Center the content horizontally
                                                children: [
                                                  // Event Image
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(10),
                                                      topRight:
                                                      Radius.circular(10),
                                                    ),
                                                    child: Image.network(
                                                      Config.imageUrl +
                                                          event.eventImg,
                                                      height: 150,
                                                      width: 200,
                                                      // Set width to match the card width
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      // Center align content inside Column
                                                      children: [
                                                        // Event Title
                                                        Text(
                                                          event.eventTitle,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                          ),
                                                          textAlign: TextAlign
                                                              .center, // Center align text
                                                        ),
                                                        SizedBox(height: 8),

                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          // Center align Row content
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .location_on,
                                                                size: 16),
                                                            SizedBox(
                                                                width: 5),
                                                            Expanded(
                                                              child: Text(
                                                                event
                                                                    .eventPlaceName,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    14),
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                // Center align text inside Expanded
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16,),




                                Divider(
                                  color: Colors.black, // Line color
                                  thickness: 1, // Line thickness
                                  indent: 10, // Left spacing
                                  endIndent: 10, // Right spacing
                                ),


                              ],):SizedBox(),

                              responseData?.homeData.galleryList != null && responseData!.homeData!.galleryList!.isNotEmpty
                                  ?Column(children: [

                                Center(
                                  child: Text(
                                    'Gallery',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: FontFamily.gilroyMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                ),
                                SizedBox(height: 16),

                                SizedBox(
                                  height: 180,
                                  width: Get.size.width,
                                  child: responseData?.homeData.galleryList.isNotEmpty == true
                                      ? ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      // Group images by title
                                      ...groupBy(responseData!.homeData.galleryList, (item) => item.title ?? "Untitled")
                                          .entries
                                          .map((entry) {
                                        var firstImage = entry.value.first; // Get the first image of the group

                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => GroupImageScreen(title: entry.key, images: entry.value, desc: firstImage.description??'',date: firstImage.date?? ''));
                                          },
                                          child: Column(
                                            children: [
                                              // Image
                                              Container(
                                                height: 140,
                                                width: 150,
                                                margin: EdgeInsets.symmetric(horizontal: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.shade300,
                                                      offset: Offset(0.5, 0.5),
                                                      blurRadius: 0.5,
                                                      spreadRadius: 0.5,
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      offset: Offset(0.0, 0.0),
                                                      blurRadius: 0.0,
                                                      spreadRadius: 0.0,
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: FadeInImage.assetNetwork(
                                                    placeholder: "assets/ezgif.com-crop.gif",
                                                    placeholderFit: BoxFit.cover,
                                                    image: "${Config.imageUrl}${firstImage.img ?? ""}",
                                                    height: 140,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

                                              // Title
                                              Text(
                                                entry.key, // Title of the group
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyBold,
                                                  color: Colors.deepPurpleAccent,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  )
                                      : SizedBox(),
                                ),








                                SizedBox(height: 10),


                              ],):SizedBox(),


                              responseData?.homeData.articleList != null && responseData!.homeData!.articleList!.isNotEmpty
                              ? Column(children: [
                                Divider(
                                  color: Colors.black, // Line color
                                  thickness: 1, // Line thickness
                                  indent: 10, // Left spacing
                                  endIndent: 10, // Right spacing
                                ),
                            Center(
                              child: Text(
                                'Our Stories & Achievements',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: FontFamily.gilroyMedium,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            /*Center(
                                child: Text(
                                  'Comming Soon...',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),
                              ),*/
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              child: SizedBox(
                                height: 230, // Height for horizontal list
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:  responseData!.homeData.articleList.length,
                                  itemBuilder: (context, index) {
                                    return StoryCard(story: responseData!.homeData.articleList[index]);
                                  },
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                          ],):SizedBox(),

                              responseData?.homeData.packageList != null && responseData!.homeData!.packageList!.isNotEmpty

                                  ? Column(
                                children: [
                                  Divider(
                                    color: Colors.black, // Line color
                                    thickness: 1, // Line thickness
                                    indent: 10, // Left spacing
                                    endIndent: 10, // Right spacing
                                  ),
                                  Center(
                                    child: Text(
                                      'Membership & Benefits',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily:
                                          FontFamily.gilroyMedium,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .deepPurpleAccent),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(20.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.85,
                                      ),
                                      itemCount: responseData!
                                          .homeData
                                          .packageList
                                          .length,
                                      itemBuilder: (context, index) {
                                        final package = responseData!
                                            .homeData
                                            .packageList[index];
                                        return Card(
                                          borderOnForeground: true,
                                          elevation: 5,
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                10.0),
                                            child: Column(
                                              children: [
                                                // Icon or Image Placeholder
                                                Icon(
                                                    Icons
                                                        .card_membership,
                                                    size: 50,
                                                    color: Colors
                                                        .purple),
                                                SizedBox(height: 10),
                                                // Package Name
                                                Text(
                                                  package.name ?? '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color:
                                                    Colors.purple,
                                                  ),
                                                  textAlign: TextAlign
                                                      .center,
                                                ),
                                                SizedBox(height: 10),
                                                // Package Amount
                                                Text(
                                                  '₹${package.amount ?? ''}',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color: Colors
                                                        .deepPurple,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                // Package Description

                                                SizedBox(
                                                  height: 118,
                                                  // You can specify any height
                                                  child:
                                                  SingleChildScrollView(
                                                    child: Text(
                                                      package.description ??
                                                          'No description available.',
                                                      style:
                                                      TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .black,
                                                      ),
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                // Get Membership Button
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Handle get membership action




                                                    if (getData.read("UserLogin") != null) {


                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text("Confirm Registration"),
                                                            content: Text("Are you sure you want to register with "+widget.orgName!+ "?"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context); // Close the dialog
                                                                },
                                                                child: Text("Cancel"),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  signUpController.name.text=getData.read("UserLogin")["name"] ?? "";
                                                                  signUpController.email.text=getData.read("UserLogin")["email"] ?? "";
                                                                  signUpController.number.text=getData.read("UserLogin")["mobile"] ?? "";
                                                                  signUpController.password.text=getData.read("UserLogin")["password"] ?? "";

                                                                  signUpController.addClubToMemberData(getData.read("UserLogin")["ccode"] ?? "", package.id!, widget.orgId!);
                                                                },
                                                                child: Text("Register"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                    } else {
                                                      Get.toNamed(
                                                        Routes
                                                            .getClubMembershipScreen,
                                                        arguments: {
                                                          "type":
                                                          package.id,
                                                          "clubid":
                                                          widget
                                                              .orgId,
                                                          "packagename":
                                                          package
                                                              .name,
                                                        },
                                                      );
                                                    }



                                                  },
                                                  style:
                                                  ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor: Colors.purple, // Button color
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          20),
                                                    ),
                                                  ),
                                                  child: Text(
                                                      'GET MEMBERSHIP',
                                                      style: TextStyle(
                                                          fontSize:
                                                          16,
                                                          fontFamily:
                                                          FontFamily
                                                              .gilroyMedium,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                                  : SizedBox(),

                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              Center(
                                child: Text(
                                  'Feedback / Comments',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: TextFormField(
                                          controller: name,
                                          cursorColor: BlackColor,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: BlackColor,
                                          ),
                                          decoration: InputDecoration(
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                  color:
                                                  Colors.grey.shade300),
                                            ),
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(15),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            prefixIcon: Padding(
                                              padding:
                                              const EdgeInsets.all(10),
                                              child: Image.asset(
                                                "assets/Profile.png",
                                                height: 10,
                                                width: 10,
                                                color: greycolor,
                                              ),
                                            ),
                                            labelText: "Full Name".tr,
                                            labelStyle: TextStyle(
                                              color: greycolor,
                                              fontFamily:
                                              FontFamily.gilroyMedium,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your name'
                                                  .tr;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: IntlPhoneField(
                                          keyboardType:
                                          TextInputType.number,
                                          cursorColor: BlackColor,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          initialCountryCode: 'IN',
                                          controller: number,
                                          disableLengthCheck: true,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          dropdownIcon: Icon(
                                            Icons.arrow_drop_down,
                                            color: greycolor,
                                          ),
                                          dropdownTextStyle: TextStyle(
                                            color: greycolor,
                                          ),
                                          style: TextStyle(
                                            fontFamily:
                                            FontFamily.gilroyMedium,
                                            fontSize: 14,
                                            color: BlackColor,
                                          ),
                                          onChanged: (value) {
                                            cuntryCode = value.countryCode;
                                          },
                                          onCountryChanged: (value) {
                                            number.text = '';
                                          },
                                          decoration: InputDecoration(
                                            helperText: null,
                                            labelText: "Mobile Number".tr,
                                            labelStyle: TextStyle(
                                              color: greycolor,
                                            ),
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(15),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(15),
                                            ),
                                          ),
                                          validator: (p0) {
                                            if (p0!
                                                .completeNumber.isEmpty) {
                                              return 'Please enter mobile number'
                                                  .tr;
                                            } else {}
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: TextFormField(
                                          controller: email,
                                          cursorColor: BlackColor,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: BlackColor,
                                          ),
                                          decoration: InputDecoration(
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(15),
                                            ),
                                            prefixIcon: Padding(
                                              padding:
                                              const EdgeInsets.all(10),
                                              child: Image.asset(
                                                "assets/email.png",
                                                height: 10,
                                                width: 10,
                                                color: greycolor,
                                              ),
                                            ),
                                            labelText: "Email Address".tr,
                                            labelStyle: TextStyle(
                                              color: greycolor,
                                              fontFamily:
                                              FontFamily.gilroyMedium,
                                            ),
                                          ),
                                          validator: _validateEmail,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: TextFormField(
                                          controller: comment,
                                          cursorColor: BlackColor,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: BlackColor,
                                          ),
                                          maxLines: 4,
                                          // Set the number of lines for the text area
                                          decoration: InputDecoration(
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(15),
                                            ),
                                            prefixIcon: Padding(
                                              padding:
                                              const EdgeInsets.all(10),
                                              child: Image.asset(
                                                "assets/documentpage.png",
                                                height: 10,
                                                width: 10,
                                                color: greycolor,
                                              ),
                                            ),
                                            labelText:
                                            "Comments / Feedback".tr,
                                            labelStyle: TextStyle(
                                              color: greycolor,
                                              fontFamily:
                                              FontFamily.gilroyMedium,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your comment'
                                                  .tr;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      GestButton(
                                        Width: Get.size.width,
                                        height: 50,
                                        buttoncolor: Colors.pinkAccent,
                                        margin: EdgeInsets.only(
                                            top: 15, left: 30, right: 30),
                                        buttontext: "Submit".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          color: WhiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onclick: () {
                                          if (_formKey.currentState
                                              ?.validate() ??
                                              false) {
                                            if (number.text.length > 10 ||
                                                number.text.length < 10) {
                                              showToastMessage(
                                                  'Please enter valid 10 digit mobile number');
                                            } else {
                                              addCommentData(
                                                  name.text,
                                                  cuntryCode,
                                                  number.text,
                                                  email.text,
                                                  comment.text,
                                                  widget.orgId);
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              // Contact Info
                              Center(
                                child: Text(
                                  'Contact Details',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent),
                                ),
                              ),

                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  clubs.isNotEmpty
                                      ? "Email: ${clubs.first.email ?? "N/A"}\nPhone: ${clubs.first.mobile ?? "N/A"}"
                                      : "No club information available",
                                ),
                              ),
                              SizedBox(height: 16),

                              // Address
                              /* Text(
                              'Address',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(clubs.first.location),*/
                              SizedBox(height: 16),
                            ],
                          )
                              : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.wifi_off,
                                    size: 100, color: Colors.grey),
                                SizedBox(height: 20),
                                Text(
                                  'No Internet Connection',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _checkInternetConnection,
                                  // Retry button to check connectivity
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ) /*: Column(children: [
      AppBar(title: Text('Centre Details'),),



        Center(
          child: isLoading
              ? CircularProgressIndicator()  // Show loading spinner while loading
              : Center(child:Column(crossAxisAlignment:CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.center,children: [
            Text(
              'No data available',
              style: TextStyle(
                  fontSize: 18, color: Colors.grey),
            ),],),
          )
        ),
      ],

    )*/,/*Center(
              child: Text(
                'Sorry Club is not live yet',
                style: TextStyle(
                    fontSize: 18, color: Colors.grey),
              ),
            ),*/
    );
  }

  Future<List<Club>> getClubDataApi(String? orgId) async {
    final Uri uri = Uri.parse(Config.baseurl + Config.clubInfo);
    final response = await http.post(
      uri,
      body: jsonEncode({"cid": orgId}),
      headers: {"Content-Type": "application/json"},
    );
    print("clbuid:" + orgId!);
    print(response.body);
    if (response.statusCode == 200) {
      return parseClubJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ResponseData> getClubData(String? orgId) async {
    final Uri uri = Uri.parse(Config.baseurl + Config.clubDetails);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin") != null
            ? getData.read("UserLogin")["id"]
            : "1",
        "club_id": orgId
      }),
      headers: {"Content-Type": "application/json"},
    );

    print("clbuid:" + orgId!);
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future addCommentData(String nameStr, String cuntryCode, String numberStr,
      String emailStr, String commentStr, String? orgId) async {
    final Uri uri = Uri.parse(Config.baseurl + Config.addClubCommnet);
    String uid = getData.read("UserLogin") != null
        ? getData.read("UserLogin")["id"]
        : "1";
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": uid,
        "club_id": orgId,
        "name": nameStr,
        "mobile": cuntryCode + numberStr,
        "email": emailStr,
        "comment": commentStr
      }),
      headers: {"Content-Type": "application/json"},
    );

    print("clbuid:" + uid);
    print(response.body);
    if (response.statusCode == 200) {
      showToastMessage('Comment submit successfully!');
      name.text = "";
      email.text = "";
      number.text = "";
      comment.text = "";
    } else {
      throw Exception('Failed to load data');
    }
  }



}

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  }

  // Regular expression for email validation
  String pattern =
      '^[a-zA-Z0-9.a-zA-Z0-9.!#%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null; // No validation error
}

List<Club> parseClubJson(String jsonResponse) {
  // Decode the JSON string into a Map
  final Map<String, dynamic> parsedData = jsonDecode(jsonResponse);

  // Check for success and extract the club list
  if (parsedData['Result'] == "true") {
    List<dynamic> clubListJson = parsedData['clublist'];

    // Map the JSON data into a list of Club objects
    List<Club> clubs = clubListJson.map((json) => Club.fromJson(json)).toList();

    return clubs; // Return the list of Club objects
  } else {
    throw Exception('Failed to load clubs');
  }
}

class StoryCard extends StatelessWidget {
  final Story story;

  StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => StoryDetailScreen(story: story));
      },
      child: Container(
        width: 250,
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (Banner)
           /* ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/loading2.gif",
                image: story.imageUrl.isNotEmpty ? story.imageUrl : "",
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/Onboarding2.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
*/
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
               Config.imageUrl+story.imageUrl/*"http://143.244.139.253/images/gallery/17393563703.jpeg"*/,
                width: 250,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/Onboarding2.png", // Local fallback image
                    width: 250,
                    height: 140,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),



            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    story.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Short Description
                  Text(
                    story.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class Club {
  String id;
  String title;
  String img;
  String status;
  String mobile;
  String email;
  String? userprofile;
  String? district;
  String? location;
  String about;

  Club({
    required this.id,
    required this.title,
    required this.img,
    required this.status,
    required this.mobile,
    required this.email,
    required this.userprofile,
    required this.district,
    required this.location,
    required this.about,
  });

  // Factory method to create a Club object from JSON
  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      status: json['status'],
      mobile: json['mobile'],
      email: json['email'],
      userprofile: json['userprofile'],
      district: json['district'],
      location: json['location'],
      about: json['about'],
    );
  }
}

class ResponseData {
  String responseCode;
  String result;
  String responseMsg;
  HomeData homeData;

  ResponseData({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.homeData,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
      homeData: HomeData.fromJson(json['HomeData']),
    );
  }
}

class Package {
  String? id;
  String? title;
  String? img;
  String? status;
  String? sponsoreId;
  String? description;
  String? executive;
  String? name;
  String? eid;
  String? amount;
  String? allowMember;


  Package({
    this.id,
    this.title,
    this.img,
    this.status,
    this.sponsoreId,
    this.description,
    this.executive,
    this.name,
    this.eid,
    this.amount,
    this.allowMember,

  });

  // Factory method to parse JSON
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      status: json['status'],
      sponsoreId: json['sponsore_id'],
      description: json['description'],
      executive: json['executive'],
      name: json['name'],
      eid: json['eid'],
      amount: json['amount'],
      allowMember: json['allowmember'],
    );
  }
}

class HomeData {
  List<Category> catlist;
  List<Event> latestEvent;
  List<Event> socialEvent;
  List<HomeBanner> bannerList;
  List<Gallery> galleryList;
  List<Story> articleList;
  List<Executive> executiveList;
  List<Package> packageList;

  HomeData({
    required this.catlist,
    required this.latestEvent,
    required this.socialEvent,
    required this.bannerList,
    required this.galleryList,
    required this.articleList,
    required this.executiveList,
    required this.packageList,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      catlist: (json['Catlist'] as List?)?.map((item) => Category.fromJson(item)).toList() ?? [],

      latestEvent: (json['latest_event'] as List?)?.map((item) => Event.fromJson(item)).toList() ?? [],

      socialEvent: (json['social_event'] as List?)?.map((item) => Event.fromJson(item)).toList() ?? [],

      bannerList: (json['home_banner'] as List?)?.map((item) => HomeBanner.fromJson(item)).toList() ?? [],

      galleryList: (json['gallery'] as List?)?.map((item) => Gallery.fromJson(item)).toList() ?? [],
      articleList: (json['article'] as List?)?.map((item) => Story.fromJson(item)).toList() ?? [],

      executiveList: (json['executive'] as List?)?.map((item) => Executive.fromJson(item)).toList() ?? [],

      packageList: (json['package'] as List?)?.map((item) => Package.fromJson(item)).toList() ?? [],

    );
  }
}

class Executive {
  String? id;
  String? title;
  String? img;
  String? status;
  String? sponsoreId;
  String? description;
  String? executive;
  String? name;

  Executive({
    this.id,
    this.title,
    this.img,
    this.status,
    this.sponsoreId,
    this.description,
    this.executive,
    this.name,
  });

  // Factory constructor to create an Executive from JSON
  factory Executive.fromJson(Map<String, dynamic> json) {
    return Executive(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      status: json['status'],
      sponsoreId: json['sponsore_id'],
      description: json['description'],
      executive: json['executive'],
      name: json['name'],
    );
  }
}


class Story {
  final String title;
  final String description;
  final String imageUrl;
  final String fullDescription;

  Story({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.fullDescription,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      title: json['title'],
      description: json['short_desc'],
      imageUrl: json['img'],
      fullDescription: json['description'],

    );
  }
}

class Gallery {
  String? id;
  String? title;
  String? img;
  String? status;
  String? sponsoreId;
  String? description;
  String? executive;
  String? name;
  String? date;
  String? eid;

  Gallery({
    this.id,
    this.title,
    this.img,
    this.status,
    this.sponsoreId,
    this.description,
    this.executive,
    this.name,
    this.date,
    this.eid,
  });

  // Factory constructor to create Gallery from JSON
  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      status: json['status'],
      sponsoreId: json['sponsore_id'],
      description: json['description'],
      executive: json['executive'],
      name: json['name'],
      date: json['date'],
      eid: json['eid'],
    );
  }
}

class Category {
  String id;
  String title;

  Category({
    required this.id,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
    );
  }
}

class Event {
  String eventId;
  String eventTitle;
  String club_title;
  String eventImg;
  String eventSdate;
  String eventPlaceName;
  String flag;

  Event({
    required this.eventId,
    required this.eventTitle,
    required this.club_title,
    required this.eventImg,
    required this.eventSdate,
    required this.eventPlaceName,
    required this.flag,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'],
      eventTitle: json['event_title'],
      club_title: json['club_title'],
      eventImg: json['event_img'],
      eventSdate: json['event_sdate'],
      eventPlaceName: json['event_place_name'],
      flag: json["flag"],
    );
  }
}

class HomeBanner {
  String? id;
  String? title;
  String? img;
  String? status;
  String? sponsoreId;
  String? description;

  HomeBanner({
    this.id,
    this.title,
    this.img,
    this.status,
    this.sponsoreId,
    this.description,
  });

  // Factory constructor to create HomeBanner from JSON
  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      status: json['status'],
      sponsoreId: json['sponsore_id'],
      description: json['description'],
    );
  }
}

/*late InAppWebViewController webViewController;
  bool isConnected = true;  // Track internet connectivity status
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    // Listen to network changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    // Check for internet connectivity at the start
    _checkInternetConnection();
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();  // Cancel subscription when the widget is disposed
  }

  Future<void> _checkInternetConnection() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      isConnected = (result != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RedColor1,
        title: Text(
          'Club Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: InkWell(
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
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              color: Color(0xFF000000).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      body: isConnected
          ? InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.orgId!)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkInternetConnection,  // Retry button to check connectivity
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        color: transparent,
        height: Get.height,

        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: CustomShape(),
                  child: Container(
                    height: Get.height * 0.29,
                    width: Get.size.width,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.047),
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


                          Text(
                                    "Club Information".tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Gilroy Bold",
                                      fontSize: 22,
                                    ),
                                  ),

                          ],
                        ),

                        SizedBox(height: 50),
                      ],
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/app_bg.jpeg'),
                        // Replace with your image path
                        fit: BoxFit.cover, // Use BoxFit to adjust the image's coverage
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -25,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        padding: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/ezgif.com-crop.gif",
                            image: "${Config.imageUrl}${widget.orgImg}",
                            placeholderFit: BoxFit.cover,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        left: 68,
                        bottom: 4,
                        child: Container(
                          height: 30,
                          width: 30,
                          padding: EdgeInsets.all(3),
                          child: Image.asset(
                            "assets/badge-check.png",
                            color: gradient.defoultColor,
                            height: 20,
                            width: 20,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: WhiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.size.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.orgName ?? "",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 18,
                    color: BlackColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: Get.size.width,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      "assets/Location2.png",
                      color: gradient.defoultColor,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgcolor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 3,
                        ),
                        Text(widget.orgAddresss?? "",
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){}*/ /*() async {
                      await openMap(
                        double.parse(eventDetailsController
                            .eventInfo
                            ?.eventData
                            .eventLatitude ??
                            ""),
                        double.parse(eventDetailsController
                            .eventInfo
                            ?.eventData
                            .eventLongtitude ??
                            ""),
                      );
                    }*/ /*,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/mapIcons.png'),
                        ),
                      ),
                    ),
                  ),

                ],
              ),


            ),
            SizedBox(
              height: 25,
            ),
            Container(
            height: 50,
            width: Get.size.width,
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "About Club".tr,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 14,
                  color: BlackColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15),
              child: HtmlWidget(
                eventDetailsController
                    .eventInfo?.eventData.eventAbout ??
                    "",
                textStyle: TextStyle(
                  color: BlackColor,
                  fontSize: 12,
                  // fontSize: Get.height / 50,
                  fontFamily: 'Gilroy Normal',
                ),
              ),
            ),
        ],
       ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: TabBar(
                indicatorColor: gradient.defoultColor,
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                unselectedLabelColor: greyColor,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 16,
                  color: gradient.defoultColor,
                ),
                indicator: MD2Indicator(
                  indicatorSize: MD2IndicatorSize.full,
                  indicatorHeight: 3,
                  indicatorColor: gradient.defoultColor,
                ),
                labelColor: gradient.defoultColor,
                onTap: (value) {
                  if (value == 0) {
                    orgController.getStatusWiseEvent(
                      orgId: widget.orgId,
                      status: "Today",
                    );
                  } else if (value == 1) {
                    orgController.getStatusWiseEvent(
                      orgId: widget.orgId,
                      status: "Upcoming",
                    );
                  } else {
                    orgController.getStatusWiseEvent(
                      orgId: widget.orgId,
                      status: "Past",
                    );
                  }
                },
                tabs: [
                  Tab(
                    text: "Today's Event".tr,
                  ),
                  Tab(
                    text: "Upcoming".tr,
                  ),
                  Tab(
                    text: "Past".tr,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  todayEventWidget(),
                  upcomingEventWidget(),
                  pastEventWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/

/*todayEventWidget() {
    return GetBuilder<OrgController>(builder: (context) {
      return orgController.isLoading
          ? orgController.orgInfo?.orderData?.isNotEmpty?? false
          ? SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListView.builder(
          itemCount: orgController.orgInfo?.orderData.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await eventDetailsController.getEventData(
                  eventId:
                  orgController.orgInfo?.orderData[index].eventId,
                );
                Get.toNamed(
                  Routes.eventDetailsScreen,
                  arguments: {
                    "eventId": orgController
                        .orgInfo?.orderData[index].eventId,
                    "bookStatus": "1",
                  },
                );
              },
              child: Container(
                height: 120,
                width: Get.size.width,
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: 120,
                      width: 100,
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/ezgif.com-crop.gif",
                          height: 120,
                          width: 100,
                          placeholderCacheHeight: 120,
                          placeholderCacheWidth: 100,
                          image:
                          "${Config.imageUrl}${orgController.orgInfo?.orderData[index].eventImg}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventTitle ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventSdate ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 14,
                                    color: greytext,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/Location.png",
                                color: BlackColor,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 210,
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventPlaceName ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: WhiteColor,
                ),
              ),
            );
          },
        ),
      )
          : Center(
        child: Text(
          'Event Not Available!'.tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 17,
            color: BlackColor,
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          color: gradient.defoultColor,
        ),
      );
    });
  }

  upcomingEventWidget() {
    return GetBuilder<OrgController>(builder: (context) {
      return orgController.isLoading
          ? orgController.orgInfo?.orderData?.isNotEmpty?? false
          ? SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListView.builder(
          itemCount: orgController.orgInfo?.orderData.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await eventDetailsController.getEventData(
                  eventId:
                  orgController.orgInfo?.orderData[index].eventId,
                );
                Get.toNamed(
                  Routes.eventDetailsScreen,
                  arguments: {
                    "eventId": orgController
                        .orgInfo?.orderData[index].eventId,
                    "bookStatus": "1",
                  },
                );
              },
              child: Container(
                height: 120,
                width: Get.size.width,
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: 120,
                      width: 100,
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/ezgif.com-crop.gif",
                          height: 120,
                          width: 100,
                          placeholderCacheHeight: 120,
                          placeholderCacheWidth: 100,
                          image:
                          "${Config.imageUrl}${orgController.orgInfo?.orderData[index].eventImg}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventTitle ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventSdate ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 14,
                                    color: greytext,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/Location.png",
                                color: BlackColor,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 210,
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventPlaceName ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: WhiteColor,
                ),
              ),
            );
          },
        ),
      )
          : Center(
        child: Text(
          'Event Not Available!'.tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 17,
            color: BlackColor,
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          color: gradient.defoultColor,
        ),
      );
    });
  }

  pastEventWidget() {
    return GetBuilder<OrgController>(builder: (context) {
      return orgController.isLoading
          ? orgController.orgInfo?.orderData?.isNotEmpty?? false
          ? SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListView.builder(
          itemCount: orgController.orgInfo?.orderData.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await eventDetailsController.getEventData(
                  eventId:
                  orgController.orgInfo?.orderData[index].eventId,
                );
                Get.toNamed(
                  Routes.eventDetailsScreen,
                  arguments: {
                    "eventId": orgController
                        .orgInfo?.orderData[index].eventId,
                    "bookStatus": "2",
                  },
                );
              },
              child: Container(
                height: 120,
                width: Get.size.width,
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: 120,
                      width: 100,
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/ezgif.com-crop.gif",
                          height: 120,
                          width: 100,
                          placeholderCacheHeight: 120,
                          placeholderCacheWidth: 100,
                          image:
                          "${Config.imageUrl}${orgController.orgInfo?.orderData[index].eventImg}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventTitle ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventSdate ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 14,
                                    color: greytext,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/Location.png",
                                color: BlackColor,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 210,
                                child: Text(
                                  orgController
                                      .orgInfo
                                      ?.orderData[index]
                                      .eventPlaceName ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: WhiteColor,
                ),
              ),
            );
          },
        ),
      )
          : Center(
        child: Text(
          'Event Not Available!'.tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 17,
            color: BlackColor,
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          color: gradient.defoultColor,
        ),
      );
    });
  }

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}*/
