// ignore_for_file: sort_child_properties_last, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/controller/eventdetails_controller.dart';
import 'package:jjcentre/controller/eventdetailskclub_controller.dart';
import 'package:jjcentre/controller/home_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/utils/Colors.dart';

import '../../controller/eventdetails_controller1.dart';

class LatestEventKclub extends StatefulWidget {
  String? eventStaus;
  LatestEventKclub({super.key, this.eventStaus});

  @override
  State<LatestEventKclub> createState() => _LatestEventState();
}

class _LatestEventState extends State<LatestEventKclub> {
  HomePageController homePageController = Get.find();
  EventDetailsControllerKclub eventDetailsController = Get.find();
  @override
  Widget build(BuildContext context) {
    final latestEvents = homePageController.homeInfo1?.homeData.latestEvent ?? [];
    //print(latestEvents.length);
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: BlackColor,
          ),
        ),
        title: Text(
          widget.eventStaus == "1"
              ? "Soulful Nights".tr
              : widget.eventStaus == "2"
              ? "Practice Event".tr
              : widget.eventStaus == "3"
              ? "Karaoke Event".tr
              : "",
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<HomePageController>(builder: (context) {
        return Column(
          children: [
            widget.eventStaus == "1"
                ? Expanded(
              child: ListView.builder(
                itemCount: homePageController
                    .homeInfo1?.homeData.latestEvent.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await eventDetailsController.getEventData(
                        eventId: homePageController.homeInfo1?.homeData
                            .latestEvent[index].eventId,
                      );
                      Get.toNamed(
                        Routes.eventDetailsScreenKclub,
                        arguments: {
                          "eventId": homePageController.homeInfo1?.homeData.latestEvent[index].eventId,
                          "bookStatus": homePageController.homeInfo1?.homeData.latestEvent[index].flag,
                          "maxmember": homePageController.homeInfo?.homeData.mainData.maxmember,
                          "maxguest": homePageController.homeInfo?.homeData.mainData.maxguest,
                        },
                      );
                    },
                    child: Container(
                      height: 140,
                      width: Get.size.width,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 140,
                            width: 130,
                            margin: EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Builder(
                                builder: (context) {
                                  // Check if latestEvent exists and has enough elements
                                  final latestEvents = homePageController.homeInfo1?.homeData.latestEvent ?? [];

                                  if (latestEvents.isEmpty || index >= latestEvents.length) {
                                    return Image.asset(
                                      "assets/default_image.png", // Fallback image
                                      height: 140,
                                      fit: BoxFit.cover,
                                    );
                                  }

                                  return FadeInImage.assetNetwork(
                                    fadeInCurve: Curves.easeInCirc,
                                    placeholder: "assets/ezgif.com-crop.gif",
                                    height: 140,
                                    image: "${Config.imageUrlkclub}${latestEvents[index].eventImg ?? ""}",
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          index < latestEvents.length?
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  homePageController
                                      .homeInfo1
                                      ?.homeData
                                      .latestEvent[index]
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
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  homePageController
                                      .homeInfo1
                                      ?.homeData
                                      .latestEvent[index]
                                      .eventSdate ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyMedium,
                                    color: gradient.defoultColor,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/Location.png",
                                      color: gradient.defoultColor,
                                      height: 15,
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: Get.size.width * 0.48,
                                      child: Text(
                                        homePageController
                                            .homeInfo1
                                            ?.homeData
                                            .latestEvent[index]
                                            .eventPlaceName ??
                                            "",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily:
                                          FontFamily.gilroyMedium,
                                          fontSize: 14,
                                          color: BlackColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ): SizedBox(),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            )
                : widget.eventStaus == "2"
                ? Expanded(
              child: ListView.builder(
                itemCount: homePageController
                    .homeInfo1?.homeData.karaokePractice.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await eventDetailsController.getEventData(
                        eventId: homePageController.homeInfo1?.homeData
                            .karaokePractice[index].eventId,
                      );
                      Get.toNamed(
                        Routes.eventDetailsScreenKclubPractice,
                        arguments: {
                          "eventId": homePageController
                              .homeInfo1
                              ?.homeData
                              .karaokePractice[index]
                              .eventId,
                          "bookStatus": homePageController
                          .homeInfo1
                          ?.homeData
                          .karaokePractice[index].flag,
                          "maxmember": homePageController.homeInfo?.homeData.mainData.maxmember,
                          "maxguest": homePageController.homeInfo?.homeData.mainData.maxguest,
                        },
                      );
                    },
                    child: Container(
                      height: 140,
                      width: Get.size.width,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 140,
                            width: 130,
                            margin: EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FadeInImage.assetNetwork(
                                fadeInCurve: Curves.easeInCirc,
                                placeholder:
                                "assets/ezgif.com-crop.gif",
                                height: 140,
                                image:
                                "${Config.imageUrlkclub}${homePageController.homeInfo1?.homeData.karaokePractice[index].eventImg ?? ""}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  homePageController
                                      .homeInfo1
                                      ?.homeData
                                      .karaokePractice[index]
                                      .eventTitle ??
                                      "",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  homePageController
                                      .homeInfo1
                                      ?.homeData
                                      .karaokePractice[index]
                                      .eventSdate ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    color: gradient.defoultColor,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/Location.png",
                                      color: gradient.defoultColor,
                                      height: 15,
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: Get.size.width * 0.48,
                                      child: Text(
                                        homePageController
                                            .homeInfo1
                                            ?.homeData
                                            .karaokePractice[index]
                                            .eventPlaceName ??
                                            "",
                                        style: TextStyle(
                                          fontFamily:
                                          FontFamily.gilroyMedium,
                                          fontSize: 14,
                                          color: BlackColor,
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
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            )
                : widget.eventStaus == "3"
                ? Expanded(
              child: ListView.builder(
                itemCount: homePageController.homeInfo1?.homeData.karaokeEvent.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await eventDetailsController.getEventData(
                        eventId: homePageController.homeInfo1
                            ?.homeData.karaokeEvent[index].eventId,
                      );
                      Get.toNamed(
                        Routes.eventDetailsScreenKclub,
                        arguments: {
                          "eventId": homePageController.homeInfo1?.homeData.karaokeEvent[index].eventId,
                          "bookStatus": homePageController.homeInfo1?.homeData.karaokeEvent[index].flag,
                          "maxmember": homePageController.homeInfo?.homeData.mainData.maxmember,
                          "maxguest": homePageController.homeInfo?.homeData.mainData.maxguest,
                        },
                      );
                    },
                    child: Container(
                      height: 140,
                      width: Get.size.width,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 140,
                            width: 130,
                            margin: EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(15),
                              child: FadeInImage.assetNetwork(
                                fadeInCurve: Curves.easeInCirc,
                                placeholder:
                                "assets/ezgif.com-crop.gif",
                                height: 140,
                                image:
                                "${Config.imageUrlkclub}${homePageController.homeInfo1?.homeData.karaokeEvent[index].eventImg ?? ""}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  homePageController
                                      .homeInfo1
                                      ?.homeData
                                      .karaokeEvent[index]
                                      .eventTitle ??
                                      "",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyBold,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow:
                                    TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  homePageController
                                      .homeInfo1
                                      ?.homeData
                                      .karaokeEvent[index]
                                      .eventSdate ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    color: gradient.defoultColor,
                                    fontSize: 14,
                                    overflow:
                                    TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: Get.size.width * 0.48,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/Location.png",
                                        color: gradient.defoultColor,
                                        height: 15,
                                        width: 15,
                                      ),
                                      Expanded(  // This will make sure the text takes remaining space and doesn't overflow
                                        child: Text(
                                          homePageController.homeInfo1?.homeData.karaokeEvent[index].eventPlaceName ?? "",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            fontSize: 14,
                                            color: BlackColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            )
                : SizedBox(),
          ],
        );
      }),
    );
  }
}
