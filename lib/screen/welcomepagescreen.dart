import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:jjcentre/controller/eventdetailskclub_controller.dart';
import 'package:jjcentre/screen/club_details.dart';
import 'package:jjcentre/screen/message.dart';
import 'package:jjcentre/screen/privacy_screen.dart';
import 'package:jjcentre/screen/profile/profile_screen.dart';
import 'package:jjcentre/screen/qr_scanner_screen.dart';
import 'package:jjcentre/screen/seeAll/latest_event.dart';
import 'package:jjcentre/screen/seeAll/latest_event_kclub.dart';
import 'package:jjcentre/screen/videopreview_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller/club_controller.dart';
import '../controller/eventdetails_controller1.dart';
import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../controller/pagelist_controller.dart';
import '../helpar/routes_helpar.dart';
import '../model/fontfamily_model.dart';
import '../utils/Colors.dart';
import '../utils/pdf_viwer_screen.dart';
import '../utils/scanqr_code.dart';
import 'LoginAndSignup/login_screen.dart';
import 'LoginAndSignup/onbording_screen.dart.dart';
import 'bhog_qr_screen.dart';
import 'bottombar_screen.dart';
import 'clubmember_registration.dart';
import 'clubregistration.dart';
import 'memberprofilescreen.dart';
import 'myclubscreen.dart';
import 'hotel/hotel_home_screen.dart';

class Welcomepagescreen extends StatefulWidget {
  const Welcomepagescreen({super.key});

  @override
  State<Welcomepagescreen> createState() => _WelcomeScreenState();
}

var currency;
var wallet1;

class _WelcomeScreenState extends State<Welcomepagescreen> {
  HomePageController homePageController = Get.find();
  EventDetailsController1 eventDetailsController = Get.find();
  EventDetailsControllerKclub eventDetailsControllerkclub = Get.find();
  ClubDetailsController clubDetailsController = Get.find();
  LoginController loginController = Get.find();
  PageListController pageListController = Get.find();
  bool _isVisible = true;
  bool _isLoggin = false;
  bool _isGuestLoggin = false;
  String? networkimage;
  String? clubImage;
  String? base64Image;
  String? path;
  String userName = "";
  String clubName = "";
  String cuntryCode = "";
  String username = "";
  String password = "";
  bool isLoading = true; // Loading flag
  bool hasError = false;
  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;

  bool isConnected = true; // Track internet connectivity status
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  final List<Map<String, dynamic>> sections = [
    {"title": "Hotel", "icon": "assets/hotel.png", "route": () =>HotelScreen()},
    {"title": "Matrimony", "icon": "assets/matrimony.png", "route": () =>MatrimonyScreen()},
    {"title": "Diagnostic Lab", "icon": "assets/diagnostic-lab.png", "route": () =>LabScreen()},
    {"title": "Travel", "icon": "assets/travel.png", "route": () =>TravelScreen()},
    {"title": "E-learning", "icon": "assets/e-learning.png", "route": () =>ELearningScreen()},
  ];

