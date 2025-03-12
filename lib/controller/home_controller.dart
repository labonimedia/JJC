// ignore_for_file: avoid_print, prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/controller/eventdetails_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/home_info.dart';
import 'package:jjcentre/model/map_info.dart';
import 'package:jjcentre/screen/LoginAndSignup/onbording_screen.dart.dart';
import 'package:jjcentre/screen/home_screen.dart';

class HomePageController extends GetxController implements GetxService {
  EventDetailsController eventDetailsController = Get.find();
  PageController pageController = PageController();

  List<MapInfo> mapInfo = [];

  bool isLoading = false;
  HomeInfo? homeInfo,homeInfo1;

  CameraPosition kGoogle = CameraPosition(
    target: LatLng(21.2381962, 72.8879607),
    zoom: 5,
  );

  List<Marker> markers = <Marker>[];
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  HomePageController() {
    getKaraokeData();
    getHomeDataApi();

  }

  getHomeDataApi() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin") != null
            ? getData.read("UserLogin")["id"]
            : "0",
        "lats": lat,
        "longs": long,
      };
      print(map.toString());
      Uri uri = Uri.parse(Config.baseurl + Config.homeDataApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("::::::::::________::::::::::" + response.statusCode.toString());
      print("::::::::::________::::::::::" + response.body.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("::::::::::________::::::::::123" + result.toString());
        for (var element in result["HomeData"]["nearby_event"]) {
          mapInfo.add(MapInfo.fromJson(element));
        }
        homeInfo = HomeInfo.fromJson(result);
        var maplist = mapInfo.reversed.toList();

        for (var i = 0; i < maplist.length; i++) {
          final Uint8List markIcon = await getImages("assets/MapPin.png", 100);
          markers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              position: LatLng(
                double.parse(mapInfo[i].eventLatitude),
                double.parse(mapInfo[i].eventLongtitude),
              ),
              icon: BitmapDescriptor.fromBytes(markIcon),
              onTap: () {
                pageController.animateToPage(i,
                    duration: Duration(seconds: 1), curve: Curves.decelerate);
                update();
              },
              infoWindow: InfoWindow(
                title: mapInfo[i].eventTitle,
                snippet: mapInfo[i].eventPlaceName,
                onTap: () async {
                  await eventDetailsController.getEventData(
                    eventId: mapInfo[i].eventId,
                  );
                  Get.toNamed(
                    Routes.eventDetailsScreen,
                    arguments: {
                      "eventId": mapInfo[i].eventId,
                      "bookStatus": "1",
                    },
                  );
                },
              ),
            ),
          );
          kGoogle = CameraPosition(
            target: LatLng(
              double.parse(maplist[i].eventLatitude),
              double.parse(maplist[i].eventLongtitude),
            ),
            zoom: 8,
          );
        }
        currency = result["HomeData"]["Main_Data"]["currency"];
        wallet1 = result["HomeData"]["wallet"];
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getKaraokeData() async {

    final Uri uri = Uri.parse(Config.baseurlKclub + Config.karaokeEvents);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin") != null
            ? getData.read("UserLogin")["id"]
            : "1",
        "lats": lat,
        "longs": long,
      }),
      headers: {"Content-Type": "application/json"},
    );
    print("Uri:"+uri.toString());
    print("kclubResponse:"+response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      homeInfo1 = HomeInfo.fromJson(result);

    }

    /* if (response.statusCode == 200) {
      return ResponseData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }*/
  }
}
