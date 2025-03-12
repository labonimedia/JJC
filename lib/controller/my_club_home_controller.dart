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

class MyClubHomePageController extends GetxController implements GetxService {
  EventDetailsController eventDetailsController = Get.find();
  PageController pageController = PageController();

  List<MapInfo> mapInfo = [];

  bool isLoading = false;
  HomeInfo? homeInfo;

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

  MyClubHomePageController() {
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
      Uri uri = Uri.parse(Config.baseurl + Config.myClubHomeDataApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("::::::::::________::::::::::" + response.body.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("::::::::::________::::::::::" + result.toString());
        for (var element in result["HomeData"]["nearby_event"]) {
          mapInfo.add(MapInfo.fromJson(element));
        }
        homeInfo = HomeInfo.fromJson(result);

      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
