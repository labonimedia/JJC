// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, deprecated_member_use, must_be_immutable, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:async';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/controller/eventdetails_controller.dart';
import 'package:jjcentre/controller/org_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/myclubscreen.dart';
import 'package:jjcentre/screen/organizer%20details/organizer_Information.dart';
import 'package:jjcentre/screen/organizer%20details/userdetails_screen.dart';
import 'package:jjcentre/screen/seeAll/gallery_view.dart';
import 'package:jjcentre/screen/seeAll/video_view.dart';
import 'package:jjcentre/screen/sponsor_gallery_details.dart';
import 'package:jjcentre/screen/videopreview_screen.dart';
import 'package:jjcentre/screen/view_sponser.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Api/data_store.dart';
import '../model/event_info.dart';
import 'LoginAndSignup/login_screen.dart';
import 'clubmember_registration.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with TickerProviderStateMixin {
  EventDetailsController eventDetailsController = Get.find();
  OrgController orgController = Get.find();
  late TabController _tabController, _tabController1;
  String eventId = Get.arguments["eventId"];
  String maxmember = Get.arguments["maxmember"];
  String maxguest = Get.arguments["maxguest"];
  String bookStatus = Get.arguments["bookStatus"];
  bool _isLoggin = false;
  bool isVisible = true;

  late GoogleMapController
      mapController; //contrller for Google map //markers for google map
  LatLng showLocation = LatLng(27.7089427, 85.3086209);

  final List<Marker> _markers = <Marker>[];

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadData() async {
    final Uint8List markIcons = await getImages("assets/MapPin.png", 50);
    // makers added according to index
    _markers.add(
      Marker(
        // given marker id
        markerId: MarkerId(showLocation.toString()),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(markIcons),
        // given position
        position: LatLng(
          double.parse(
              eventDetailsController.eventInfo?.eventData.eventLatitude ?? ""),
          double.parse(
              eventDetailsController.eventInfo?.eventData.eventLongtitude ??
                  ""),
        ),
        infoWindow: InfoWindow(),
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // loadData();
    List<String> eventDates = eventDetailsController
            .eventInfo?.plannerData?.events.values
            .map((event) => event.eventDate)
            .toList() ??
        [];

    _tabController = TabController(length: eventDates.length, vsync: this);
    _tabController1 = TabController(length: eventDates.length, vsync: this);
    if (getData.read("UserLogin") != null) {
      _isLoggin = true;
    } else {
      _isLoggin = false;
    }

    // Assuming 3 dates, adjust as needed
  }

  String formatDate(String dateString) {
    // Define the input format of your date string
    DateTime parsedDate = DateTime.parse(
        dateString); // or use DateFormat if not in ISO 8601 format

    // Define the output format
    DateFormat outputFormat = DateFormat('dd-MM-yyyy');

    // Return the formatted date string
    return outputFormat.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    List<String> eventDates = eventDetailsController
            .eventInfo?.plannerData?.events.values
            .map((event) => event.eventDate)
            .toList() ??
        [];
    List<String> eventNames = eventDetailsController
            .eventInfo?.plannerData?.events.values
            .map((event) => event.eventName)
            .toList() ??
        [];

    final foodStalls = eventDetailsController.eventInfo?.eventRestriction
        .where((restriction) => restriction.restriction_category == 'foodStall')
        .toList();
    final creativeStalls = eventDetailsController.eventInfo?.eventRestriction
        .where((restriction) =>
            restriction.restriction_category == 'creativeBazar')
        .toList();
    final funZoneStalls = eventDetailsController.eventInfo?.eventRestriction
        .where((restriction) => restriction.restriction_category == 'funZone')
        .toList();

    return Scaffold(
      backgroundColor: WhiteColor,
      bottomNavigationBar: GetBuilder<EventDetailsController>(
        builder: (context) {
          return bookStatus == "1"
              ? eventDetailsController.eventInfo?.eventData.totalBookTicket !=
                      eventDetailsController.eventInfo?.eventData.totalTicket
                  ? GestButton(
                      height: 50,
                      Width: Get.size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      buttoncolor: gradient.defoultColor,
                      buttontext: "Book Now".tr,
                      style: TextStyle(
                        color: WhiteColor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 15,
                      ),
                      onclick: () {
                        eventDetailsController.getEventTicket(eventId: eventId);
                        Get.toNamed(Routes.tikitDetailsScreen);
                      },
                    )
                  : SizedBox()
              : SizedBox();
        },
      ),
      body: GetBuilder<EventDetailsController>(builder: (context) {
        return eventDetailsController?.isLoading ?? false
            ? CustomScrollView(
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
                    /*actions: [
                      bookStatus == "1"
                          ? eventDetailsController
                                      .eventInfo?.eventData.isBookmark !=
                                  1
                              ? InkWell(
                                  onTap: () {
                                    eventDetailsController.getFavAndUnFav(
                                        eventID: eventId);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(7),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/Love.png",
                                      color: WhiteColor,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF000000).withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    eventDetailsController.getFavAndUnFav(
                                        eventID: eventId);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(9),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/Fev-Bold.png",
                                      color: gradient.defoultColor,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF000000).withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                          : SizedBox(),
                      SizedBox(
                        width: 8,
                      ),
                    ],*/
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
                              items: eventDetailsController
                                          .eventInfo?.eventData.eventCoverImg !=
                                      []
                                  ? eventDetailsController
                                      .eventInfo?.eventData.eventCoverImg
                                      .map<Widget>((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: Get.size.width,
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/ezgif.com-crop.gif",
                                                fit: BoxFit.fill,
                                                image: Config.imageUrl + i),
                                          );
                                        },
                                      );
                                    }).toList()
                                  : [].map<Widget>((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: 100,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 1),
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            child: Image.network(
                                              Config.imageUrl + i,
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                              // ),
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
                              color: WhiteColor,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Welcome to",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 14,
                                    color: BlackColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          eventDetailsController.eventInfo
                                                  ?.eventData.sponsoreName ??
                                              "",
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 18,
                                            color: BlackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              /*Container(
                                height: 50,
                                width: Get.size.width,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.all(12),
                                      child: Image.asset(
                                        "assets/Calendar.png",
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
                                          Text(
                                            eventDetailsController.eventInfo
                                                    ?.eventData.eventSdate ??
                                                "",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: BlackColor,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            eventDetailsController.eventInfo
                                                    ?.eventData.eventTimeDay ??
                                                "",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily.gilroyMedium,
                                              color: greytext,
                                              fontSize: 13,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),*/
                              /*Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                                  child:Text(
                                    "How to Reach".tr,
                                    style: TextStyle(
                                      fontFamily:
                                      FontFamily.gilroyBold,
                                      color: BlackColor,
                                      fontSize: 14,
                                    ),
                                  ),
                              ),*/

                              Container(
                                height: 100,
                                width: Get.size.width,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /* Container(
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
                                    ),*/

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Center(
                                                child: Text(
                                                  "Venue Address".tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Center(
                                              child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 40, right: 40),
                                            child: Text(
                                              eventDetailsController
                                                      .eventInfo
                                                      ?.eventData
                                                      .eventAddress ??
                                                  "",
                                              maxLines: 4,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                color: BlackColor,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Center(
                                      child: Text(
                                        "How to Reach".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
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
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage('assets/mapIcons.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              /* Container(
                                height: 50,
                                width: Get.size.width,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.all(12),
                                      child: Image.asset(
                                        "assets/ticketIcon.png",
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
                                          Text(
                                            "${eventDetailsController.eventInfo?.eventData.ticketPrice ?? ""}",
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: BlackColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "Ticket price ".tr,
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily.gilroyMedium,
                                              color: greytext,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${int.parse(eventDetailsController.eventInfo?.eventData.totalTicket.toString() ?? "0") - int.parse(eventDetailsController.eventInfo?.eventData.totalBookTicket.toString() ?? "0")} spots left",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: Color(0xFFFF5E4E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),*/
                              /* Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          */ /*Get.to(
                                            OrganizerInformation(
                                              orgImg: eventDetailsController
                                                      .eventInfo
                                                      ?.eventData
                                                      .sponsoreImg ??
                                                  "",
                                              orgId: eventDetailsController
                                                      .eventInfo
                                                      ?.eventData
                                                      .sponsoreId ??
                                                  "",
                                              orgName: eventDetailsController
                                                      .eventInfo
                                                      ?.eventData
                                                      .sponsoreName ??
                                                  "",
                                            ),
                                          );*/ /*
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              "Organized By".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                color: BlackColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        Colors.purple.shade50,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${Config.imageUrl}${eventDetailsController.eventInfo?.eventData.sponsoreImg ?? ""}"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        eventDetailsController
                                                            .eventInfo
                                                            ?.eventData
                                                            .sponsoreName ??
                                                            "",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          color: BlackColor,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      if (eventDetailsController
                                                              .eventInfo
                                                              ?.eventData
                                                              .isJoined ==
                                                          1) ...[
                                                        SizedBox(height: 2),
                                                        Text(
                                                          eventDetailsController
                                                                  .eventInfo
                                                                  ?.eventData
                                                                  .sponsoreMobile ??
                                                              "",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            color: greytext,
                                                            fontSize: 12,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // This prevents overflow
                                                        ),
                                                      ]
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),



                                      ),
                                    ),

                                    */ /*Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          orgController.getJoinDataList(
                                            eventId: eventDetailsController
                                                .eventInfo?.eventData.eventId,
                                          );
                                          Get.to(UserDetailsScreen());
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            eventDetailsController
                                                    .menberList.isNotEmpty
                                                ? Text(
                                                    "${"Attendees".tr}(${eventDetailsController.eventInfo?.eventData.totalBookTicket})",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      color: BlackColor,
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            eventDetailsController
                                                    .menberList.isNotEmpty
                                                ? Row(
                                                    children: [
                                                      ImageStack(
                                                        imageList:
                                                            eventDetailsController
                                                                .menberList,
                                                        totalCount:
                                                            eventDetailsController
                                                                .menberList
                                                                .length,
                                                        imageRadius: 25,
                                                        imageCount: 5,
                                                        imageBorderWidth: 1.5,
                                                        showTotalCount: true,
                                                        extraCountTextStyle:
                                                            TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyLight,
                                                          color: BlackColor,
                                                        ),
                                                        imageBorderColor: Colors
                                                            .purple.shade50,
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    )*/ /*
                                  ],
                                ),
                              ),*/

                              SizedBox(
                                height: 25,
                              ),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Center(
                                  child: Text(
                                    "About Puja".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 16,
                                    ),
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
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Center(
                                  child: Text(
                                    "Puja Planner".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 10, right: 15),
                                  child: Column(
                                    children: [
                                      TabBar(
                                        controller: _tabController,
                                        isScrollable: true,
                                        tabs: eventDates
                                            .map((date) =>
                                                Tab(text: formatDate(date)))
                                            .toList(),
                                      ),
                                      Container(
                                        height: Get.height * 0.3,
                                        // Adjust the height as needed
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: eventDates
                                              .map((date) =>
                                                  _buildPujaList(date: date))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              /*  SizedBox(
                                height: 8,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Disclaimer".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 14,
                                    color: BlackColor,
                                  ),
                                ),
                              ),*/
                              /*Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, right: 15),
                                child: HtmlWidget(
                                  eventDetailsController.eventInfo?.eventData
                                          .eventDisclaimer ??
                                      "",
                                  textStyle: TextStyle(
                                    color: BlackColor,
                                    fontSize: 12,
                                    // fontSize: Get.height / 50,
                                    fontFamily: 'Gilroy Normal',
                                  ),
                                ),
                              ),*/

                              SizedBox(
                                height: 8,
                              ),
                              /*Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Center(
                            child: Text(
                              "Bhog Booking".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                color: Colors.deepPurpleAccent,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, right: 15),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _tabController1,
                                  isScrollable: true,
                                  tabs: eventNames
                                      .map((date) => Tab(text: date))
                                      .toList(),
                                ),
                                Container(
                                  height: Get.height * 0.15,
                                  // Adjust the height as needed
                                  child: TabBarView(
                                    controller: _tabController1,
                                    children: eventDates
                                        .map((date) =>
                                    //_buildPujaList(date: date))
                                    _buildDetailRowWithButton(
                                        date: date))
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),*/
                              SizedBox(
                                height: 10,
                              ),
                            /*  eventDetailsController
                                      .eventInfo!.eventArtist.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        "Artist".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventArtist.isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventArtist.isNotEmpty
                                  ? SizedBox(
                                      height: 80,
                                      width: Get.size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: ListView.builder(
                                          itemCount: eventDetailsController
                                              .eventInfo?.eventArtist.length,
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return SizedBox(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFe9f0ff),
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${Config.imageUrl}${eventDetailsController.eventInfo?.eventArtist[index].artistImg}"),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 5,
                                                    right: 5,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            eventDetailsController
                                                                    .eventInfo
                                                                    ?.eventArtist[
                                                                        index]
                                                                    .artistTitle ??
                                                                "",
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              fontSize: 10,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: WhiteColor,
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: gradient
                                                                .defoultColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          eventDetailsController
                                                                  .eventInfo
                                                                  ?.eventArtist[
                                                                      index]
                                                                  .artistRole ??
                                                              "",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            fontSize: 10,
                                                            color: greytext,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox(),*/
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              eventDetailsController
                                      .eventInfo!.eventFacility.isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventFacility.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Center(
                                        child: Text(
                                          "Facility".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 16,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventFacility.isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventFacility.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: eventDetailsController
                                            .eventInfo?.eventFacility.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                mainAxisExtent: 115),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                alignment: Alignment.center,
                                                child: Image.network(
                                                  "${Config.imageUrl}${eventDetailsController.eventInfo?.eventFacility[index].facilityImg}",
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                eventDetailsController
                                                        .eventInfo
                                                        ?.eventFacility[index]
                                                        .facilityTitle ??
                                                    "",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyMedium,
                                                  fontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: BlackColor,
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                              Divider(
                                color: Colors.black, // Line color
                                thickness: 1, // Line thickness
                                indent: 10, // Left spacing
                                endIndent: 10, // Right spacing
                              ),
                              eventDetailsController
                                      .eventInfo!.eventRestriction.isNotEmpty
                                  ? SizedBox(
                                      height: 15,
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventRestriction.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Center(
                                        child: Text(
                                          "Stalls at the Venue".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 16,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 15,
                              ),
                              if (foodStalls != null &&
                                  foodStalls.isNotEmpty) ...[
                                // Show "Fun Zone" only if there are Fun Zone stalls available
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Center(
                                    child: Text(
                                      "Food Stalls".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 14,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),
                                SizedBox(
                                  height: 180,
                                  width: Get.size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Center(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: eventDetailsController
                                                .eventInfo?.eventRestriction
                                                ?.where((restriction) =>
                                                    restriction
                                                        .restriction_category ==
                                                    'foodStall')
                                                .length ??
                                            0,
                                        //physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 150, // Set the height of each item in the grid
                                    ),*/
                                        itemBuilder: (context, index) {
                                          final restriction =
                                              eventDetailsController
                                                  .eventInfo?.eventRestriction
                                                  ?.where((restriction) =>
                                                      restriction
                                                          .restriction_category ==
                                                      'foodStall')
                                                  .toList()[index];

                                          if (restriction != null) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              // Center the content vertically
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              // Center the content horizontally
                                              children: [
                                                Container(
                                                  height: 160,
                                                  width: 160,
                                                  alignment: Alignment.center,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print('Image tapped!');
                                                      Get.toNamed(
                                                        Routes
                                                            .stallDetailScreen,
                                                        arguments: {
                                                          "eventName": restriction.restrictionTitle,
                                                          "stallId": restriction.restrictionId,
                                                          "category": restriction.restriction_category,
                                                          "image": "${Config.imageUrl}${restriction.restrictionImg}",
                                                        },
                                                      );
                                                    },
                                                    child: Image.network(
                                                      "${Config.imageUrl}${restriction.restrictionImg}",
                                                      height: 150,
                                                      width: 150,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  restriction.restrictionTitle ?? "",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: BlackColor,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox(); // Fallback for null restrictions
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              SizedBox(
                                height: 5,
                              ),
                              if (creativeStalls != null &&
                                  creativeStalls.isNotEmpty) ...[
                                // Show "Fun Zone" only if there are Fun Zone stalls available
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Center(
                                      child: Text(
                                        "Creative Stalls".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                    )),

                                SizedBox(
                                  height: 180,
                                  width: Get.size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Center(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: eventDetailsController
                                                .eventInfo?.eventRestriction
                                                .where((restriction) =>
                                                    restriction
                                                        .restriction_category ==
                                                    'creativeBazar')
                                                .length ??
                                            0,
                                        //physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        /*gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisExtent: 85,
                                  ),*/
                                        itemBuilder: (context, index) {
                                          final restriction =
                                              eventDetailsController
                                                  .eventInfo?.eventRestriction
                                                  .where((restriction) =>
                                                      restriction
                                                          .restriction_category ==
                                                      'creativeBazar')
                                                  .toList()[index];

                                          if (restriction != null) {
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 160,
                                                  width: 160,
                                                  alignment: Alignment.center,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print('Image tapped!');
                                                      Get.toNamed(
                                                        Routes
                                                            .stallDetailScreen,
                                                        arguments: {
                                                          "eventName": restriction
                                                              .restrictionTitle,
                                                          "stallId": restriction
                                                              .restrictionId,
                                                          "category": restriction
                                                              .restriction_category,
                                                          "image":
                                                              "${Config.imageUrl}${restriction.restrictionImg}",
                                                        },
                                                      );
                                                    },
                                                    child: Image.network(
                                                      "${Config.imageUrl}${restriction.restrictionImg}",
                                                      height: 150,
                                                      width: 150,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 0),
                                                Text(
                                                  restriction
                                                          .restrictionTitle ??
                                                      "",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: BlackColor,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox(); // Fallback for null restrictions
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              SizedBox(
                                height: 5,
                              ),
                              if (funZoneStalls != null &&
                                  funZoneStalls.isNotEmpty) ...[
                                // Show "Fun Zone" only if there are Fun Zone stalls available
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Center(
                                    child: Text(
                                      "Fun Zone".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 14,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 0),
                                SizedBox(
                                  height: 180,
                                  width: Get.size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Center(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: eventDetailsController
                                                .eventInfo?.eventRestriction
                                                .where((restriction) =>
                                                    restriction
                                                        .restriction_category ==
                                                    'funZone')
                                                .length ??
                                            0,
                                        //physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        /*gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisExtent: 85,
                                  ),*/
                                        itemBuilder: (context, index) {
                                          final restriction =
                                              eventDetailsController
                                                  .eventInfo?.eventRestriction
                                                  .where((restriction) =>
                                                      restriction
                                                          .restriction_category ==
                                                      'funZone')
                                                  .toList()[index];

                                          if (restriction != null) {
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 160,
                                                  width: 160,
                                                  alignment: Alignment.center,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print('Image tapped!');
                                                      Get.toNamed(
                                                        Routes
                                                            .stallDetailScreen,
                                                        arguments: {
                                                          "eventName": restriction
                                                              .restrictionTitle,
                                                          "stallId": restriction
                                                              .restrictionId,
                                                          "category": restriction
                                                              .restriction_category,
                                                          "image":
                                                          "${Config.imageUrl}${restriction.restrictionImg}",
                                                        },
                                                      );
                                                    },
                                                    child: Image.network(
                                                      "${Config.imageUrl}${restriction.restrictionImg}",
                                                      height: 150,
                                                      width: 150,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 0),
                                                Text(
                                                  restriction
                                                          .restrictionTitle ??
                                                      "",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: BlackColor,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox(); // Fallback for null restrictions
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: _isLoggin,
                                child: Divider(
                                  color: Colors.black, // Line color
                                  thickness: 1, // Line thickness
                                  indent: 10, // Left spacing
                                  endIndent: 10, // Right spacing
                                ),
                              ),
                              Visibility(
                                visible: _isLoggin,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Center(
                                    child: Text(
                                      "Puja Sponsor".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 16,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isLoggin,
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Handle the click event here

                                      Get.toNamed(
                                        Routes.sponserDetailsScreen,
                                        arguments: {
                                          "eventId": eventId,
                                        },
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        "View Sponsor".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              eventDetailsController
                                      .eventInfo!.eventGallery.isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                      child: Divider(
                                        color: Colors.black, // Line color
                                        thickness: 1, // Line thickness
                                        indent: 10, // Left spacing
                                        endIndent: 10, // Right spacing
                                      ),
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventGallery.isNotEmpty
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Spacer(),
                                        Center(
                                          child: Text(
                                            "Gallery".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        /* TextButton(
                              onPressed: () {
                                Get.to(GalleryView());
                              },
                              child: Text(
                                "See All".tr,
                                style: TextStyle(
                                  fontFamily:
                                  FontFamily.gilroyMedium,
                                  color: Color(0xFF6F3DE9),
                                ),
                              ),
                            ),*/
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              eventDetailsController
                                      .eventInfo!.eventGallery.isNotEmpty
                                  ? SizedBox(
                                      height: 150,
                                      width: Get.size.width,
                                      child: ListView.builder(
                                        itemCount: eventDetailsController
                                            .eventInfo?.eventGallery.length,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(
                                                FullScreenImage(
                                                  imageUrl:
                                                      "${Config.imageUrl}${eventDetailsController.eventInfo!.eventGallery[index]}",
                                                  tag: "generate_a_unique_tag",
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 150,
                                              width: 150,
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 8, bottom: 8),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "assets/ezgif.com-crop.gif",
                                                  placeholderFit: BoxFit.cover,
                                                  image:
                                                      "${Config.imageUrl}${eventDetailsController.eventInfo?.eventGallery[index] ?? ""}",
                                                  height: 150,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                                                  ), //BoxShadow
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset:
                                                        const Offset(0.0, 0.0),
                                                    blurRadius: 0.0,
                                                    spreadRadius: 0.0,
                                                  ), //BoxShadow
                                                ],
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
                              eventDetailsController.eventInfo
                                              ?.spacialAttraction?.details !=
                                          null &&
                                      eventDetailsController
                                          .eventInfo!
                                          .spacialAttraction!
                                          .details!
                                          .isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                      child: Divider(
                                        color: Colors.black, // Line color
                                        thickness: 1, // Line thickness
                                        indent: 10, // Left spacing
                                        endIndent: 10, // Right spacing
                                      ),
                                    )
                                  : SizedBox(),
                              eventDetailsController.eventInfo
                                              ?.spacialAttraction?.details !=
                                          null &&
                                      eventDetailsController
                                          .eventInfo!
                                          .spacialAttraction!
                                          .details!
                                          .isNotEmpty
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Spacer(),
                                        Center(
                                          child: Text(
                                            "Special Attraction".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              eventDetailsController.eventInfo
                                              ?.spacialAttraction?.details !=
                                          null &&
                                      eventDetailsController
                                          .eventInfo!
                                          .spacialAttraction!
                                          .details!
                                          .isNotEmpty
                                  ? SizedBox(
                                      height:
                                          384, // Adjust based on the desired height
                                      width: Get.size.width,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: eventDetailsController
                                            .eventInfo
                                            ?.spacialAttraction
                                            ?.details
                                            ?.length,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return Center(
                                            child: InkWell(
                                              onTap: () {
                                                // Action to be performed on click
                                                //print('Play icon clicked!');
                                                if (eventDetailsController
                                                        .eventInfo
                                                        ?.spacialAttraction!
                                                        .details?[index]
                                                        .path !=
                                                    "") {
                                                  Get.to(VideoPreviewScreen(
                                                    url: eventDetailsController
                                                        .eventInfo
                                                        ?.spacialAttraction!
                                                        .details?[index]
                                                        .path,
                                                  ));
                                                } else {}
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                elevation: 4.0,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    // Image at the top
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      12.0)),
                                                      child: Image.network(
                                                        '${Config.imageUrl}${eventDetailsController.eventInfo?.spacialAttraction!.details?[index].img ?? ""}',
                                                        width: 260,
                                                        height: 150.0,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          // Play Icon with Event Title
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              /* InkWell(
                                                                onTap: () {
                                                                  // Action to be performed on click
                                                                  //print('Play icon clicked!');
                                                                  if(eventDetailsController.eventInfo?.spacialAttraction!.details?[index].path != null) {
                                                                    Get.to(
                                                                        VideoPreviewScreen(
                                                                          url: eventDetailsController
                                                                              .eventInfo
                                                                              ?.spacialAttraction!
                                                                              .details?[index]
                                                                              .path,
                                                                        ));
                                                                  }else{

                                                                  }
                                                                },
                                                                child:Image.asset(
                                                                  'assets/video_icon.png', // Path to your asset icon
                                                                  width: 48.0,  // Adjust size as per your need
                                                                  height: 48.0,
                                                                  // Optional: Apply color if needed
                                                                ),
                                                              ),*/

                                                              SizedBox(
                                                                  width: 8.0),
                                                              SizedBox(
                                                                height: 50,
                                                                width: 200,
                                                                child: Text(
                                                                  eventDetailsController
                                                                          .eventInfo
                                                                          ?.spacialAttraction!
                                                                          .details?[
                                                                              index]
                                                                          .title ??
                                                                      "",
                                                                  // Replace with dynamic event title
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Avoid text overflow
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8.0),

                                                          // Date and Time
                                                          Text(
                                                            (eventDetailsController
                                                                        .eventInfo
                                                                        ?.spacialAttraction
                                                                        ?.details?[
                                                                            index]
                                                                        .date ??
                                                                    "") +
                                                                " | " +
                                                                (eventDetailsController
                                                                        .eventInfo
                                                                        ?.spacialAttraction
                                                                        ?.details?[
                                                                            index]
                                                                        .time ??
                                                                    ""),

                                                            // Replace with dynamic date and time
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8.0),

                                                          // Event description
                                                          SizedBox(
                                                            height: 78,
                                                            width: 200,
                                                            // You can specify any height
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Text(
                                                                eventDetailsController
                                                                        .eventInfo
                                                                        ?.spacialAttraction!
                                                                        .details?[
                                                                            index]
                                                                        .description ??
                                                                    "",

                                                                // Replace with dynamic description
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,

                                                                // Limit the number of lines
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis, // Avoid overflow
                                                              ),
                                                            ),
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
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),




                              eventDetailsController.eventInfo
                                  ?.sponsorGallery?.details !=
                                  null &&
                                  eventDetailsController
                                      .eventInfo!
                                      .sponsorGallery!
                                      .details!
                                      .isNotEmpty
                                  ? SizedBox(
                                height: 10,
                                child: Divider(
                                  color: Colors.black, // Line color
                                  thickness: 1, // Line thickness
                                  indent: 10, // Left spacing
                                  endIndent: 10, // Right spacing
                                ),
                              )
                                  : SizedBox(),
                              eventDetailsController.eventInfo
                                  ?.sponsorGallery?.details !=
                                  null &&
                                  eventDetailsController
                                      .eventInfo!
                                      .sponsorGallery!
                                      .details!
                                      .isNotEmpty
                                  ? Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Spacer(),
                                  Center(
                                    child: Text(
                                      "Souvenir Sponsor".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: Colors.deepPurpleAccent,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              eventDetailsController.eventInfo
                                  ?.sponsorGallery?.details !=
                                  null &&
                                  eventDetailsController
                                      .eventInfo!
                                      .sponsorGallery!
                                      .details!
                                      .isNotEmpty
                                  ? SizedBox(
                                height:
                                384, // Adjust based on the desired height
                                width: Get.size.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: eventDetailsController
                                      .eventInfo
                                      ?.sponsorGallery
                                      ?.details
                                      ?.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final sponsor = eventDetailsController.eventInfo?.sponsorGallery?.details?.toList()[index];

                                    return Center(
                                      child: InkWell(
                                        onTap: () {
                                          print("title${Config.imageUrl}${eventDetailsController.eventInfo?.sponsorGallery!.details?[index].img ?? ""}");
                                        /*  Get.toNamed(
                                            Routes.sponserGalleryDetailScreen,
                                            arguments: {
                                              "title":sponsor?.title,
                                              "description":sponsor?.description,
                                              "image": sponsor?.img,
                                            },
                                          );*/

                                          Get.to(SponsorGalleryDetailScreen(
                                            title: sponsor?.title,
                                            description: sponsor?.description,
                                            image: "${Config.imageUrl}${eventDetailsController.eventInfo?.sponsorGallery!.details?[index].img ?? ""}",
                                          ));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                12.0),
                                          ),
                                          elevation: 4.0,
                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              // Image at the top
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                    top: Radius
                                                        .circular(
                                                        12.0)),
                                                child: Image.network(
                                                  '${Config.imageUrl}${eventDetailsController.eventInfo?.sponsorGallery!.details?[index].img ?? ""}',
                                                  width: 260,
                                                  height: 150.0,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    16.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    // Play Icon with Event Title
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [


                                                        SizedBox(
                                                            width: 8.0),
                                                        SizedBox(
                                                          height: 50,
                                                          width: 200,
                                                          child: Text(
                                                            eventDetailsController
                                                                .eventInfo
                                                                ?.sponsorGallery
                                                                !.details?[index].title ??
                                                                "",
                                                            // Replace with dynamic event title
                                                            style:
                                                            TextStyle(
                                                              fontSize:
                                                              18.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis, // Avoid text overflow
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.0),

                                                    // Date and Time

                                                    SizedBox(height: 8.0),

                                                    // Event description
                                                    SizedBox(
                                                      height: 78,
                                                      width: 200,
                                                      // You can specify any height
                                                      child:
                                                      SingleChildScrollView(
                                                        child: Text(
                                                          eventDetailsController
                                                              .eventInfo
                                                              ?.sponsorGallery
                                                              !.details?[
                                                          index]
                                                              .description ??
                                                              "",

                                                          // Replace with dynamic description
                                                          style:
                                                          TextStyle(
                                                            fontSize:
                                                            14.0,
                                                            color: Colors
                                                                .grey[
                                                            600],
                                                          ),
                                                          textAlign:
                                                          TextAlign
                                                              .center,

                                                          // Limit the number of lines
                                                          maxLines: 5,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis, // Avoid overflow
                                                        ),
                                                      ),
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
                              )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),


                              /*  Divider(
                          color: Colors.black, // Line color
                          thickness: 1, // Line thickness
                          indent: 10, // Left spacing
                          endIndent: 10, // Right spacing
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        GestButton(
                          Width: Get.size.width,
                          height: 50,
                          buttoncolor: gradient.defoultColor,
                          margin: EdgeInsets.only(
                              top: 15, left: 30, right: 30),
                          buttontext: "New Member Registration".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: WhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          onclick: () {
                            Get.to(ClubMemberRegistrationScreen());
                          },
                        ),*/

                              eventDetailsController.eventInfo!.eventData
                                      .eventVideoUrls.isNotEmpty
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Video".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            color: BlackColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(VideoViewScreen());
                                          },
                                          child: Text(
                                            "See All".tr,
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily.gilroyMedium,
                                              color: Color(0xFF6F3DE9),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              eventDetailsController.eventInfo!.eventData
                                      .eventVideoUrls.isNotEmpty
                                  ? Container(
                                      height: 100,
                                      width: Get.size.width,
                                      child: ListView.builder(
                                        itemCount: eventDetailsController
                                            .eventInfo
                                            ?.eventData
                                            .eventVideoUrls
                                            .length,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return eventDetailsController
                                                      .eventInfo
                                                      ?.eventData
                                                      .eventVideoUrls[index] !=
                                                  "null"
                                              ? InkWell(
                                                  onTap: () {
                                                    Get.to(VideoPreviewScreen(
                                                      url: eventDetailsController
                                                                  .eventInfo
                                                                  ?.eventData
                                                                  .eventVideoUrls[
                                                              index] ??
                                                          "",
                                                    ));
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 100,
                                                        width: 100,
                                                        margin: EdgeInsets.only(
                                                            left: 8,
                                                            right: 8,
                                                            bottom: 8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder:
                                                                "assets/ezgif.com-crop.gif",
                                                            placeholderCacheHeight:
                                                                100,
                                                            placeholderCacheWidth:
                                                                100,
                                                            placeholderFit:
                                                                BoxFit.cover,
                                                            image: YoutubePlayer
                                                                .getThumbnail(
                                                              videoId: YoutubePlayer.convertUrlToId(
                                                                  eventDetailsController
                                                                          .eventInfo
                                                                          ?.eventData
                                                                          .eventVideoUrls[index] ??
                                                                      "")!,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              offset:
                                                                  const Offset(
                                                                0.5,
                                                                0.5,
                                                              ),
                                                              blurRadius: 0.5,
                                                              spreadRadius: 0.5,
                                                            ), //BoxShadow
                                                            BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                              offset:
                                                                  const Offset(
                                                                      0.0, 0.0),
                                                              blurRadius: 0.0,
                                                              spreadRadius: 0.0,
                                                            ), //BoxShadow
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 35,
                                                        left: 35,
                                                        right: 35,
                                                        bottom: 35,
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
                              bookStatus == "2"
                                  ? eventDetailsController
                                          .eventInfo!.reviewdata.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            "Review".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: BlackColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                              bookStatus == "2"
                                  ? eventDetailsController
                                          .eventInfo!.reviewdata.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: eventDetailsController
                                              .eventInfo?.reviewdata.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                top: index == 0 ? 3 : 5,
                                                left: 8,
                                                right: 8,
                                                bottom: 8,
                                              ),
                                              child: ListTile(
                                                leading: Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          "assets/ezgif.com-crop.gif",
                                                      height: 50,
                                                      width: 50,
                                                      image:
                                                          "${Config.imageUrl}${eventDetailsController.eventInfo?.reviewdata[index].userImg ?? ""}",
                                                      placeholderFit:
                                                          BoxFit.cover,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                title: Text(
                                                  eventDetailsController
                                                          .eventInfo
                                                          ?.reviewdata[index]
                                                          .customername ??
                                                      "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    color: BlackColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "${eventDetailsController.eventInfo?.reviewdata[index].rateText ?? ""}",
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    color: greytext,
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                  ),
                                                ),
                                                trailing: Container(
                                                  height: 40,
                                                  width: 70,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: gradient
                                                            .defoultColor,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${eventDetailsController.eventInfo?.reviewdata[index].rateNumber ?? ""}",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyBold,
                                                          color: gradient
                                                              .defoultColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          gradient.defoultColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: WhiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            );
                                          },
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              /* Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Maps".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    color: BlackColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),*/
                              /* Container(
                                height: 130,
                                width: Get.size.width,
                                margin: EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          double.parse(eventDetailsController
                                                  .eventInfo
                                                  ?.eventData
                                                  .eventLatitude ??
                                              "0"),
                                          double.parse(eventDetailsController
                                                  .eventInfo
                                                  ?.eventData
                                                  .eventLongtitude ??
                                              "0")), //initial position
                                      zoom: 10.0, //initial zoom level
                                    ),
                                    markers: Set<Marker>.of(_markers),
                                    mapType: MapType.normal,
                                    myLocationEnabled: true,
                                    compassEnabled: true,
                                    zoomGesturesEnabled: true,
                                    tiltGesturesEnabled: true,
                                    zoomControlsEnabled: true,
                                    onMapCreated: (controller) {
                                      setState(() {
                                        mapController = controller;
                                      });
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),*/
                              eventDetailsController
                                      .eventInfo!.eventData.eventTags.isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventData.eventTags.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Tags".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          color: BlackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventData.eventTags.isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : SizedBox(),
                              eventDetailsController
                                      .eventInfo!.eventData.eventTags.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Wrap(
                                        spacing: 5.0,
                                        runSpacing: 0,
                                        children: List<Widget>.generate(
                                            eventDetailsController
                                                .eventInfo!
                                                .eventData
                                                .eventTags
                                                .length, (int index) {
                                          return InkWell(
                                            onTap: () {},
                                            child: Chip(
                                              padding: EdgeInsets.zero,
                                              labelPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              backgroundColor: gradient
                                                  .defoultColor
                                                  .withOpacity(0.9),
                                              label: Text(
                                                eventDetailsController
                                                    .eventInfo!
                                                    .eventData
                                                    .eventTags[index],
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 12,
                                                  color: WhiteColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  /* Widget _buildPujaList({required String date}) {

    List<Map<String, dynamic>> eventDetailsList = eventDetailsController
        .eventInfo?.plannerData.events.values.map((event) {
      return {
        "eventDate": event.eventDate,
        "eventName": event.eventName,
        "details": event.details, // This will be a List<EventDetail>
      };
    }).toList() ?? [];
    late List<EventDetail> details;

    for (var eventDetail in eventDetailsList) {
      print("Event Date: ${eventDetail['eventDate']}");
      print("Event Name: ${eventDetail['eventName']}");
      Text(
        eventDetail['eventName'],
        style: TextStyle(fontWeight: FontWeight.bold),
      );
      // Loop through event details if needed
      details = eventDetail['details'];
      for (var detail in details) {
        print("Detail Description: ${detail.description}");
        print("Event Time: ${detail.eTime}");
      }
    }

   */ /* List<Map<String, dynamic>> pujaList = [
      {
        'pujaName': 'Puja 1',
        'events': ['Event 1', 'Event 2', 'Event 3'],
        'time': ['12:23', '11:34', '9:32'],
        'isExpanded': false, // Initial state
      },
     */ /**/ /* {
        'pujaName': 'Puja 2',
        'events': ['Event 4', 'Event 5'],
        'isExpanded': false, // Initial state
      },*/ /**/ /*
    ];*/ /*

   return ListView.builder(
      shrinkWrap: true,
      itemCount: details.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildExpandablePuja(details, index);
      },
    );
  }*/

  Widget _buildExpandablePuja1(List<Map<String, dynamic>> pujaList, int index) {
    return ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          pujaList[index]['isExpanded'] = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(pujaList[index]['pujaName']),
            );
          },
          body: Column(
            children: pujaList[index]['events']
                .map<Widget>((event) => ListTile(title: Text(event)))
                .toList(),
          ),
          isExpanded: pujaList[index]['isExpanded'] ?? false,
        ),
      ],
    );
  }

  Widget _buildExpandablePuja2(List<EventDetail> pujaList, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          pujaList[index].description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Tap to expand'),
        childrenPadding: EdgeInsets.all(8.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            /*children: pujaList[index]['events']
                  .map<Widget>((event) => ListTile(title: Text(event)))
                  .toList(),*/
            children: (pujaList as List<EventDetail>)
                .map((detail) => ListTile(
                      title: Text(detail.description),
                      subtitle: Text("Time: ${detail.eTime}"),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandablePuja3(
      List<Map<String, dynamic>> eventDetailsList, int index) {
    return ListView.builder(
      itemCount: eventDetailsList.length,
      itemBuilder: (context, index) {
        var event = eventDetailsList[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ExpansionTile(
            title: Text(event["eventName"]),
            subtitle: Text(event["eventDate"]),
            children: (event["details"] as List<EventDetail>).map((detail) {
              return ListTile(
                title: Text(detail.description),
                subtitle: Text('Time: ${detail.eTime}'),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /*Widget _buildPujaList({required String date}) {
    List<Map<String, dynamic>> eventDetailsList = eventDetailsController
        .eventInfo?.plannerData.events.values.map((event) {
      return {
        "eventDate": event.eventDate,
        "eventName": event.eventName,
        "details": event.details, // This will be a List<EventDetail>
      };
    }).toList() ?? [];

    // Filter events based on the date if needed
    List<EventDetail> details = [];
    for (var eventDetail in eventDetailsList) {
      if (eventDetail['eventDate'] == date) {
        details = eventDetail['details'];
      }
    }

    if (details.isEmpty) {
      return Center(child: Text("No events found for this date."));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: details.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildExpandablePuja(details, index);
      },
    );
  }

  Widget _buildExpandablePuja(List<EventDetail> pujaList, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          pujaList[index].description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Tap to expand'),
        childrenPadding: EdgeInsets.all(8.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(pujaList[index].description),
            subtitle: Text("Time: ${pujaList[index].eTime}"),
          ),
        ],
      ),
    );
  }*/

  Widget _buildPujaList({required String date}) {
    List<Map<String, dynamic>> eventDetailsList = eventDetailsController
            .eventInfo?.plannerData?.events.values
            .where((event) => event.eventDate == date)
            .map((event) {
          return {
            "eventDate": event.eventDate,
            "eventName": event.eventName,
            "details": event.details,
            "cutural": event.cutural,
          };
        }).toList() ??
        [];

    return _buildExpandableEventList(eventDetailsList);
  }

  Widget _buildExpandableEventList(
      List<Map<String, dynamic>> eventDetailsList) {
    return ListView.builder(
      itemCount: eventDetailsList.length,
      itemBuilder: (context, index) {
        var eventDetail = eventDetailsList[index];
        var eventName = eventDetail['eventName'];
        var details = eventDetail['details'] as List<EventDetail>? ?? [];
        var cultural = eventDetail['cutural'] as List<CuturalDetail>? ?? [];

        return Card(
          shadowColor: Colors.white,
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4.0,
          // Add shadow to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  eventName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Puja Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.blue,
                      ),
                    ),
                    Text("Time",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        )),
                  ],
                ),
              ),
              // Display event details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details
                    .map((detail) => ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Wrapping the description in a Flexible widget to prevent overflow
                              Flexible(
                                child: Text(
                                  detail.description,
                                  style: TextStyle(fontSize: 14),
                                  softWrap: true,
                                  maxLines: null,
                                  overflow: TextOverflow
                                      .visible, // Adds "..." if the text overflows
                                ),
                              ),
                              SizedBox(width: 8),
                              // Optional: Adds space between the texts
                              Text(
                                "${detail.eTime}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Divider(height: 1.0, thickness: 1.0),
              // Divider between Puja and Cultural details
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cultural Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.blue,
                      ),
                    ),
                    Text("Time",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        )),
                  ],
                ),
              ),
              // Display cultural details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cultural
                    .map((culturalDetail) => ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Wrapping the description in a Flexible widget to prevent overflow
                              Flexible(
                                child: Text(
                                  culturalDetail.description,
                                  style: TextStyle(fontSize: 14),
                                  softWrap: true,
                                  maxLines: null,
                                  overflow: TextOverflow
                                      .visible, // Adds "..." if the text overflows
                                ),
                              ),
                              SizedBox(width: 8),
                              // Optional: Adds space between the texts
                              Text(
                                "${culturalDetail.eTime}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRowWithButton({required String date}) {
    //print("Date"+date);

    List<Map<String, dynamic>> eventDetailsList = eventDetailsController
            .eventInfo?.plannerData?.events.values
            .where((event) => event.eventDate == date)
            .map((event) {
          return {
            "eventDate": event.eventDate,
            "eventName": event.eventName,
            "details": event.details,
            "cutural": event.cutural,
            "bhogDetails": event.bhogDetails,
          };
        }).toList() ??
        [];
    return ListView.builder(
      itemCount: eventDetailsList.length,
      itemBuilder: (context, index) {
        var eventDetail = eventDetailsList[index];
        var eventName = eventDetail['eventName'];
        var bhogDetail = eventDetail['bhogDetails'] as List<BhogDetail>? ?? [];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bhogDetail
                .map((bhogDetails) => ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Conditional visibility of ElevatedButton based on alloption value

                              /*_isLoggin == true ?

                      ElevatedButton(
                        onPressed: () {
                          eventDetailsController.getEventTicket(eventId: eventId);
                          //Get.toNamed(Routes.tikitDetailsScreen);
                          Get.toNamed(
                            Routes.bhogBookingScreen,
                            arguments: {
                              "eventId": eventId,
                              "eventName": eventName,
                              "date": date,
                              "bhogid": bhogDetails.bhogid,
                              "alloption": bhogDetails.alloption,
                              "memberprice": bhogDetails.memberprice,
                              "guestsprice": bhogDetails.guestsprice,
                              "maxmember": maxmember,
                              "maxguest": maxguest,
                              "textname": bhogDetails.textname,
                              "eventStatus": bhogDetails.flag
                            },
                          );
                        },
                        child: Text(bhogDetails.textname + " Booking"),
                      )
                        :*/
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Bhog booking is only available for Registered member.Go to my club page for booking.'),
                                      action: SnackBarAction(
                                        label: 'My Club',
                                        onPressed: () {
                                          Get.to(() => MyClubScreen());
                                          ; // Navigate to login screen
                                        },
                                      ),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                },
                                child: Text(bhogDetails.textname + " Booking"),
                              )
                              //Get.to(() => LoginScreen());
                            ],
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
