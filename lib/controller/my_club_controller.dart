import 'dart:convert';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model/ResponseData.dart';
import '../model/event_info.dart';
import '../model/home_info.dart';
import '../model/sponser_details.dart';

class MyClubDetailsController extends GetxController implements GetxService {
  ResponseData? responseData;

  bool isLoading = false;

  getClubData({String? clubId}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin") != null
            ? getData.read("UserLogin")["id"]
            : "1",
        "club_id": clubId,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.myClubDetails);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        /* menberList = [];
        for (var element in result["EventData"]["member_list"]) {
          menberList.add("${Config.imageUrl}" + element);
        }*/


        responseData = ResponseData.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
  getSponserDataApi(String eventId) async {

    try {
      Map map = {
        "uid": eventId,

      };
      Uri uri = Uri.parse(Config.baseurl + Config.sponserDetails);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        responseData = ResponseData.fromJson(result);


      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }

  }



}
