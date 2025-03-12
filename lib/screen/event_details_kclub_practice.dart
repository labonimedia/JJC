// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, deprecated_member_use, must_be_immutable, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/controller/eventdetails_controller1.dart';
import 'package:jjcentre/controller/org_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/LoginAndSignup/login_screen.dart';
import 'package:jjcentre/screen/organizer%20details/organizer_Information.dart';
import 'package:jjcentre/screen/organizer%20details/userdetails_screen.dart';
import 'package:jjcentre/screen/seeAll/gallery_view.dart';
import 'package:jjcentre/screen/seeAll/video_view.dart';
import 'package:jjcentre/screen/videopreview_screen.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Api/data_store.dart';
import '../controller/eventdetailskclub_controller.dart';
import '../model/event_info1.dart';
import '../utils/QR.dart';
import '../utils/performer_qr.dart';
import 'LoginAndSignup/signup_screen.dart';
import 'package:http/http.dart' as http;
class EventDetailsScreenKclubPractice extends StatefulWidget {
  const EventDetailsScreenKclubPractice({super.key});

  @override
  State<EventDetailsScreenKclubPractice> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreenKclubPractice> {
  EventDetailsControllerKclub eventDetailsController = Get.find();
  //OrgController orgController = Get.find();

  String eventId = Get.arguments["eventId"];
  String bookStatus = Get.arguments["bookStatus"];
  String maxguest = Get.arguments["maxguest"];
  String maxmember = Get.arguments["maxmember"];
  late GoogleMapController
  mapController; //contrller for Google map //markers for google map
  LatLng showLocation = LatLng(27.7089427, 85.3086209);
  bool _isLoggin = false;
  final List<Marker> _markers = <Marker>[];
  KaraokeResponse? responseData;
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadData1() async {
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
            double.tryParse(eventDetailsController.eventInfo?.eventData?.eventLatitude ?? '') ?? 0.0,
            double.tryParse(eventDetailsController.eventInfo?.eventData?.eventLongtitude ?? '')?? 0.0
        ),
        infoWindow: InfoWindow(),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //loadData();

    if (getData.read("UserLogin") != null) {
      _isLoggin = true;
    } else {
      _isLoggin = false;
    }
    loadData();
  }

  loadData() async {
    try {
      final data = await getBhogDataApi();
      setState(() {
        responseData = data;

      });
    } catch (e) {
      // Handle error appropriately
      print(e.toString());
    }
  }




  String formatDate(String dateString) {
    try {
      // Define the input format that matches "23 January, 2025"
      DateFormat inputFormat = DateFormat('dd MMMM, yyyy');

      // Parse the input string to a DateTime object
      DateTime parsedDate = inputFormat.parse(dateString);

      // Define the output format
      DateFormat outputFormat = DateFormat('yyyy-MM-dd');

      // Return the formatted date string
      return outputFormat.format(parsedDate);
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing date: $e');
      return 'Invalid date format';
    }
  }
  void _showBookingConfirmation1(BuildContext context, List<String> selectedOptions, int totalPrice) {
    if (selectedOptions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No selection made!")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Booking"),
          content: Text(
            "You selected to perform : \n${selectedOptions.join(", ")}\nTotal Price: ₹$totalPrice\nProceed with booking?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Booking confirmed! Total: ₹$totalPrice")),
                // );

