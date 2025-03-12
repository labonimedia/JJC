import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller/eventdetails_controller.dart';
import '../controller/my_club_controller.dart';
import '../controller/my_club_home_controller.dart';
import '../helpar/routes_helpar.dart';
import '../model/fontfamily_model.dart';
import '../utils/Colors.dart';
import 'bhog_qr_screen.dart';
import 'club_details.dart';
import 'memberprofilescreen.dart';

class MyClubScreen extends StatefulWidget {
  const MyClubScreen({super.key});

  @override
  State<MyClubScreen> createState() => _MyClubScreenState();
}

class _MyClubScreenState extends State<MyClubScreen> {
  MyClubHomePageController homePageController = Get.find();
  EventDetailsController eventDetailsController = Get.find();
  MyClubDetailsController clubDetailsController = Get.find();
  bool isLoading = true; // Loading flag
  bool hasError = false;


  @override
  void initState() {
    super.initState();
    loadData();

  }

  void loadData() async {
    setState(() {
      isLoading = true;
      hasError = false; // Reset error state
    });

    try {
      // Fetch the data without setState
      await homePageController.getHomeDataApi();

      // Once data is fetched, update the UI state
      setState(() {
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                          "My Clubs".tr,
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
                height: Get.size.height,
                width: Get.size.width,
                child: isLoading
                    ? Center(
                    child:
                    CircularProgressIndicator()) // Show loading indicator
                    : hasError
                    ? Center(
                    child: Text(
                        'Failed to load data. Try again.')) // Show error message
                    : homePageController.homeInfo?.homeData?.clubList
                    ?.isEmpty ??
                    true
                    ? Center(
                    child: Text(
                        'You are not registered with any club.')) // Handle empty data case
                    : Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Adjust the padding value as needed
                  child: SingleChildScrollView(
                      scrollDirection: Axis
                          .vertical, // Scroll vertically
                      child: Container(
                          height: Get.height +
                              100, // Example height
                          width: double.infinity,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics:
                            NeverScrollableScrollPhysics(),
                            children: [
                              homePageController
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
                                    "My Clubs"
                                        .tr,
                                    style:
                                    TextStyle(
                                      fontFamily:
                                      FontFamily
                                          .gilroyBold,
                                      color:
                                      BlackColor,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      //Get.to(LatestEvent(eventStaus: "1"));
                                    },
                                    child: Text(
                                      "".tr,
                                      style:
                                      TextStyle(
                                        fontFamily:
                                        FontFamily
                                            .gilroyMedium,
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
                                  ?.clubList
                                  ?.isNotEmpty ??
                                  false
                                  ? SizedBox(
                                height: 180,
                                width:
                                Get.size.width,
                                child: ListView
                                    .builder(
                                  itemCount:
                                  homePageController
                                      .homeInfo
                                      ?.homeData
                                      .clubList
                                      .length
                                      .clamp(
                                      0, 5),
                                  scrollDirection:
                                  Axis.horizontal,
                                  shrinkWrap: true,
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
                                              .clubList[
                                          index]
                                              .id,
                                        );
                                        Get.to(
                                            ClubDetailsScreen(
                                              orgId: homePageController
                                                  .homeInfo
                                                  ?.homeData
                                                  .clubList[
                                              index]
                                                  .id,
                                              orgImg: homePageController
                                                  .homeInfo
                                                  ?.homeData
                                                  .clubList[
                                              index]
                                                  .img,
                                              orgName: homePageController
                                                  .homeInfo
                                                  ?.homeData
                                                  .clubList[
                                              index]
                                                  .title,
                                              orgAddresss: homePageController
                                                  .homeInfo
                                                  ?.homeData
                                                  .clubList[
                                              index]
                                                  .location,
                                            ));
                                      },
                                      child:
                                      Container(
                                        height: 180,
                                        width: 280,
                                        margin: EdgeInsets.only(
                                            left:
                                            10,
                                            right:
                                            0,
                                            top: 0,
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
                                                margin:
                                                EdgeInsets.all(0.0),
                                                decoration:
                                                BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.deepPurpleAccent,
                                                    // Set the border color
                                                    width: 1.0, // Set the border width
                                                  ),
                                                  color: Colors.white,

                                                  borderRadius: BorderRadius.circular(10.0), // Optional: match Card's border radius
                                                ),
                                                child:
                                                Card(
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
                                          borderRadius:
                                          BorderRadius.circular(
                                              30),
                                          color:
                                          WhiteColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                                  : SizedBox(),
                              //homePageController.homeInfo!.homeData.latestEvent.isNotEmpty
                              /*homePageController
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
                                      fontSize: 17,
                                    ),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      //Get.to(LatestEvent(eventStaus: "1"));
                                    },
                                    child: Text(
                                      "".tr,
                                      style:
                                      TextStyle(
                                        fontFamily:
                                        FontFamily
                                            .gilroyMedium,
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
                              homePageController
                                  .homeInfo
                                  ?.homeData
                                  ?.eventList
                                  ?.isNotEmpty ??
                                  false
                                  ? SizedBox(
                                height: 380,
                                width:
                                Get.size.width,
                                child: ListView.builder(
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



                                              return InkWell(
                                                onTap: () async {
                                                  await eventDetailsController
                                                      .getEventData(
                                                    eventId: event
                                                        .eventId,
                                                  );
                                                  Get.toNamed(
                                                    Routes.eventDetailsScreenNew,
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
                                        SizedBox(height: 50,)
                                      ],
                                    );
                                  },
                                ),
                              )
                                  : SizedBox(),
                            ],
                          ))),
                ),
                decoration: BoxDecoration(
                  color: lightyellow,
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
      bottomNavigationBar: Stack(
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
                Visibility(
                  visible: true,
                  child: TextButton(
                    onPressed: () {
                      // Add your onClick logic here
                      print("Bhog QR clicked");
                      Get.to(BhogQRScreen());
                    },
                    child: Text(
                      "Bhog QR",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.yellow),
                  onPressed: () {
                    // Add your home button functionality here

                      Get.to(() => MemberProfileScreen());

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  
  

}