// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/model/notification_info.dart';

class NotificationController extends GetxController implements GetxService {
  NotificationInfo? notificationInfo;
  bool isLoading = false;
  NotificationController() {
    getNotificationData();
  }
  getNotificationData() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin") != null
            ? getData.read("UserLogin")["id"]
            : "1",
      };
      Uri uri = Uri.parse(Config.baseurl + Config.notificationApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        notificationInfo = NotificationInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