  @override
  void initState() {
    super.initState();
    getData.read("UserLogin") != null
        ? setState(() {
            userName = getData.read("UserLogin")["name"] ?? "";
            cuntryCode = getData.read("UserLogin")["ccode"] ?? "";
            username = getData.read("UserLogin")["mobile"] ?? "";
            password = getData.read("UserLogin")["password"] ?? "";
            networkimage = getData.read("UserLogin")["pro_pic"] ?? "";
            clubImage = getData.read("clublist")["clubimage"] ?? "";
            clubName = getData.read("clublist")["title"] ?? "";
            //clubImage="";
            //print("asdsd" + clubImage!);
            getData.read("UserLogin")["pro_pic"] != "null"
                ? setState(() {
                    networkimageconvert();
                  })
                : const SizedBox();
          })
        : networkimage = "";

    loadData();
    // Set a timer to hide the container after 3 seconds
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = false; // Change visibility state
        });
      }
    });

    if (getData.read("UserLogin") != null) {
      _isLoggin = true;
      _isGuestLoggin = false;
    } else {
      _isLoggin = false;
      _isGuestLoggin = true;
      _isVisible = false;
    }
    if (Platform.isAndroid) {
      _checkForUpdate();
    }
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

  Future<void> _checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      setState(() {
        _updateInfo = updateInfo;
        _flexibleUpdateAvailable = updateInfo.updateAvailability ==
                UpdateAvailability.updateAvailable &&
            updateInfo.flexibleUpdateAllowed;
      });

      if (_flexibleUpdateAvailable) {
        _showSnackBar(context, "Update available!", actionLabel: "Update",
            onPressed: () {
          InAppUpdate.startFlexibleUpdate().then((_) {
            InAppUpdate.completeFlexibleUpdate();
          });
        });
      } else {
        // _showSnackBar(context, "Your app is up to date.");
      }
    } catch (e) {
      _showSnackBar(context, "Failed to check for updates.");
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {String? actionLabel, VoidCallback? onPressed}) {
    final snackBar = SnackBar(
      content: Text(message),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onPressed ?? () {},
            )
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  networkimageconvert() {
    (() async {
      http.Response response =
          await http.get(Uri.parse(Config.imageUrl + networkimage.toString()));
      if (mounted) {
        print(response.bodyBytes);
        setState(() {
          base64Image = const Base64Encoder().convert(response.bodyBytes);
        });
      }
    })();
  }

  loadData() async {
    print("in");
    /*  setState(() {
      homePageController.getHomeDataApi();
    });*/
    //final data = await getKaraokeData();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Token:" + prefs.getString("token").toString());
    try {
      setState(() {
        homePageController.getHomeDataApi();
        //loginController.getLoginApiForData(cuntryCode, username, password);
        isLoading = false; // Update the state with the new data
      });
    } catch (e) {
      // Handle error appropriately
      setState(() {
        hasError = true; // An error occurred while loading data
        isLoading = false;
      });
    }
    //homePageController.getHomeDataApi();
  }






  int _getTotalItemCount() {
    int count = 0;
    for (var section in homePageController.homeInfo!.homeData.eventList) {
      count += section.events.length + 1; // 1 for the header
    }
    return count;
  }

// Get section index based on global index
  int _getSectionIndex(int globalIndex) {
    int currentIndex = 0;
    for (int sectionIndex = 0;
        sectionIndex < homePageController.homeInfo!.homeData.eventList.length;
        sectionIndex++) {
      int sectionLength = homePageController
              .homeInfo!.homeData.eventList[sectionIndex].events.length +
          1; // Include header

      if (globalIndex < currentIndex + sectionLength) {
        return sectionIndex; // This globalIndex falls within the current section
      }

      currentIndex += sectionLength;
    }
    throw Exception(
        'Section index calculation failed for globalIndex: $globalIndex');
  }

// Get item index in the section (return -1 if it's a header)
  int _getItemIndexInSection(int globalIndex) {
    int currentIndex = 0;
    for (var section in homePageController.homeInfo!.homeData.eventList) {
      int sectionLength = section.events.length + 1; // Include header

      if (globalIndex == currentIndex) {
        return -1; // It's the header
      }

      currentIndex++; // Move past the header

      if (globalIndex < currentIndex + section.events.length) {
        return globalIndex -
            currentIndex; // Return the index within the events list
      }

      currentIndex += section.events.length; // Move to the next section
    }
    throw Exception(
        'Item index calculation failed for globalIndex: $globalIndex');
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        exit(0);
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              //   _openGallery(Get.context!);
                            },
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: path == null
                                  ? networkimage != ""
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          child: Image.network(
                                            "${Config.imageUrl}${networkimage ?? ""}",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: Get.height / 17,
                                          child: Image.asset(
                                            "assets/profile-default.png",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: Image.file(
                                        File(path.toString()),
                                        width: Get.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        getData.read("UserLogin") != null
                            ? capitalize(getData.read("UserLogin")["name"])
                            : "",
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: _isLoggin,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'.tr),
                      onTap: () {
                        // Navigate to home screen
                        //Navigator.pop(context);
                        Get.forceAppUpdate();
                        Get.offAll(() => BottomBarScreen()); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('My Profile'.tr),
                      onTap: () {
                        // Navigate to profile screen
                        //Navigator.pop(context);
                        Get.to(() => MemberProfileScreen()); // Close the drawer
                      },
                    ),
                    /*ListTile(
                      leading: Icon(Icons.account_balance_outlined),
                      title: Text('My Club'),
                      onTap: () {
                        // Navigate to profile screen
                        //Navigator.pop(context);
                        Get.to(() => MyClubScreen()); // Close the drawer
                      },
                    ),*/
                    /* ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notification'),
                      onTap: () {
                        // Navigate to profile screen
                        //Navigator.pop(context);
                        Get.to(() => Message()); // Close the drawer
                      },
                    ),*/
                    /* getData.read("UserLogin")["volunteer"] == "1"
                      ?
                  ListTile(
                    leading: Icon(Icons.qr_code),
                    title: Text('Scan QR Code'),
                    onTap: () {
                      // Navigate to profile screen
                      //Navigator.pop(context);
                      Get.to(() => QRScannerScreen());
                    },
                  ):SizedBox(),*/

                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete Account'.tr),
                      onTap: () {
                        // Navigate to settings screen
                        /* Navigator.pop(context);*/
                        deleteSheet(); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Logout'.tr),
                      onTap: () {
                        // Handle logout
                        //Navigator.pop(context);
                        logoutSheet(); // Close the drawer
                      },
                    ),
                    /* SizedBox(height: 250),
                  Divider(
                    color: Colors.black, // Color of the line
                    thickness: 1.0, // Thickness of the line
                    indent: 10.0, // Left padding
                    endIndent: 10.0, // Right padding
                  ),*/
                  ],
                ),
              ),
              // Additional links at the bottom

             /* _isGuestLoggin ?*/
              Visibility(
                visible: _isGuestLoggin,
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text('Become Centre Member'.tr),
                      onTap: () {
                        //Navigator.pop(context);
                        Get.to(ClubMemberRegistrationScreen());
                      },
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text('Register Centre'.tr),
                      onTap: () {
                        // Navigator.pop(context);
                        Get.to(ClubRegistrationScreen());
                      },
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text('Terms & Conditions'.tr),
                      onTap: () {
                        Get.to(WebViewScreen(
                          url: 'https://aamibengali.com/terms-conditions.html',
                          title: 'Terms and Conditions'.tr,
                        ));
                      },
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text('Privacy Policy'.tr),
                      onTap: () {
                        Get.to(WebViewScreen(
                          url: 'https://aamibengali.com/privacy-policy.html',
                          title: 'Privacy Policy',
                        ));
                      },
                    ),
                  ],
                ),
              )/*:homePageController
                  .homeInfo
                  ?.homeData
                  .latestEvent
                  .isNotEmpty ??
                  false
                  ? SizedBox()
                  : Column(
                children: [
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text('Become Club Member'.tr),
                    onTap: () {
                      //Navigator.pop(context);
                      Get.to(ClubMemberRegistrationScreen());
                    },
                  ),
                  *//*ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text('Register Club'.tr),
                    onTap: () {
                      // Navigator.pop(context);
                      Get.to(ClubRegistrationScreen());
                    },
                  ),*//*
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text('Terms & Conditions'.tr),
                    onTap: () {
                      Get.to(WebViewScreen(
                        url: 'https://aamibengali.com/terms-conditions.html',
                        title: 'Terms and Conditions'.tr,
                      ));
                    },
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text('Privacy Policy'.tr),
                    onTap: () {
                      Get.to(WebViewScreen(
                        url: 'https://aamibengali.com/privacy-policy.html',
                        title: 'Privacy Policy',
                      ));
                    },
                  ),
                ],
              )*/,
              SizedBox(height: 20),
            ],
          ),
        ),
        body: RefreshIndicator(
          color: gradient.defoultColor,
          onRefresh: () {
            return Future.delayed(
              Duration(seconds: 2),
              () {
                homePageController.getHomeDataApi();
                loginController.getLoginApiForData(
                    cuntryCode, username, password);
              },
            );
          },
          child: Container(
            //color: transparent,
            height: Get.height,
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              /*image: DecorationImage(
                image: AssetImage('assets/app_bg.png'),
                // Replace with your image path
                fit: BoxFit.fill, // Use BoxFit to adjust the image's coverage
              ),*/
            ),
            child: Stack(
              children: [
                Container(
                  height: Get.height * 0.22,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*InkWell(
                          onTap: () {
                            getData.read('isLoginBack')
                                ? Get.toNamed(Routes.bottoBarScreen)
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
                        ),*/

                          Builder(
                            builder: (context) {
                              return IconButton(
                                icon: Icon(Icons.menu, color: Colors.white),
                                onPressed: () {
                                  Scaffold.of(context)
                                      .openDrawer(); // Opens the drawer
                                },
                              );
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: /*_isVisible
                                ? Text(
                                    "Welcome Back ".tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Gilroy Bold",
                                      fontSize: 20,
                                    ),
                                  )
                                : */
                                Text(
                              clubName,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Gilroy Bold",
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      /*SizedBox(
                      height: Get.size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account?".tr,
                          style: TextStyle(
                            color: WhiteColor,
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.signUpScreen);
                          },
                          child: Text(
                            " Create Now".tr,
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
                    ),*/

                      /* Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, bottom: 50.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _isVisible
                                ? Text(
                                    "Welcome Back ".tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Gilroy Bold",
                                      fontSize: 25,
                                    ),
                                  )
                                : Text(
                                    "Gujarati Club ".tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Gilroy Bold",
                                      fontSize: 30,
                                    ),
                                  ),
                          ),
                        ),
                      ),*/
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  /* decoration: BoxDecoration(
                  gradient: gradient.redgradient,
                ),*/
                  /* decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/app_bg.jpeg'),
                    // Replace with your image path
                    fit: BoxFit
                        .fill, // Use BoxFit to adjust the image's coverage
                  ),
                ),*/
                ),
                Positioned(
                  top: Get.height * 0.1,
                  child: Container(
                    height: Get.size.height,
                    width: Get.size.width,
                    child: isLoading
                        ? Center(
                            child:
                                CircularProgressIndicator()) // Show loading indicator
                        : hasError
                            ? Center(
                                child: Text('Failed to load data. Try again.'
                                    .tr)) // Show error message
                            : homePageController.homeInfo?.homeData?.clubList
                                        ?.isEmpty ??
                                    true
                                ? Center(
                                    child:
                                        CircularProgressIndicator()) /*Center(
                                    child: Text(
                                        'No data available.'))*/ // Handle empty data case
                                : Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    // Adjust the padding value as needed
                                    child: /* _isVisible
                                        ? Container(
                                            height: 300, // Set the container's height as needed
                                            child: Stack(
                                              children: [
                                                // Background image
                                                Positioned.fill(
                                                  child: */ /*clubImage != ""
                                                      ? Image.network(
                                                          "${Config.imageUrl}${clubImage ?? ""}",
                                                          fit: BoxFit
                                                              .cover, // Make sure the image covers the container
                                                        )
                                                      : */ /*Image.asset(
                                                          'assets/app_image.jpg',
                                                          // Put your logo image here
                                                          //height: 150.0,
                                                        fit: BoxFit.cover,
                                                        ),
                                                ),

                                                // Yellow overlay color with opacity
                                                Positioned.fill(
                                                  child: Container(
                                                    color: Colors.yellow
                                                        .withOpacity(
                                                            0.2), // Apply semi-transparent overlay
                                                  ),
                                                ),

                                                // Foreground content
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(height: 40.0),
                                                    Center(
                                                      child: Text(
                                                        */ /*getData.read("UserLogin") != null
                                                            ? getData.read("UserLogin")["name"]
                                                            :*/ /*
                                                        "",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          //backgroundColor: Colors.white// Text color to contrast with the background
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : */
                                        SingleChildScrollView(
                                            scrollDirection: Axis
                                                .vertical, // Scroll vertically
                                            child: isConnected
                                                ? Container(
                                                    height: MediaQuery.sizeOf(
                                                            context)
                                                        .height, // Example height
                                                    width: double.infinity,
                                                    child: ListView(
                                                      padding: EdgeInsets.zero,
                                                      //physics: NeverScrollableScrollPhysics(),
                                                      children: [
                                                        /*homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    ?.clubList
                                                                    ?.isNotEmpty ??
                                                                false
                                                            ? Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    "Clubs in Your city"
                                                                        .tr,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      color:
                                                                          BlackColor,
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      //Get.to(LatestEvent(eventStaus: "1"));
                                                                    },
                                                                    child: Text(
                                                                      "".tr,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontFamily.gilroyMedium,
                                                                        color: gradient
                                                                            .defoultColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox(),*/
                                                        /*homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    ?.clubList
                                                                    ?.isNotEmpty ??
                                                                false
                                                            ? SizedBox(
                                                                height: 180,
                                                                width: Get
                                                                    .size.width,
                                                                child: ListView
                                                                    .builder(
                                                                  itemCount: homePageController
                                                                      .homeInfo
                                                                      ?.homeData
                                                                      .clubList
                                                                      .length
                                                                      .clamp(
                                                                          0, 5),
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        await clubDetailsController
                                                                            .getClubData(
                                                                          clubId: homePageController
                                                                              .homeInfo
                                                                              ?.homeData
                                                                              .clubList[index]
                                                                              .id,
                                                                        );
                                                                        Get.to(
                                                                            ClubDetailsScreen(
                                                                          orgId: homePageController
                                                                              .homeInfo
                                                                              ?.homeData
                                                                              .clubList[index]
                                                                              .id,
                                                                          orgImg: homePageController
                                                                              .homeInfo
                                                                              ?.homeData
                                                                              .clubList[index]
                                                                              .img,
                                                                          orgName: homePageController
                                                                              .homeInfo
                                                                              ?.homeData
                                                                              .clubList[index]
                                                                              .title,
                                                                          orgAddresss: homePageController
                                                                              .homeInfo
                                                                              ?.homeData
                                                                              .clubList[index]
                                                                              .location,
                                                                        ));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            180,
                                                                        width:
                                                                            280,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                0,
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              0.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                margin: EdgeInsets.all(0.0),
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(
                                                                                    color: Colors.deepPurpleAccent,
                                                                                    // Set the border color
                                                                                    width: 1.0, // Set the border width
                                                                                  ),
                                                                                  color: Colors.white,

                                                                                  borderRadius: BorderRadius.circular(10.0), // Optional: match Card's border radius
                                                                                ),
                                                                                child: Card(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(0.0),
                                                                                  ),
                                                                                  elevation: 0,
                                                                                  color: Colors.white,
                                                                                  child: Container(
                                                                                    height: 180,
                                                                                    width: 270,
                                                                                    // Adjusted width
                                                                                    padding: EdgeInsets.all(0.0),
                                                                                    child: Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        // Club Image
                                                                                        ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                          */ /*${Config.imageUrl}*/ /*
                                                                                          child: Image.network(
                                                                                            "${Config.imageUrl}${homePageController.homeInfo?.homeData.clubList[index].img}",
                                                                                            height: Get.height,
                                                                                            // Adjust height as needed
                                                                                            width: 120,
                                                                                            // Adjust width as needed
                                                                                            fit: BoxFit.contain,
                                                                                          ),
                                                                                        ),

                                                                                        // Adjusted padding

                                                                                        // Expanded to take the remaining space
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            height: 190,
                                                                                            color: Colors.white,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                                                  // Adds 16 pixels of padding on all sides
                                                                                                  child: Text(
                                                                                                    homePageController.homeInfo?.homeData.clubList[index].title ?? "",
                                                                                                    style: TextStyle(
                                                                                                      fontSize: 16.0,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(height: 4.0),
                                                                                                Text(
                                                                                                  homePageController.homeInfo?.homeData.clubList[index].location ?? "",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 12.0,
                                                                                                    color: Colors.black,
                                                                                                  ),
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                                Row(
                                                                                                  children: [
                                                                                                    */ /* Image.asset(
                                                                "assets/Location.png",
                                                                color: Colors.grey,
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              SizedBox(width: 4),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              homePageController.homeInfo?.homeData.clubList[index].location ?? "",
                                                                              style: TextStyle(
                                                                                fontSize: 12.0,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),*/ /*
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                          color:
                                                                              WhiteColor,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                            : SizedBox(),*/
                                                        //homePageController.homeInfo!.homeData.latestEvent.isNotEmpty
                                                        /* homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    ?.latestEvent
                                                                    ?.isNotEmpty ??
                                                                false
                                                            ? Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    "Durga Puja Celebration"
                                                                        .tr,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      color:
                                                                          BlackColor,
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      //Get.to(LatestEvent(eventStaus: "1"));
                                                                    },
                                                                    child: Text(
                                                                      "".tr,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontFamily.gilroyMedium,
                                                                        color: gradient
                                                                            .defoultColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox(),*/
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        getData.read(
                                                                    "UserLogin") !=
                                                                null
                                                            ? homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        .latestEvent
                                                                        .isNotEmpty ??
                                                                    false
                                                                ? Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                15),
                                                                    child: Text(
                                                                      'Our Group Programs'
                                                                          .tr,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  )
                                                                : SizedBox()
                                                            : SizedBox(),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        getData.read(
                                                                    "UserLogin") !=
                                                                null
                                                            ? homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        ?.latestEvent
                                                                        ?.isNotEmpty ??
                                                                    false
                                                                ? SizedBox(
                                                                    height: 330,
                                                                    width: Get
                                                                        .size
                                                                        .width,
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount: homePageController
                                                                          .homeInfo
                                                                          ?.homeData
                                                                          .latestEvent
                                                                          .length,
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            await eventDetailsController.getEventData(
                                                                              eventId: homePageController.homeInfo?.homeData.latestEvent[index].eventId,
                                                                            );
                                                                            /*Get.toNamed(
                                                                      Routes
                                                                          .eventDetailsScreen,
                                                                      arguments: {
                                                                        "eventId": homePageController
                                                                            .homeInfo
                                                                            ?.homeData
                                                                            .latestEvent[index]
                                                                            .eventId,
                                                                        "bookStatus":
                                                                            "1",
                                                                        "maxmember": homePageController
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
                                                                    );*/

                                                                            Get.toNamed(
                                                                              Routes.eventDetailsScreen1,
                                                                              arguments: {
                                                                                "eventId": homePageController.homeInfo?.homeData.latestEvent[index].eventId,
                                                                                "bookStatus": homePageController.homeInfo?.homeData.latestEvent[index].flag,
                                                                                "maxmember": homePageController.homeInfo?.homeData.mainData.maxmember,
                                                                                "maxguest": homePageController.homeInfo?.homeData.mainData.maxguest
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                320,
                                                                            width:
                                                                                240,
                                                                            margin: EdgeInsets.only(
                                                                                left: 10,
                                                                                right: 10,
                                                                                bottom: 10),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              child: Stack(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 320,
                                                                                    width: 240,
                                                                                    child: FadeInImage.assetNetwork(
                                                                                      fadeInCurve: Curves.easeInCirc,
                                                                                      placeholder: "assets/ezgif.com-crop.gif",
                                                                                      height: 320,
                                                                                      width: 240,
                                                                                      placeholderCacheHeight: 320,
                                                                                      placeholderCacheWidth: 240,
                                                                                      placeholderFit: BoxFit.fill,
                                                                                      // placeholderScale: 1.0,
                                                                                      image: "${Config.imageUrl}${homePageController.homeInfo?.homeData.latestEvent[index].eventImg}",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      gradient: LinearGradient(
                                                                                        begin: Alignment.topCenter,
                                                                                        end: Alignment.bottomCenter,
                                                                                        stops: [
                                                                                          0.6,
                                                                                          0.8,
                                                                                          1.5
                                                                                        ],
                                                                                        colors: [
                                                                                          Colors.transparent,
                                                                                          Colors.black.withOpacity(0.5),
                                                                                          Colors.black.withOpacity(0.5),
                                                                                        ],
                                                                                      ),
                                                                                      //border: Border.all(color: lightgrey),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    bottom: 5,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 10, bottom: 5, right: 10),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 240,
                                                                                            child: Text(
                                                                                              homePageController.homeInfo?.homeData.latestEvent[index].eventTitle ?? "",
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                fontFamily: FontFamily.gilroyBold,
                                                                                                fontSize: 17,
                                                                                                color: WhiteColor,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 8,
                                                                                          ),
                                                                                          Text(
                                                                                            homePageController.homeInfo?.homeData.latestEvent[index].eventSdate ?? "",
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontFamily.gilroyMedium,
                                                                                              color: WhiteColor,
                                                                                              fontSize: 15,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 5,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Image.asset(
                                                                                                "assets/Location.png",
                                                                                                color: WhiteColor,
                                                                                                height: 15,
                                                                                                width: 15,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 4,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 210,
                                                                                                child: Text(
                                                                                                  homePageController.homeInfo?.homeData.latestEvent[index].eventPlaceName ?? "",
                                                                                                  maxLines: 1,
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: FontFamily.gilroyMedium,
                                                                                                    fontSize: 15,
                                                                                                    color: WhiteColor,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              color: WhiteColor,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),

                                                                    /*ListView.builder(
                                                                  itemCount:
                                                                      _getTotalItemCount(),
                                                                  scrollDirection: Axis.vertical,

                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final sectionIndex =
                                                                        _getSectionIndex(
                                                                            index);
                                                                    final itemIndex =
                                                                        _getItemIndexInSection(
                                                                            index);

                                                                    if (itemIndex == -1) {
                                                                      // Display header
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(left: 16.0,right: 16.0,bottom: 10),
                                                                        child:
                                                                            Text(
                                                                          homePageController
                                                                              .homeInfo!
                                                                              .homeData
                                                                              .eventList[sectionIndex]
                                                                              .title,
                                                                              style:
                                                                              TextStyle(
                                                                                fontFamily:
                                                                                FontFamily
                                                                                    .gilroyBold,
                                                                                color:
                                                                                BlackColor,
                                                                                fontSize:
                                                                                17,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      // Display event item
                                                                      final events = homePageController
                                                                          .homeInfo!
                                                                          .homeData
                                                                          .eventList[
                                                                              sectionIndex]
                                                                          .events;

                                                                      return Container(
                                                                        height:
                                                                            320,
                                                                        // Set a fixed height for the horizontal ListView
                                                                        child: ListView
                                                                            .builder(
                                                                          itemCount:
                                                                              events.length,
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          // Set to horizontal
                                                                          itemBuilder:
                                                                              (context, itemIndex) {
                                                                            final event =
                                                                                events[itemIndex];

                                                                            return InkWell(
                                                                              onTap: () async {
                                                                                await eventDetailsController
                                                                                    .getEventData(
                                                                                  eventId: event
                                                                                      .eventId,
                                                                                );
                                                                                Get.toNamed(
                                                                                  Routes.eventDetailsScreen,
                                                                                  arguments: {
                                                                                    "eventId":event.eventId,
                                                                                    "bookStatus": "1",
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
                                                                                width: 240,
                                                                                // Fixed width for each event item
                                                                                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: 320,
                                                                                        // Height matches the container height
                                                                                        width: 240,
                                                                                        // Width matches the container width
                                                                                        child: Image.network(
                                                                                          Config.imageUrl + event.eventImg,
                                                                                          height: 320,
                                                                                          width: 240,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        decoration: BoxDecoration(
                                                                                          gradient: LinearGradient(
                                                                                            begin: Alignment.topCenter,
                                                                                            end: Alignment.bottomCenter,
                                                                                            stops: [
                                                                                              0.6,
                                                                                              0.8,
                                                                                              1.5
                                                                                            ],
                                                                                            colors: [
                                                                                              Colors.transparent,
                                                                                              Colors.black.withOpacity(0.5),
                                                                                              Colors.black.withOpacity(0.5),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Positioned(
                                                                                        bottom: 5,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.only(left: 10, bottom: 5, right: 10),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                width: 240,
                                                                                                child: Text(
                                                                                                  event.eventTitle,
                                                                                                  maxLines: 1,
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: 'Gilroy-Bold',
                                                                                                    fontSize: 17,
                                                                                                    color: Colors.white,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(height: 8),
                                                                                              Row(
                                                                                                children: [
                                                                                                  Icon(
                                                                                                    Icons.location_on,
                                                                                                    color: Colors.white,
                                                                                                    size: 15,
                                                                                                  ),
                                                                                                  SizedBox(width: 4),
                                                                                                  SizedBox(
                                                                                                    width: 210,
                                                                                                    child: Text(
                                                                                                      event.eventPlaceName,
                                                                                                      maxLines: 1,
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: 'Gilroy-Medium',
                                                                                                        fontSize: 15,
                                                                                                        color: Colors.white,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      );

                                                                    }
                                                                  },
                                                                ),*/

                                                                    /* ListView.builder(
                                                            itemCount: homePageController
                                                                .homeInfo!
                                                                .homeData
                                                                .eventList.length,
                                                            itemBuilder: (context, index) {
                                                              // Access event data dynamically
                                                              final eventList = homePageController
                                                                  .homeInfo!
                                                                  .homeData
                                                                  .eventList[index];  // Access event title dynamically

                                                              return Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Dynamically pass the title for each event list
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      eventList.title, // Here the title is passed dynamically
                                                                      style: TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // Horizontal scrolling ListView for events
                                                                  Container(
                                                                    height: 320, // Set height for horizontal scroll
                                                                    child: ListView.builder(
                                                                      scrollDirection: Axis.horizontal,
                                                                      itemCount: eventList.events.length,
                                                                      itemBuilder: (context, eventIndex) {
                                                                        final event = eventList.events[eventIndex];

                                                                       */ /* return Container(
                                                                          width: 250, // Set width for individual event item
                                                                          margin: const EdgeInsets.all(8.0),
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            color: Colors.grey[200],
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.5),
                                                                                spreadRadius: 2,
                                                                                blurRadius: 5,
                                                                                offset: Offset(0, 3),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              // Image
                                                                              Expanded(
                                                                                child: Image.network(
                                                                                  event.eventImg,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              // Event details
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  event.eventTitle,
                                                                                  style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                child: Text(event.eventSdate),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                child: Text(event.eventPlaceName),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );*/ /*


                                                                        return InkWell(
                                                                          onTap: () async {
                                                                            await eventDetailsController
                                                                                .getEventData(
                                                                              eventId: event
                                                                                  .eventId,
                                                                            );
                                                                            Get.toNamed(
                                                                              Routes.eventDetailsScreen,
                                                                              arguments: {
                                                                                "eventId":event.eventId,
                                                                                "bookStatus": "1",
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
                                                                            width: 240,
                                                                            // Fixed width for each event item
                                                                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              child: Stack(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 320,
                                                                                    // Height matches the container height
                                                                                    width: 240,
                                                                                    // Width matches the container width
                                                                                    child: Image.network(
                                                                                      Config.imageUrl + event.eventImg,
                                                                                      height: 320,
                                                                                      width: 240,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      gradient: LinearGradient(
                                                                                        begin: Alignment.topCenter,
                                                                                        end: Alignment.bottomCenter,
                                                                                        stops: [
                                                                                          0.6,
                                                                                          0.8,
                                                                                          1.5
                                                                                        ],
                                                                                        colors: [
                                                                                          Colors.transparent,
                                                                                          Colors.black.withOpacity(0.5),
                                                                                          Colors.black.withOpacity(0.5),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    bottom: 5,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 10, bottom: 5, right: 10),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 240,
                                                                                            child: Text(
                                                                                              event.eventTitle,
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Gilroy-Bold',
                                                                                                fontSize: 17,
                                                                                                color: Colors.white,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(height: 8),
                                                                                          Row(
                                                                                            children: [
                                                                                              Icon(
                                                                                                Icons.location_on,
                                                                                                color: Colors.white,
                                                                                                size: 15,
                                                                                              ),
                                                                                              SizedBox(width: 4),
                                                                                              SizedBox(
                                                                                                width: 210,
                                                                                                child: Text(
                                                                                                  event.eventPlaceName,
                                                                                                  maxLines: 1,
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: 'Gilroy-Medium',
                                                                                                    fontSize: 15,
                                                                                                    color: Colors.white,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        );

                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 40,)
                                                                ],
                                                              );
                                                            },
                                                          ),*/
                                                                  )
                                                                : SizedBox()
                                                            : getData.read(
                                                                        "UserLogin") ==
                                                                    null
                                                                ? homePageController
                                                                            .homeInfo
                                                                            ?.homeData
                                                                            ?.clubList
                                                                            ?.isNotEmpty ??
                                                                        false
                                                                    ? Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            "Group in your city".tr,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: FontFamily.gilroyBold,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: BlackColor,
                                                                              fontSize: 17,
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              //Get.to(LatestEvent(eventStaus: "1"));
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "".tr,
                                                                              style: TextStyle(
                                                                                fontFamily: FontFamily.gilroyMedium,
                                                                                color: gradient.defoultColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : SizedBox()
                                                                : SizedBox(),
                                                        getData.read(
                                                                    "UserLogin") ==
                                                                null
                                                            ? homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        ?.clubList
                                                                        ?.isNotEmpty ??
                                                                    false
                                                                ? SizedBox(
                                                                    height: 180,
                                                                    width: Get
                                                                        .size
                                                                        .width,
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount: homePageController
                                                                          .homeInfo
                                                                          ?.homeData
                                                                          .clubList
                                                                          .length
                                                                          .clamp(
                                                                              0,
                                                                              5),
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            await clubDetailsController.getClubData(
                                                                              clubId: homePageController.homeInfo?.homeData.clubList[index].id,
                                                                            );
                                                                            Get.to(ClubDetailsScreen(
                                                                              orgId: homePageController.homeInfo?.homeData.clubList[index].id,
                                                                              orgImg: homePageController.homeInfo?.homeData.clubList[index].img,
                                                                              orgName: homePageController.homeInfo?.homeData.clubList[index].title,
                                                                              orgAddresss: homePageController.homeInfo?.homeData.clubList[index].location,
                                                                            ));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                180,
                                                                            width:
                                                                                280,
                                                                            margin: EdgeInsets.only(
                                                                                left: 10,
                                                                                right: 0,
                                                                                top: 0,
                                                                                bottom: 10),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(0.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    margin: EdgeInsets.all(0.0),
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(
                                                                                        color: Colors.pinkAccent,
                                                                                        // Set the border color
                                                                                        width: 1.0, // Set the border width
                                                                                      ),
                                                                                      color: Colors.white,

                                                                                      borderRadius: BorderRadius.circular(10.0), // Optional: match Card's border radius
                                                                                    ),
                                                                                    child: Card(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(0.0),
                                                                                      ),
                                                                                      elevation: 0,
                                                                                      color: Colors.white,
                                                                                      child: Container(
                                                                                        height: 180,
                                                                                        width: 270,
                                                                                        // Adjusted width
                                                                                        padding: EdgeInsets.all(0.0),
                                                                                        child: Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            // Club Image
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                                              /*${Config.imageUrl}*/
                                                                                              child: Image.network(
                                                                                                "${Config.imageUrl}${homePageController.homeInfo?.homeData.clubList[index].img}",
                                                                                                height: Get.height,
                                                                                                // Adjust height as needed
                                                                                                width: 120,
                                                                                                // Adjust width as needed
                                                                                                fit: BoxFit.contain,
                                                                                              ),
                                                                                            ),

                                                                                            // Adjusted padding

                                                                                            // Expanded to take the remaining space
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                height: 190,
                                                                                                color: Colors.white,
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                                                      // Adds 16 pixels of padding on all sides
                                                                                                      child: Text(
                                                                                                        homePageController.homeInfo?.homeData.clubList[index].title ?? "",
                                                                                                        style: TextStyle(
                                                                                                          fontSize: 16.0,
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(height: 4.0),
                                                                                                    Text(
                                                                                                      homePageController.homeInfo?.homeData.clubList[index].location ?? "",
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 12.0,
                                                                                                        color: Colors.black,
                                                                                                      ),
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      maxLines: 1,
                                                                                                    ),
                                                                                                    Row(
                                                                                                      children: [
                                                                                                        /* Image.asset(
                                                                "assets/Location.png",
                                                                color: Colors.grey,
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              SizedBox(width: 4),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              homePageController.homeInfo?.homeData.clubList[index].location ?? "",
                                                                              style: TextStyle(
                                                                                fontSize: 12.0,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),*/
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              color: Colors.pinkAccent.withOpacity(0.01),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                : SizedBox()
                                                            : SizedBox(),



                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        getData.read(
                                                            "UserLogin") !=
                                                            null
                                                            ? homePageController
                                                            .homeInfo
                                                            ?.homeData
                                                            .socialEvent
                                                            .isNotEmpty ??
                                                            false
                                                            ? Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left:
                                                              15),
                                                          child: Text(
                                                            'Group Social Activity'
                                                                .tr,
                                                            style: TextStyle(
                                                                fontSize:
                                                                17,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          ),
                                                        )
                                                            : SizedBox()
                                                            : SizedBox(),


                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        getData.read(
                                                            "UserLogin") !=
                                                            null
                                                            ? homePageController
                                                            .homeInfo
                                                            ?.homeData
                                                            ?.socialEvent
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? Container(
                                                          height:
                                                          Get.height *
                                                              0.37,
                                                          width: Get
                                                              .size.width,
                                                          child: ListView
                                                              .builder(
                                                            shrinkWrap:
                                                            true,
                                                            itemCount: homePageController
                                                                .homeInfo
                                                                ?.homeData
                                                                .socialEvent
                                                                .length
                                                                .clamp(
                                                                0, 5),
                                                            scrollDirection:
                                                            Axis.horizontal,
                                                            padding:
                                                            EdgeInsets
                                                                .zero,
                                                            physics:
                                                            BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                index) {
                                                              return InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await eventDetailsController
                                                                      .getEventData(
                                                                    eventId: homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        .socialEvent[index]
                                                                        .eventId,
                                                                  );
                                                                  Get.toNamed(
                                                                    Routes
                                                                        .eventDetailsScreenOther,
                                                                    arguments: {
                                                                      "eventId":
                                                                      homePageController.homeInfo?.homeData.socialEvent[index].eventId,
                                                                      //"bookStatus": "1",
                                                                      "bookStatus":
                                                                      homePageController.homeInfo?.homeData.socialEvent[index].flag,
                                                                      "maxmember":
                                                                      homePageController.homeInfo?.homeData.mainData.maxmember,
                                                                      "maxguest":
                                                                      homePageController.homeInfo?.homeData.mainData.maxguest,
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                Container(
                                                                  height: Get.height *
                                                                      0.37,
                                                                  width: Get.width /
                                                                      1.5,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      8),
                                                                  child:
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        height: Get.height / 4.9,
                                                                        width: Get.width / 1.4,
                                                                        margin: EdgeInsets.all(5),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          child: FadeInImage.assetNetwork(
                                                                            placeholder: "assets/ezgif.com-crop.gif",
                                                                            height: Get.height / 4.9,
                                                                            width: Get.width / 1.4,
                                                                            image: "${Config.imageUrl}${homePageController.homeInfo?.homeData.socialEvent[index].eventImg ?? ""}",
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 58,
                                                                        width: Get.size.width,
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    homePageController.homeInfo?.homeData.socialEvent[index].eventTitle ?? "",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(
                                                                                      color: BlackColor,
                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                    softWrap: true,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,
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
                                                                                        width: 4,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          homePageController.homeInfo?.homeData.socialEvent[index].eventPlaceName ?? "",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                            fontFamily: FontFamily.gilroyMedium,
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
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Divider(
                                                                          color: Colors.grey.shade300,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 6,
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              homePageController.homeInfo?.homeData.socialEvent[index].eventSdate ?? "",
                                                                              style: TextStyle(
                                                                                fontFamily: FontFamily.gilroyMedium,
                                                                                color: greytext,
                                                                                fontSize: 14,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                    WhiteColor,
                                                                    borderRadius:
                                                                    BorderRadius.circular(20),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                            : SizedBox() :SizedBox(),




                                                       /* SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(padding: EdgeInsets.only(left: 16),child: Text(
                                                          "Maybe you interested in".tr,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color: Colors.black,fontWeight: FontWeight.bold),
                                                        ),),

                                                        SizedBox(
                                                          height: 150, // Height for the horizontal list
                                                          child: ListView.builder(
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: sections.length,
                                                            itemBuilder: (context, index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  Get.to(sections[index]["route"]);
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: 80,
                                                                      height: 80,

                                                                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.grey[200],
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(1.0),
                                                                        child: Image.asset(sections[index]["icon"], fit: BoxFit.contain),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 5),
                                                                    Text(sections[index]["title"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),*/

                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(padding: EdgeInsets.only(left: 16),child: Text(
                                                          "Newspaper".tr,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color: Colors.black,fontWeight: FontWeight.bold),
                                                        ),),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          height: 160, // Fixed height for horizontal scrolling
                                                          child: ListView.builder(
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: homePageController.homeInfo?.homeData.newsList?.length,
                                                            itemBuilder: (context, index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  print(homePageController.homeInfo!.homeData.newsList!.elementAt(index).news_file?? '');
                                                                  //openPDF(Config.imageUrl+homePageController.homeInfo!.homeData.newsList!.elementAt(index).news_file!);
                                                                  /*Get.to(() => PdfViewerScreen(
                                                                    pdfUrl: Config.imageUrl+homePageController.homeInfo!.homeData.newsList!.elementAt(index).news_file!,
                                                                    fileName: "${homePageController.homeInfo!.homeData.newsList!.elementAt(index).title}",
                                                                  ));*/

                                                                  Get.to(WebViewScreen(
                                                                    url: homePageController.homeInfo!.homeData.newsList!.elementAt(index).news_file?? '',
                                                                    title: "${homePageController.homeInfo!.homeData.newsList!.elementAt(index).title}",
                                                                  ));
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: 240,
                                                                      height: 150,
                                                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(16),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color: Colors.black12,
                                                                            blurRadius: 5,
                                                                            spreadRadius: 2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        child: Image.network(
                                                                          Config.imageUrl+homePageController.homeInfo!.homeData.newsList!.elementAt(index).thumbnail,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    /* SizedBox(height: 5),
                                                                    Text(
                                                                      homePageController.homeInfo!.homeData.newsList!.elementAt(index).title,
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(fontSize: 12),
                                                                    ),*/
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        /*  Text(
                                                          "   Upcoming Event's in Your City",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),*/

                                                        homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    ?.nearbyEvent
                                                                    ?.isNotEmpty ??
                                                                false
                                                            ? Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    "Upcoming Program's in your city"
                                                                        .tr,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      color:
                                                                          BlackColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.to(LatestEvent(
                                                                          eventStaus:
                                                                              "3"));
                                                                    },
                                                                    child: Text(
                                                                      "See All"
                                                                          .tr,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontFamily.gilroyMedium,
                                                                        color: gradient
                                                                            .defoultColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox(),
                                                        homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    ?.nearbyEvent
                                                                    ?.isNotEmpty ??
                                                                false
                                                            ? Container(
                                                                height:
                                                                    Get.height *
                                                                        0.42,
                                                                width: Get
                                                                    .size.width,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: homePageController
                                                                      .homeInfo
                                                                      ?.homeData
                                                                      .nearbyEvent
                                                                      .length
                                                                      .clamp(
                                                                          0, 5),
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  physics:
                                                                      BouncingScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        await eventDetailsController
                                                                            .getEventData(
                                                                          eventId: homePageController
                                                                              .homeInfo
                                                                              ?.homeData
                                                                              .nearbyEvent[index]
                                                                              .eventId,
                                                                        );
                                                                        Get.toNamed(
                                                                          Routes
                                                                              .eventDetailsScreenOther,
                                                                          arguments: {
                                                                            "eventId":
                                                                                homePageController.homeInfo?.homeData.nearbyEvent[index].eventId,
                                                                            //"bookStatus": "1",
                                                                            "bookStatus":
                                                                                homePageController.homeInfo?.homeData.nearbyEvent[index].flag,
                                                                            "maxmember":
                                                                                homePageController.homeInfo?.homeData.mainData.maxmember,
                                                                            "maxguest":
                                                                                homePageController.homeInfo?.homeData.mainData.maxguest,
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height: Get.height *
                                                                            0.42,
                                                                        width: Get.width /
                                                                            1.5,
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Container(
                                                                              height: Get.height / 3.9,
                                                                              width: Get.width / 1.4,
                                                                              margin: EdgeInsets.all(5),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(20),
                                                                                child: FadeInImage.assetNetwork(
                                                                                  placeholder: "assets/ezgif.com-crop.gif",
                                                                                  height: Get.height / 4.9,
                                                                                  width: Get.width / 1.4,
                                                                                  image: "${Config.imageUrl}${homePageController.homeInfo?.homeData.nearbyEvent[index].eventImg ?? ""}",
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              height: 58,
                                                                              width: Get.size.width,
                                                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          homePageController.homeInfo?.homeData.nearbyEvent[index].eventTitle ?? "",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                            color: BlackColor,
                                                                                            fontFamily: FontFamily.gilroyBold,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                          softWrap: true,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 4,
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
                                                                                              width: 4,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                homePageController.homeInfo?.homeData.nearbyEvent[index].eventPlaceName ?? "",
                                                                                                maxLines: 1,
                                                                                                style: TextStyle(
                                                                                                  fontFamily: FontFamily.gilroyMedium,
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
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Divider(
                                                                                color: Colors.grey.shade300,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 6,
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                                                              child: Row(
                                                                                children: [
                                                                                  Text(
                                                                                    homePageController.homeInfo?.homeData.nearbyEvent[index].eventSdate ?? "",
                                                                                    style: TextStyle(
                                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                                      color: greytext,
                                                                                      fontSize: 14,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              WhiteColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                            : SizedBox(),

                                                        SizedBox( height: 10,),


                                                        homePageController
                                                            .homeInfo1
                                                            ?.homeData
                                                            ?.latestEvent
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Text(
                                                                "Soulful Nights"
                                                                  .tr,
                                                              style:
                                                              TextStyle(
                                                                fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                                color:
                                                                BlackColor,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                17,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            TextButton(
                                                              onPressed:
                                                                  () {
                                                                Get.to(LatestEventKclub(
                                                                    eventStaus:
                                                                    "1"));
                                                              },
                                                              child: Text(
                                                                "See All"
                                                                    .tr,
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  FontFamily.gilroyMedium,
                                                                  color: gradient
                                                                      .defoultColor,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        )
                                                            : SizedBox(),
                                                        homePageController
                                                            .homeInfo1
                                                            ?.homeData
                                                            ?.latestEvent
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? Container(
                                                          height:
                                                          Get.height *
                                                              0.42,
                                                          width: Get
                                                              .size.width,
                                                          child: ListView
                                                              .builder(
                                                            shrinkWrap:
                                                            true,
                                                            itemCount: homePageController
                                                                .homeInfo1
                                                                ?.homeData
                                                                .latestEvent
                                                                .length
                                                                /*.clamp(
                                                                0, 5)*/,
                                                            scrollDirection:
                                                            Axis.horizontal,
                                                            padding:
                                                            EdgeInsets
                                                                .zero,
                                                            physics:
                                                            BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                index) {
                                                              return InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await eventDetailsControllerkclub
                                                                      .getEventData(
                                                                    eventId: homePageController
                                                                        .homeInfo1
                                                                        ?.homeData
                                                                        .latestEvent[index]
                                                                        .eventId,
                                                                  );
                                                                  Get.toNamed(
                                                                    Routes
                                                                        .eventDetailsScreenKclub,
                                                                    arguments: {
                                                                      "eventId":
                                                                      homePageController.homeInfo1?.homeData.latestEvent[index].eventId,
                                                                      //"bookStatus": "1",
                                                                      "bookStatus":
                                                                      homePageController.homeInfo1?.homeData.latestEvent[index].flag,
                                                                      "maxmember":
                                                                      homePageController.homeInfo1?.homeData.mainData.maxmember,
                                                                      "maxguest":
                                                                      homePageController.homeInfo1?.homeData.mainData.maxguest,
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                Container(
                                                                  height: Get.height *
                                                                      0.42,
                                                                  width: Get.width /
                                                                      1.5,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      8),
                                                                  child:
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        height: Get.height / 3.9,
                                                                        width: Get.width / 1.4,
                                                                        margin: EdgeInsets.all(5),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          child: FadeInImage.assetNetwork(
                                                                            placeholder: "assets/ezgif.com-crop.gif",
                                                                            height: Get.height / 4.9,
                                                                            width: Get.width / 1.4,
                                                                            image: "${Config.imageUrlkclub}${homePageController.homeInfo1?.homeData.latestEvent[index].eventImg ?? ""}",
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 58,
                                                                        width: Get.size.width,
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    homePageController.homeInfo1?.homeData.latestEvent[index].eventTitle ?? "",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(
                                                                                      color: BlackColor,
                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                    softWrap: true,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,
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
                                                                                        width: 4,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          homePageController.homeInfo1?.homeData.latestEvent[index].eventPlaceName ?? "",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                            fontFamily: FontFamily.gilroyMedium,
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
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Divider(
                                                                          color: Colors.grey.shade300,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 6,
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              homePageController.homeInfo1?.homeData.latestEvent[index].eventSdate ?? "",
                                                                              style: TextStyle(
                                                                                fontFamily: FontFamily.gilroyMedium,
                                                                                color: greytext,
                                                                                fontSize: 14,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                    WhiteColor,
                                                                    borderRadius:
                                                                    BorderRadius.circular(20),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                            : SizedBox(),



                                                        SizedBox( height: 10,),


                                                        homePageController
                                                            .homeInfo1
                                                            ?.homeData
                                                            ?.karaokePractice
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              "Karaoke Practice"
                                                                  .tr,
                                                              style:
                                                              TextStyle(
                                                                fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                                color:
                                                                BlackColor,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                17,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            TextButton(
                                                              onPressed:
                                                                  () {
                                                                Get.to(LatestEventKclub(
                                                                    eventStaus:
                                                                    "2"));
                                                              },
                                                              child: Text(
                                                                "See All"
                                                                    .tr,
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  FontFamily.gilroyMedium,
                                                                  color: gradient
                                                                      .defoultColor,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        )
                                                            : SizedBox(),
                                                        homePageController
                                                            .homeInfo1
                                                            ?.homeData
                                                            ?.karaokePractice
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? Container(
                                                          height:
                                                          Get.height *
                                                              0.42,
                                                          width: Get
                                                              .size.width,
                                                          child: ListView
                                                              .builder(
                                                            shrinkWrap:
                                                            true,
                                                            itemCount: homePageController
                                                                .homeInfo1
                                                                ?.homeData
                                                                .karaokePractice
                                                                .length
                                                            /*.clamp(
                                                                0, 5)*/,
                                                            scrollDirection:
                                                            Axis.horizontal,
                                                            padding:
                                                            EdgeInsets
                                                                .zero,
                                                            physics:
                                                            BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                index) {
                                                              return InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await eventDetailsControllerkclub
                                                                      .getEventData(
                                                                    eventId: homePageController
                                                                        .homeInfo1
                                                                        ?.homeData
                                                                        .karaokePractice[index]
                                                                        .eventId,
                                                                  );
                                                                  Get.toNamed(
                                                                    Routes
                                                                        .eventDetailsScreenKclubPractice,
                                                                    arguments: {
                                                                      "eventId":
                                                                      homePageController.homeInfo1?.homeData.karaokePractice[index].eventId,
                                                                      //"bookStatus": "1",
                                                                      "bookStatus":
                                                                      homePageController.homeInfo1?.homeData.karaokePractice[index].flag,
                                                                      "maxmember":
                                                                      homePageController.homeInfo1?.homeData.mainData.maxmember,
                                                                      "maxguest":
                                                                      homePageController.homeInfo1?.homeData.mainData.maxguest,
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                Container(
                                                                  height: Get.height *
                                                                      0.42,
                                                                  width: Get.width /
                                                                      1.5,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      8),
                                                                  child:
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        height: Get.height / 3.9,
                                                                        width: Get.width / 1.4,
                                                                        margin: EdgeInsets.all(5),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          child: FadeInImage.assetNetwork(
                                                                            placeholder: "assets/ezgif.com-crop.gif",
                                                                            height: Get.height / 4.9,
                                                                            width: Get.width / 1.4,
                                                                            image: "${Config.imageUrlkclub}${homePageController.homeInfo1?.homeData.karaokePractice[index].eventImg ?? ""}",
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 58,
                                                                        width: Get.size.width,
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    homePageController.homeInfo1?.homeData.karaokePractice[index].eventTitle ?? "",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(
                                                                                      color: BlackColor,
                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                    softWrap: true,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,
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
                                                                                        width: 4,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          homePageController.homeInfo1?.homeData.karaokePractice[index].eventPlaceName ?? "",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                            fontFamily: FontFamily.gilroyMedium,
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
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Divider(
                                                                          color: Colors.grey.shade300,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 6,
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              homePageController.homeInfo1?.homeData.karaokePractice[index].eventSdate ?? "",
                                                                              style: TextStyle(
                                                                                fontFamily: FontFamily.gilroyMedium,
                                                                                color: greytext,
                                                                                fontSize: 14,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                    WhiteColor,
                                                                    borderRadius:
                                                                    BorderRadius.circular(20),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                            : SizedBox(),


                                                        SizedBox( height: 10,),


                                                        homePageController
                                                            .homeInfo1
                                                            ?.homeData
                                                            ?.karaokeEvent
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              "Karaoke Club"
                                                                  .tr,
                                                              style:
                                                              TextStyle(
                                                                fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                                color:
                                                                BlackColor,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                17,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            TextButton(
                                                              onPressed:
                                                                  () {
                                                                Get.to(LatestEventKclub(
                                                                    eventStaus:
                                                                    "3"));
                                                              },
                                                              child: Text(
                                                                "See All"
                                                                    .tr,
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  FontFamily.gilroyMedium,
                                                                  color: gradient
                                                                      .defoultColor,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        )
                                                            : SizedBox(),
                                                        homePageController
                                                            .homeInfo1
                                                            ?.homeData
                                                            ?.karaokeEvent
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? Container(
                                                          height:
                                                          Get.height *
                                                              0.42,
                                                          width: Get
                                                              .size.width,
                                                          child: ListView
                                                              .builder(
                                                            shrinkWrap:
                                                            true,
                                                            itemCount: homePageController
                                                                .homeInfo1
                                                                ?.homeData
                                                                .karaokeEvent
                                                                .length
                                                            /*.clamp(
                                                                0, 5)*/,
                                                            scrollDirection:
                                                            Axis.horizontal,
                                                            padding:
                                                            EdgeInsets
                                                                .zero,
                                                            physics:
                                                            BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                index) {
                                                              return InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await eventDetailsControllerkclub
                                                                      .getEventData(
                                                                    eventId: homePageController
                                                                        .homeInfo1
                                                                        ?.homeData
                                                                        .karaokeEvent[index]
                                                                        .eventId,
                                                                  );
                                                                  Get.toNamed(
                                                                    Routes
                                                                        .eventDetailsScreenKclub,
                                                                    arguments: {
                                                                      "eventId":
                                                                      homePageController.homeInfo1?.homeData.karaokeEvent[index].eventId,
                                                                      //"bookStatus": "1",
                                                                      "bookStatus":
                                                                      homePageController.homeInfo1?.homeData.karaokeEvent[index].flag,
                                                                      "maxmember":
                                                                      homePageController.homeInfo1?.homeData.mainData.maxmember,
                                                                      "maxguest":
                                                                      homePageController.homeInfo1?.homeData.mainData.maxguest,
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                Container(
                                                                  height: Get.height *
                                                                      0.42,
                                                                  width: Get.width /
                                                                      1.5,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      8),
                                                                  child:
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        height: Get.height / 3.9,
                                                                        width: Get.width / 1.4,
                                                                        margin: EdgeInsets.all(5),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          child: FadeInImage.assetNetwork(
                                                                            placeholder: "assets/ezgif.com-crop.gif",
                                                                            height: Get.height / 4.9,
                                                                            width: Get.width / 1.4,
                                                                            image: "${Config.imageUrlkclub}${homePageController.homeInfo1?.homeData.karaokeEvent[index].eventImg ?? ""}",
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 58,
                                                                        width: Get.size.width,
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    homePageController.homeInfo1?.homeData.karaokeEvent[index].eventTitle ?? "",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(
                                                                                      color: BlackColor,
                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                    softWrap: true,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,
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
                                                                                        width: 4,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          homePageController.homeInfo1?.homeData.karaokeEvent[index].eventPlaceName ?? "",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                            fontFamily: FontFamily.gilroyMedium,
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
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Divider(
                                                                          color: Colors.grey.shade300,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 6,
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              homePageController.homeInfo1?.homeData.karaokeEvent[index].eventSdate ?? "",
                                                                              style: TextStyle(
                                                                                fontFamily: FontFamily.gilroyMedium,
                                                                                color: greytext,
                                                                                fontSize: 14,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                    WhiteColor,
                                                                    borderRadius:
                                                                    BorderRadius.circular(20),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                            : SizedBox(),

                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15),
                                                          child: Text(
                                                            "Live Broadcast".tr,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        homePageController
                                                                    .homeInfo!
                                                                    .homeData
                                                                    .livevideoList!
                                                                    .length >
                                                                0
                                                            ? Container(
                                                                height: 180,
                                                                width: Get
                                                                    .size.width,
                                                                child: ListView
                                                                    .builder(
                                                                  itemCount: homePageController
                                                                      .homeInfo!
                                                                      .homeData
                                                                      .livevideoList
                                                                      ?.length,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return homePageController.homeInfo!.homeData.livevideoList?.elementAt(index) !=
                                                                            "null"
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.to(VideoPreviewScreen(
                                                                                url: homePageController.homeInfo!.homeData.livevideoList?.elementAt(index).video_path ?? "",
                                                                              ));
                                                                            },
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Container(
                                                                                  height: 150,
                                                                                  width: 268,
                                                                                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    child: FadeInImage.assetNetwork(
                                                                                      placeholder: "assets/ezgif.com-crop.gif",
                                                                                      placeholderCacheHeight: 200,
                                                                                      placeholderCacheWidth: 200,
                                                                                      placeholderFit: BoxFit.cover,
                                                                                      image: YoutubePlayer.getThumbnail(
                                                                                        videoId: YoutubePlayer.convertUrlToId(homePageController.homeInfo!.homeData.livevideoList?.elementAt(index).video_path ?? "")!,
                                                                                      ),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    color: Colors.white,
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey.shade300,
                                                                                        offset: const Offset(
                                                                                          0.5,
                                                                                          0.5,
                                                                                        ),
                                                                                        blurRadius: 0.5,
                                                                                        spreadRadius: 0.5,
                                                                                      ),
                                                                                      //BoxShadow
                                                                                      BoxShadow(
                                                                                        color: Colors.white,
                                                                                        offset: const Offset(0.0, 0.0),
                                                                                        blurRadius: 0.0,
                                                                                        spreadRadius: 0.0,
                                                                                      ),
                                                                                      //BoxShadow
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Positioned(
                                                                                  top: 35,
                                                                                  left: 35,
                                                                                  right: 35,
                                                                                  bottom: 50,
                                                                                  child: Image.asset(
                                                                                    "assets/videopush.png",
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : SizedBox();
                                                                  },
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15),
                                                          child: Text(
                                                            "Video Gallery".tr,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),

                                                        homePageController
                                                                    .homeInfo!
                                                                    .homeData
                                                                    .videoGalleryList!
                                                                    .length >
                                                                0
                                                            ? Container(
                                                                height: 180,
                                                                width: Get
                                                                    .size.width,
                                                                child: ListView
                                                                    .builder(
                                                                  itemCount: homePageController
                                                                      .homeInfo!
                                                                      .homeData
                                                                      .videoGalleryList
                                                                      ?.length,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return homePageController.homeInfo!.homeData.videoGalleryList?.elementAt(index) !=
                                                                            "null"
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.to(VideoPreviewScreen(
                                                                                url: homePageController.homeInfo!.homeData.videoGalleryList?.elementAt(index).video_path ?? "",
                                                                              ));
                                                                            },
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Container(
                                                                                  height: 150,
                                                                                  width: 268,
                                                                                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    child: FadeInImage.assetNetwork(
                                                                                      placeholder: "assets/ezgif.com-crop.gif",
                                                                                      placeholderCacheHeight: 200,
                                                                                      placeholderCacheWidth: 200,
                                                                                      placeholderFit: BoxFit.cover,
                                                                                      image: YoutubePlayer.getThumbnail(
                                                                                        videoId: YoutubePlayer.convertUrlToId(homePageController.homeInfo!.homeData.videoGalleryList?.elementAt(index).video_path ?? "")!,
                                                                                      ),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    color: Colors.white,
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey.shade300,
                                                                                        offset: const Offset(
                                                                                          0.5,
                                                                                          0.5,
                                                                                        ),
                                                                                        blurRadius: 0.5,
                                                                                        spreadRadius: 0.5,
                                                                                      ),
                                                                                      //BoxShadow
                                                                                      BoxShadow(
                                                                                        color: Colors.white,
                                                                                        offset: const Offset(0.0, 0.0),
                                                                                        blurRadius: 0.0,
                                                                                        spreadRadius: 0.0,
                                                                                      ),
                                                                                      //BoxShadow
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Positioned(
                                                                                  top: 35,
                                                                                  left: 35,
                                                                                  right: 35,
                                                                                  bottom: 45,
                                                                                  child: Image.asset(
                                                                                    "assets/videopush.png",
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : SizedBox();
                                                                  },
                                                                ),
                                                              )
                                                            : SizedBox(),

                                                        getData.read(
                                                                    "UserLogin") !=
                                                                null
                                                            ? homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        ?.clubList
                                                                        ?.isNotEmpty ??
                                                                    false
                                                                ? Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        "Group in Your city"
                                                                            .tr,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontFamily.gilroyBold,
                                                                          color:
                                                                              BlackColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              17,
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          //Get.to(LatestEvent(eventStaus: "1"));
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "".tr,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                FontFamily.gilroyMedium,
                                                                            color:
                                                                                gradient.defoultColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox()
                                                            : SizedBox(),
                                                        getData.read(
                                                                    "UserLogin") !=
                                                                null
                                                            ? homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        ?.clubList
                                                                        ?.isNotEmpty ??
                                                                    false
                                                                ? SizedBox(
                                                                    height: 180,
                                                                    width: Get
                                                                        .size
                                                                        .width,
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount: homePageController
                                                                          .homeInfo
                                                                          ?.homeData
                                                                          .clubList
                                                                          .length
                                                                          /*.clamp(
                                                                              0,
                                                                              5)*/,
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            await clubDetailsController.getClubData(
                                                                              clubId: homePageController.homeInfo?.homeData.clubList[index].id,
                                                                            );
                                                                            Get.to(ClubDetailsScreen(
                                                                              orgId: homePageController.homeInfo?.homeData.clubList[index].id,
                                                                              orgImg: homePageController.homeInfo?.homeData.clubList[index].img,
                                                                              orgName: homePageController.homeInfo?.homeData.clubList[index].title,
                                                                              orgAddresss: homePageController.homeInfo?.homeData.clubList[index].location,
                                                                            ));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                180,
                                                                            width:
                                                                                280,
                                                                            margin: EdgeInsets.only(
                                                                                left: 10,
                                                                                right: 0,
                                                                                top: 0,
                                                                                bottom: 10),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(0.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    margin: EdgeInsets.all(0.0),
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(
                                                                                        color: Colors.deepPurpleAccent,
                                                                                        // Set the border color
                                                                                        width: 1.0, // Set the border width
                                                                                      ),
                                                                                      color: Colors.white,

                                                                                      borderRadius: BorderRadius.circular(10.0), // Optional: match Card's border radius
                                                                                    ),
                                                                                    child: Card(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(0.0),
                                                                                      ),
                                                                                      elevation: 0,
                                                                                      color: Colors.white,
                                                                                      child: Container(
                                                                                        height: 180,
                                                                                        width: 270,
                                                                                        // Adjusted width
                                                                                        padding: EdgeInsets.all(0.0),
                                                                                        child: Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            // Club Image
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                                              /*${Config.imageUrl}*/
                                                                                              child: Image.network(
                                                                                                "${Config.imageUrl}${homePageController.homeInfo?.homeData.clubList[index].img}",
                                                                                                height: Get.height,
                                                                                                // Adjust height as needed
                                                                                                width: 120,
                                                                                                // Adjust width as needed
                                                                                                fit: BoxFit.contain,
                                                                                              ),
                                                                                            ),

                                                                                            // Adjusted padding

                                                                                            // Expanded to take the remaining space
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                height: 190,
                                                                                                color: Colors.white,
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                                                      // Adds 16 pixels of padding on all sides
                                                                                                      child: Text(
                                                                                                        homePageController.homeInfo?.homeData.clubList[index].title ?? "",
                                                                                                        style: TextStyle(
                                                                                                          fontSize: 16.0,
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(height: 4.0),
                                                                                                    Text(
                                                                                                      homePageController.homeInfo?.homeData.clubList[index].location ?? "",
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 12.0,
                                                                                                        color: Colors.black,
                                                                                                      ),
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      maxLines: 1,
                                                                                                    ),
                                                                                                    Row(
                                                                                                      children: [
                                                                                                        /* Image.asset(
                                                                "assets/Location.png",
                                                                color: Colors.grey,
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              SizedBox(width: 4),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              homePageController.homeInfo?.homeData.clubList[index].location ?? "",
                                                                              style: TextStyle(
                                                                                fontSize: 12.0,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),*/
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              color: WhiteColor,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                : SizedBox()
                                                            : SizedBox(),

                                                        SizedBox(
                                                          height: 200,
                                                        )
                                                      ],
                                                    ))
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.wifi_off,
                                                            size: 100,
                                                            color: Colors.grey),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          'No Internet Connection'
                                                              .tr,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(height: 20),
                                                        ElevatedButton(
                                                          onPressed:
                                                              _checkInternetConnection,
                                                          // Retry button to check connectivity
                                                          child:
                                                              Text('Retry'.tr),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                  ),
                    decoration: BoxDecoration(
                      color: lightyellow,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*bottomNavigationBar: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/app_bg.png', // Replace with your image path
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
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Exit Application"),
                            content: Text("Are you sure you want to exit?"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                              TextButton(
                                child: Text("Exit"),
                                onPressed: () {
                                  exit(0); // Close the application
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Visibility(
                    visible: _isLoggin,
                    child: TextButton(
                      onPressed: () {
                        // Add your onClick logic here
                        print("Bhog QR clicked");
                        Get.to(BhogQRScreen());
                      },
                      child: Text(
                        "Booking QR",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  */ /*TextButton(
                    onPressed: () {
                      // Add your onClick logic here

                      if (getData.read("UserLogin") != null) {
                        Get.to(() => MyClubScreen());
                      } else {
                        showLoginPopup(context);
                      }
                    },
                    child: Text(
                      "My Club",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),*/ /*
                ],
              ),
            ),
          ],
        ),*/
      ),
    );
  }

  void openPDF(String url) async {
    //
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  /*void showLoginPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aami Bengali'),
          content: Text('Kindly Note:\n If your club is registered with AamiBengali.com, and your name is included in the member list,'
              ' you can proceed with login.If you are not yet added to your club’s member list, kindly request your club to register with AamiBengali.com.'),

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
  }*/
  void showLoginPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${clubName}',
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
                'Please Note: Before logging in, ensure the following:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurpleAccent),
              ),
              Text(
                '1. Your Centre is registered on Jain Jagruti Centre.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10), // Adds some spacing between the texts
              Text(
                '2. Your name and mobile number are updated in your centre’s member list.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10), // Adds some spacing between the texts
              Text(
                'If both conditions are met, you may proceed to log in. If not, you can continue as a guest or apply for membership in your preferred centre.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
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
                'Login'.tr,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
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
              height: 10,
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
              height: 5,
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

  Future deleteSheet() {
    return Get.bottomSheet(
      Container(
        height: 280,
        width: Get.size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                "Delete Account".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: FontFamily.gilroyBold,
                  color: RedColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: greytext,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                "Are you sure you want to delete account?".tr,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyMedium,
                  fontSize: 16,
                  color: BlackColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                "Your account data will be completely deleted in 30 days.".tr,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyMedium,
                  fontSize: 16,
                  color: BlackColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back(); // Close the bottom sheet
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Cancel".tr,
                        style: TextStyle(
                          color: gradient.defoultColor,
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
                    onTap: () {
                      // Show confirmation dialog
                      Get.defaultDialog(
                        title: "Confirm Delete".tr,
                        middleText:
                            "Are you sure you want to delete your account? This action cannot be undone."
                                .tr,
                        textCancel: "No".tr,
                        textConfirm: "Yes, Delete".tr,
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          // Proceed with deletion
                          pageListController.deletAccount();
                          Get.back(); // Close confirmation dialog
                          Get.back(); // Close bottom sheet
                        },
                        onCancel: () {
                          Get.back(); // Close the confirmation dialog
                        },
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes, Remove".tr,
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
                ),
              ],
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
    );
  }
}


/*class HotelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text("Hotel Section")), body: Center(child: Text("Hotel Section")));
}*/

class MatrimonyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text("Matrimony Section")), body: Center(child: Text("Matrimony Section")));
}

class LabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text("Diagnostic Lab Section")), body: Center(child: Text("Diagnostic Lab Section")));
}

class TravelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text("Travel Section")), body: Center(child: Text("Travel Section")));
}

class ELearningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text("E-learning Section")), body: Center(child: Text("E-learning Section")));
}