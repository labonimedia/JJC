// ignore_for_file: avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/screen/LoginAndSignup/resetpassword_screen.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';

class SignUpController extends GetxController implements GetxService {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController referralCode = TextEditingController();
  bool showPassword = true;
  bool chack = false;
  int currentIndex = 0;
  String userMessage = "";
  String resultCheck = "";
  String signUpMsg = "";

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }

  checkTermsAndCondition(bool? newbool) {
    chack = newbool ?? false;
    update();
  }

  cleanFild() {
    name.text = "";
    email.text = "";
    number.text = "";
    password.text = "";
    referralCode.text = "";
    chack = false;
    update();
  }

  changeIndex(int index) {
    currentIndex = index;
    update();
  }

  checkMobileNumber(String cuntryCode) async {
    try {
      Map map = {
        "mobile": number.text,
        "ccode": cuntryCode,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.mobileChack);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        print("MMMMMMMMMMMMMMMMMM" + userMessage);
        if (resultCheck == "true") {
          //sendOTP(number.text, cuntryCode);
          Get.toNamed(Routes.otpScreen, arguments: {
            "number": number.text,
            "cuntryCode": cuntryCode,
            "route": "signUpScreen",
          });
        }
        showToastMessage(userMessage);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  checkMobileInResetPassword({String? number, String? cuntryCode}) async {
    try {
      Map map = {
        "mobile": number,
        "ccode": cuntryCode,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.mobileChack);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        if (resultCheck == "false") {
          sendOTP(number ?? "", cuntryCode ?? "");
        /*  Get.toNamed(Routes.otpScreen, arguments: {
            "number": number,
            "cuntryCode": cuntryCode,
            "route": "resetScreen",
          });*/
        Get.toNamed(Routes.verifyOtpScreen, arguments: {
            "number": number,
            "cuntryCode": cuntryCode,
            "route": "resetScreen",
          });

        } else {
          showToastMessage("Mobile Number doesn't exists!");
        }
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  setUserApiData(String cuntryCode) async {
    try {
      Map map = {
        "name": name.text,
        "email": email.text,
        "mobile": number.text,
        "ccode": cuntryCode,
        "password": password.text
      };
      Uri uri = Uri.parse(Config.baseurl + Config.registerUser);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        save('Firstuser', true);
        signUpMsg = result["ResponseMsg"];
        showToastMessage(signUpMsg);
        save("UserLogin", result["UserLogin"]);
       /* initPlatformState();
        OneSignal.User.addTagWithKey("user_id", getData.read("UserLogin")["id"]);*/
        cleanFild();
        Get.back();
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  editProfileApi({String? name, String? password, String? email, String? age,String? gender,String? profession, String? volunteer}) async {
    try {
      Map map = {
        "name": name,
        "uid": getData.read("UserLogin")["id"].toString(),
        "password": password,
        "email": email,
        "age": age,
        "gender": gender,
        "profession": profession,
        "volenteer": volunteer,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.editProfileApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        save("UserLogin", result["UserLogin"]);
        showToastMessage(result["ResponseMsg"]);
      }
      Get.back();
      Get.back();
      update();
    } catch (e) {
      print(e.toString());
    }
  }


    Future<void> uploadImage(XFile image, String type) async {

      ///final uri = Uri.parse("https://your-server-url.com/upload");
      Uri uri = Uri.parse(Config.baseurl + Config.uploadPaymentImage);//
      var request = http.MultipartRequest('POST', uri);
     if(type =='pay_image') {
       request.files.add(await http.MultipartFile.fromPath('pay_image', image.path));
     }else if(type == 'rec_image'){
       request.files.add(  await http.MultipartFile.fromPath('rec_image', image.path));
     }
      var response = await request.send();
      print(response);
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
      } else {
        print('Image upload failed.');
      }




    }

}
