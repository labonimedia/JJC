// ignore_for_file: avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/model/pagelist_info.dart';
import 'package:jjcentre/utils/Custom_widget.dart';

import '../screen/LoginAndSignup/login_screen.dart';

class PageListController extends GetxController implements GetxService {
  PageListInfo? pageListInfo;
  bool isLodding = false;

  PageListController() {
    getPageListData();
  }

  getPageListData() async {
    try {
      Uri uri = Uri.parse(Config.baseurl + Config.pageListApi);
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result.toString());
        pageListInfo = PageListInfo.fromJson(result);
        isLodding = true;
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  deletAccount() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      print(map.toString());
      Uri uri = Uri.parse(Config.baseurl + Config.deletAccount);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        showToastMessage(result["ResponseMsg"]);
        save('isLoginBack', true);
        getData.remove('Firstuser');
        getData.remove("UserLogin");
        Get.to(() => LoginScreen());


      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
