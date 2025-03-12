// ignore_for_file: sort_child_properties_last, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/controller/eventdetails_controller.dart';
import 'package:jjcentre/controller/home_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/utils/Colors.dart';

import '../../controller/eventdetails_controller1.dart';

class LatestEvent extends StatefulWidget {
  String? eventStaus;
  LatestEvent({super.key, this.eventStaus});

  @override
  State<LatestEvent> createState() => _LatestEventState();
}

class _LatestEventState extends State<LatestEvent> {
  HomePageController homePageController = Get.find();
  EventDetailsController1 eventDetailsController = Get.find();
  @override
  Widget build(BuildContext context) {
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
              ? "Latest Event".tr
              : widget.eventStaus == "2"
                  ? "Monthly Event".tr
                  : widget.eventStaus == "3"
                      ? "Nearby Event".tr
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
                          .homeInfo?.homeData.latestEvent.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            await eventDetailsController.getEventData(
                              eventId: homePageController.homeInfo?.homeData
                                  .latestEvent[index].eventId,
                            );
                            Get.toNamed(
                              Routes.eventDetailsScreen1,
                              arguments: {
                                "eventId": homePageController.homeInfo?.homeData
                                    .latestEvent[index].eventId,
                                "bookStatus": "1",
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
                                      placeholder: "assets/ezgif.com-crop.gif",
                                      height: 140,
                                      image:
                                          "${Config.imageUrl}${homePageController.homeInfo?.homeData.latestEvent[index].eventImg ?? ""}",
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        homePageController
                                                .homeInfo
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
                                                .homeInfo
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
                                                      .homeInfo
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
                : widget.eventStaus == "2"
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: homePageController
                              .homeInfo?.homeData.thisMonthEvent.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                await eventDetailsController.getEventData(
                                  eventId: homePageController.homeInfo?.homeData
                                      .thisMonthEvent[index].eventId,
                                );
                                Get.toNamed(
                                  Routes.eventDetailsScreen1,
                                  arguments: {
                                    "eventId": homePageController
                                        .homeInfo
                                        ?.homeData
                                        .thisMonthEvent[index]
                                        .eventId,
                                    "bookStatus": "1",
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
                                              "${Config.imageUrl}${homePageController.homeInfo?.homeData.thisMonthEvent[index].eventImg ?? ""}",
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
                                                    .homeInfo
                                                    ?.homeData
                                                    .thisMonthEvent[index]
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
                                                    .homeInfo
                                                    ?.homeData
                                                    .thisMonthEvent[index]
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
                                                          .homeInfo
                                                          ?.homeData
                                                          .thisMonthEvent[index]
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
                              itemCount: homePageController
                                  .homeInfo?.homeData.nearbyEvent.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    await eventDetailsController.getEventData(
                                      eventId: homePageController.homeInfo
                                          ?.homeData.nearbyEvent[index].eventId,
                                    );
                                    Get.toNamed(
                                      Routes.eventDetailsScreenOther,
                                      arguments: {
                                        "eventId": homePageController
                                            .homeInfo
                                            ?.homeData
                                            .nearbyEvent[index]
                                            .eventId,
                                        "bookStatus": "1",
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
                                                  "${Config.imageUrl}${homePageController.homeInfo?.homeData.nearbyEvent[index].eventImg ?? ""}",
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
                                                        .homeInfo
                                                        ?.homeData
                                                        .nearbyEvent[index]
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
                                                        .homeInfo
                                                        ?.homeData
                                                        .nearbyEvent[index]
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
                                                        homePageController.homeInfo?.homeData.nearbyEvent[index].eventPlaceName ?? "",
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