                Get.toNamed(
                  Routes.kclubEventPerformerPayment,
                  arguments: {
                    "amount": totalPrice.toString(),
                    //"mCount": selectedSeats.length.toString(),
                    //"gCount": guestCount.toString(),
                    //"bhogid": bhogid,
                    "edate": formatDate(eventDetailsController.eventInfo?.eventData!.eventSdate ?? ''),
                    "textname": eventDetailsController.eventInfo?.eventData?.eventTitle,
                    "eventName": eventDetailsController.eventInfo?.eventData?.eventTitle,
                    "eventId": eventId,

                    "selected_seat": selectedOptions.join(", "),
                  },
                );

              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }



  void _showBookingConfirmation(BuildContext context, String option, int price) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Booking"),
          content: Text("You have selected $option for ₹$price.\nProceed with booking?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Booking confirmed for $option")),
                );
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }


  void _showPopupMenu(Offset position, BuildContext context, List<EventType> eventTypeData) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: eventTypeData
          .map(
            (event) => PopupMenuItem(
          value: "${event.eventType} - ₹${event.eventTypePrice}",
          child: Text("${event.eventType} - ₹${event.eventTypePrice}"),
        ),
      )
          .toList(),
    );

    if (result != null) {
      // _showBookingConfirmation1(context, result);
    }
  }


  void _showMultiSelectPopup(BuildContext context, List<EventType> eventTypeData) {
    List<String> selectedValues = [];
    int totalPrice = 0; // Track total price

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Performance Type"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: eventTypeData.map((event) {
                    return CheckboxListTile(
                      title: Text("${event.eventType} - ₹${event.eventTypePrice}"),
                      value: selectedValues.contains(event.eventType),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedValues.add(event.eventType);
                            totalPrice += int.parse(event.eventTypePrice);
                          } else {
                            selectedValues.remove(event.eventType);
                            totalPrice -= int.parse(event.eventTypePrice);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures proper spacing
                    children: [
                      Text(
                        "Total: ₹$totalPrice",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,// Wrap buttons in a Row to keep them together
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context), // Close without selection
                            child: Text("Cancel"),
                          ),
                          SizedBox(width: 10), // Add spacing between buttons
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showBookingConfirmation1(context, selectedValues, totalPrice);
                            },
                            child: Text("Confirm"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

            );
          },
        );
      },
    );
  }


  Future<KaraokeResponse> getBhogDataApi() async {
    final Uri uri = Uri.parse(Config.baseurlKclub + Config.karakoeEventBookingDetails);
    final response = await http.post(
      uri,
      body: jsonEncode(
          {"uid": getData.read("UserLogin")["id"].toString(), "bid": eventId}),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print(uri.toString());
    print(response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      KaraokeResponse bhogResponse = KaraokeResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      bottomNavigationBar: GetBuilder<EventDetailsControllerKclub>(
        builder: (context) {
          return bookStatus == "0"
              ? eventDetailsController.eventInfo?.eventData?.totalBookTicket !=
              eventDetailsController.eventInfo?.eventData?.totalTicket
              ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Book Now Button
              GestButton(
                height: 50,
                Width: Get.size.width,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                buttoncolor: Colors.pinkAccent,
                buttontext: "Book Now".tr,
                style: TextStyle(
                  color: WhiteColor,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                ),
                onclick: () {
                  //print("alloption: "+eventDetailsController.eventInfo!.eventData!.alloption!);
                  eventDetailsController.getEventTicket(eventId: eventId);
                  if (_isLoggin == true) {
                    eventDetailsController.eventInfo?.eventData?.category_id == "1"
                        ? Get.toNamed(Routes.tikitBookingHallScreenKclub, arguments: {
                      "eventId": eventId,
                      "eventName": eventDetailsController.eventInfo?.eventData?.eventTitle,
                      "date": formatDate(eventDetailsController.eventInfo?.eventData!.eventSdate ?? ''),
                      "bhogid": getData.read("UserLogin")["club"],
                      "alloption": eventDetailsController.eventInfo?.eventData?.alloption,
                      "memberprice": eventDetailsController.eventInfo?.eventData?.memberprice,
                      "guestsprice": eventDetailsController.eventInfo?.eventData?.guestsprice,
                      "maxmember": maxmember,
                      "maxguest": maxguest,
                      "textname": eventDetailsController.eventInfo?.eventData?.eventTitle,
                      "eventStatus": eventDetailsController.eventInfo?.eventData?.flag
                    })
                        : Get.toNamed(Routes.tikitBookingScreenKclub, arguments: {
                      "eventId": eventId,
                      "eventName": eventDetailsController.eventInfo?.eventData?.eventTitle,
                      "date": formatDate(eventDetailsController.eventInfo?.eventData!.eventSdate ?? ''),
                      "bhogid": getData.read("UserLogin")["club"],
                      "alloption": eventDetailsController.eventInfo?.eventData?.alloption,
                      "memberprice": eventDetailsController.eventInfo?.eventData?.memberprice,
                      "guestsprice": eventDetailsController.eventInfo?.eventData?.guestsprice,
                      "maxmember": maxmember,
                      "maxguest": maxguest,
                      "textname": eventDetailsController.eventInfo?.eventData?.eventTitle,
                      "eventStatus": eventDetailsController.eventInfo?.eventData?.flag
                    });
                  } else {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text("Please Signup first for booking."),
                        action: SnackBarAction(
                          label: 'Signup'.tr,
                          onPressed: () {
                            Get.to(() => SignUpScreen());
                          },
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                },
              ),

              // Performer Booking Button with Popup Menu
              SizedBox(height: 5),









            ],
          )
              : SizedBox()
              : SizedBox();
        },
      ),
      body: GetBuilder<EventDetailsControllerKclub>(builder: (context) {
        return eventDetailsController.isLoading
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
              actions: [
                bookStatus == "1"
                    ? eventDetailsController
                    .eventInfo?.eventData?.isBookmark !=
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
                      color: gradient.defoultColor1,
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
              ],
              expandedHeight: Get.height * 0.49,
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
                      height: Get.height * 0.44,
                      width: double.infinity,
                      child: cs.CarouselSlider(
                        options: cs.CarouselOptions(
                          height: Get.size.height / 2,
                          viewportFraction: 1,
                          autoPlay: true,
                        ),
                        items: eventDetailsController
                            .eventInfo?.eventData?.eventCoverImg !=
                            []
                            ? eventDetailsController.eventInfo?.eventData?.eventCoverImg?.map<Widget>((i) {
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
                                    image: Config.imageUrlkclub + i),
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

                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  eventDetailsController.eventInfo
                                      ?.eventData?.eventTitle ??
                                      "",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 18,
                                    color: BlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                                          ?.eventData?.eventSdate ??
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
                                          ?.eventData?.eventTimeDay ??
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
                                    Text(
                                      eventDetailsController.eventInfo
                                          ?.eventData?.eventAddress ??
                                          "",
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
                                onTap: () async {
                                  await openMap(
                                    double.parse(eventDetailsController
                                        .eventInfo
                                        ?.eventData
                                        ?.eventLatitude ??
                                        ""),
                                    double.parse(eventDetailsController
                                        .eventInfo
                                        ?.eventData
                                        ?.eventLongtitude ??
                                        ""),
                                  );
                                },
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
                          height: 10,
                        ),
                        Container(
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
                                      "${eventDetailsController.eventInfo?.eventData?.ticketPrice ?? ""}",
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
                                "${int.parse(eventDetailsController.eventInfo?.eventData?.totalTicket.toString() ?? "0") - int.parse(eventDetailsController.eventInfo?.eventData?.totalBookTicket.toString() ?? "0")} spots left",
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    /*Get.to(
                                      OrganizerInformation(
                                        orgImg: eventDetailsController
                                            .eventInfo
                                            ?.eventData
                                            ?.sponsoreImg ??
                                            "",
                                        orgId: eventDetailsController
                                            .eventInfo
                                            ?.eventData
                                            ?.sponsoreId ??
                                            "",
                                        orgName: eventDetailsController
                                            .eventInfo
                                            ?.eventData
                                            ?.sponsoreName ??
                                            "",
                                      ),
                                    );*/
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
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                              Colors.purple.shade50,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "${Config.imageUrlkclub}${eventDetailsController.eventInfo?.eventData?.sponsoreImg ?? ""}"),
                                              ),
                                            ),

                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),


                                          Column(

                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                eventDetailsController
                                                    .eventInfo
                                                    ?.eventData
                                                    ?.sponsoreName ??
                                                    "",
                                                style: TextStyle(
                                                  fontFamily: FontFamily
                                                      .gilroyMedium,
                                                  color: BlackColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              eventDetailsController
                                                  .eventInfo
                                                  ?.eventData
                                                  ?.isJoined ==
                                                  1
                                                  ? SizedBox(
                                                height: 2,
                                              )
                                                  : SizedBox(),
                                              eventDetailsController
                                                  .eventInfo
                                                  ?.eventData
                                                  ?.isJoined ==
                                                  1
                                                  ? Text(
                                                eventDetailsController
                                                    .eventInfo
                                                    ?.eventData
                                                    ?.sponsoreMobile ??
                                                    "",
                                                style: TextStyle(
                                                  fontFamily: FontFamily
                                                      .gilroyMedium,
                                                  color: greytext,
                                                  fontSize: 12,
                                                ),
                                              )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /*Expanded(
                                child: InkWell(
                                  onTap: () {
                                    orgController.getJoinDataList(
                                      eventId: eventDetailsController
                                          .eventInfo?.eventData?.eventId,
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
                                        "${"Attendees".tr}(${eventDetailsController.eventInfo?.eventData?.totalBookTicket})",
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
                              )*/
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Venue".tr,
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
                                .eventInfo?.eventData?.eventAddressTitle ??
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
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "About Event".tr,
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
                                .eventInfo?.eventData?.eventAbout ??
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15),
                          child: HtmlWidget(
                            eventDetailsController.eventInfo?.eventData
                                ?.eventDisclaimer ??
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
                          height: 10,
                        ),
                        eventDetailsController
                            .eventInfo!.eventArtist!.isNotEmpty
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
                            .eventInfo!.eventArtist!.isNotEmpty
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventArtist!.isNotEmpty
                            ? SizedBox(
                          height: 80,
                          width: Get.size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15),
                            child: ListView.builder(
                              itemCount: eventDetailsController
                                  .eventInfo?.eventArtist?.length,
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
                                                "${Config.imageUrl}${eventDetailsController.eventInfo!.eventArtist?[index].artistImg}"),
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
                                                !.eventArtist?[
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
                                                  ?.eventArtist?[
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
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventFacility!.isNotEmpty
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventFacility!.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15),
                          child: Text(
                            "Facility".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 14,
                              color: BlackColor,
                            ),
                          ),
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventFacility!.isNotEmpty
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventFacility!.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: eventDetailsController
                                .eventInfo?.eventFacility?.length,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisExtent: 85),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    alignment: Alignment.center,
                                    child: Image.network(
                                      "${Config.imageUrl}${eventDetailsController.eventInfo?.eventFacility?[index].facilityImg}",
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
                                        ?.eventFacility?[index]
                                        .facilityTitle ??
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
                                  )
                                ],
                              );
                            },
                          ),
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventRestriction!.isNotEmpty
                            ? SizedBox(
                          height: 15,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventRestriction!.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15),
                          child: Text(
                            "Stall".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 14,
                              color: BlackColor,
                            ),
                          ),
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventRestriction!.isNotEmpty
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventRestriction!.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: eventDetailsController
                                .eventInfo?.eventRestriction!.length,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisExtent: 85),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                      height: 60,
                                      width: 60,
                                      alignment: Alignment.center,
                                      child: /*Image.network(
                                      "${Config.imageUrl}${eventDetailsController.eventInfo?.eventRestriction?[index].restrictionImg}",
                                      height: 50,
                                      width: 50,
                                    ),*/
                                      GestureDetector(
                                        onTap: () {
                                          print('Image tapped!');
                                          Get.toNamed(
                                            Routes
                                                .stallDetailScreen,
                                            arguments: {
                                              "eventName": eventDetailsController.eventInfo?.eventRestriction?[index]
                                                  .restrictionTitle,
                                              "stallId": eventDetailsController.eventInfo?.eventRestriction?[index]
                                                  .restrictionId,
                                              "category": eventDetailsController.eventInfo?.eventRestriction?[index]
                                                  .restriction_category,
                                              "image":
                                              "${Config.imageUrl}${eventDetailsController.eventInfo?.eventRestriction?[index].restrictionImg}",
                                            },
                                          );
                                        },
                                        child: Image.network(
                                          "${Config.imageUrl}${eventDetailsController.eventInfo?.eventRestriction?[index].restrictionImg}",
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    eventDetailsController
                                        .eventInfo
                                        ?.eventRestriction?[
                                    index]
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
                                  )
                                ],
                              );
                            },
                          ),
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventGallery!.isNotEmpty
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventGallery!.isNotEmpty
                            ? Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Gallery".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                color: BlackColor,
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            TextButton(
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
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventGallery!.isNotEmpty
                            ? SizedBox(
                          height: 100,
                          width: Get.size.width,
                          child: ListView.builder(
                            itemCount: eventDetailsController
                                .eventInfo?.eventGallery?.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(
                                    FullScreenImage(
                                      imageUrl:
                                      "${Config.imageUrl}${eventDetailsController.eventInfo!.eventGallery?[index]}",
                                      tag: "generate_a_unique_tag",
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
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
                                      "${Config.imageUrl}${eventDetailsController.eventInfo?.eventGallery?[index] ?? ""}",
                                      height: 100,
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
                        eventDetailsController.eventInfo!.eventData
                        !.eventVideoUrls!.isNotEmpty
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
                                //Get.to(VideoViewScreen());
                              },
                              child: Text(
                                "".tr,
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
                        !.eventVideoUrls!.isNotEmpty
                            ? Container(
                          height: 100,
                          width: Get.size.width,
                          child: ListView.builder(
                            itemCount: eventDetailsController
                                .eventInfo
                                ?.eventData
                                ?.eventVideoUrls
                                ?.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return eventDetailsController
                                  .eventInfo
                                  ?.eventData
                                  ?.eventVideoUrls?[index] !=
                                  "null"
                                  ? InkWell(
                                onTap: () {
                                  Get.to(VideoPreviewScreen(
                                    url: eventDetailsController
                                        .eventInfo
                                        ?.eventData
                                        ?.eventVideoUrls?[
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
                                                    ?.eventVideoUrls?[index] ??
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
                            .eventInfo!.reviewdata!.isNotEmpty
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
                            .eventInfo!.reviewdata!.isNotEmpty
                            ? ListView.builder(
                          itemCount: eventDetailsController
                              .eventInfo?.reviewdata?.length,
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
                                      "${Config.imageUrl}${eventDetailsController.eventInfo?.reviewdata?[index].userImg ?? ""}",
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
                                  !.reviewdata?[index]
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
                                  "${eventDetailsController.eventInfo?.reviewdata?[index].rateText ?? ""}",
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
                                        "${eventDetailsController.eventInfo?.reviewdata?[index].rateNumber ?? ""}",
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
                        /*Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "Maps".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: BlackColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
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
                                        ?.eventLatitude ??
                                        "0"),
                                    double.parse(eventDetailsController
                                        .eventInfo
                                        ?.eventData
                                        ?.eventLongtitude ??
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
                        /*   eventDetailsController
                            .eventInfo!.eventData!.eventTags!.isNotEmpty
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventData!.eventTags!.isNotEmpty
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
                            .eventInfo!.eventData!.eventTags!.isNotEmpty
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(),
                        eventDetailsController
                            .eventInfo!.eventData!.eventTags!.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15),
                          child: Wrap(
                            spacing: 5.0,
                            runSpacing: 0,
                            children: List<Widget>.generate(
                                eventDetailsController.eventInfo!.eventData!.eventTags
                                    !.length, (int index) {
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
                                        !.eventTags![index],
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
                            : SizedBox(),*/
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
}

class FamilyMember {
  final String id;
  final String userId;
  final String days;
  final String event_type;
  final String? paymentType;
  final String? image;
  final String bhogid;
  final String amount;
  final String status;


  FamilyMember({
    required this.id,
    required this.userId,
    required this.days,
    required this.event_type,
    this.paymentType,
    this.image,
    required this.bhogid,
    required this.amount,
    required this.status,

  });

  // Factory constructor to create an instance from a JSON map
  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      userId: json['user_id'],
      days: json['days'],
      event_type: json['event_type'],
      paymentType: json['payment_type'],
      image: json['image'],
      bhogid: json['bhogid'],
      amount: json['amount'],
      status: json['status'],

    );
  }
}

class KaraokeResponse {
  final List<FamilyMember> familyList;
  final String responseCode;
  final String result;
  final String responseMsg;

  KaraokeResponse({
    required this.familyList,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  // Factory constructor to create an instance from a JSON map
  factory KaraokeResponse.fromJson(Map<String, dynamic> json) {
    List<FamilyMember> familyList = [];
    if (json['familylist'] != null) {
      var list = json['familylist'] as List;
      familyList = list.map((i) => FamilyMember.fromJson(i)).toList();
    }

    return KaraokeResponse(
      familyList: familyList,
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
    );
  }
}
