// ignore_for_file: unused_local_variable, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/screen/LoginAndSignup/login_screen.dart';
import 'package:jjcentre/screen/bottombar_screen.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../helpar/routes_helpar.dart';
import '../screen/AddFamilyMemberScreen.dart';
import '../screen/LoginAndSignup/welcome_screen.dart';
import '../screen/bhog_qr_screen.dart';
import '../screen/pay_membership_fee.dart';
import '../screen/qr_scanner_screen.dart';
import '../screen/welcomepagescreen.dart';

class LoginController extends GetxController implements GetxService {
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController newPassword = TextEditingController();
  TextEditingController newConformPassword = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? pickedImage;

  bool showPassword = true;
  bool newShowPassword = true;
  bool conformPassword = true;
  bool isChecked = false;

  String userMessage = "";
  String resultCheck = "";

  String forgetPasswprdResult = "";
  String forgetMsg = "";

  changeIndex(int index) {
    selectedIndex = index;
    update();
  }

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }

  newShowOfPassword() {
    newShowPassword = !newShowPassword;
    update();
  }

  newConformShowOfPassword() {
    conformPassword = !conformPassword;
    update();
  }

  changeRememberMe(bool? value) {
    isChecked = value ?? false;
    update();
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      pickedImage = tempImage;
      update();
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  getLoginApiData(String cuntryCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Token:"+prefs.getString("token").toString());
    try {
      Map map = {
        "mobile": number.text,
        "ccode": cuntryCode,
        "password": password.text,
        "token": prefs.getString("token").toString(),
      };
      print(map.toString());
      Uri uri = Uri.parse(Config.baseurl + Config.loginApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(response.body);
      if (response.statusCode == 200) {
        save('Firstuser', true);
        var result = jsonDecode(response.body);
        print(result.toString());
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        showToastMessage(userMessage);
        if (resultCheck == "true") {
          //Get.offAll(BottomBarScreen());

          if(result["UserLogin"]["volunteer"]=="1"){
            Get.to(()=>QRScannerScreen());
          }else{

          Get.to(WelcomeScreen());
          }
          number.text = "";
          password.text = "";
          isChecked = false;
          update();
        }
        save("UserLogin", result["UserLogin"]);
        save("Memberlimit", result["Memberlimit"]);
        save("clublist", result["clublist"]);
        print("+++++++++++++++" + getData.read("Firstuser").toString());
        /*initPlatformState();
        OneSignal.User.addTagWithKey("user_id", getData.read("UserLogin")["id"]);*/
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }


  getLoginApiForData(String cuntryCode,String mobile,String password) async {
    try {
      Map map = {
        "mobile": mobile,
        "ccode": cuntryCode,
        "password": password,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.loginApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(response.body);
      if (response.statusCode == 200) {
        save('Firstuser', true);
        var result = jsonDecode(response.body);
        print(result.toString());
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        //showToastMessage(userMessage);
        if (resultCheck == "true") {
          //Get.offAll(BottomBarScreen());



          update();
        }
        save("UserLogin", result["UserLogin"]);
        save("Memberlimit", result["Memberlimit"]);
        save("clublist", result["clublist"]);
        print("+++++++++++++++" + getData.read("Firstuser").toString());

        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }


  getLoginApiDataNew(String cuntryCode,String mobile ,String password) async {
    try {
      Map map = {
        "mobile": mobile,
        "ccode": cuntryCode,
        "password": password,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.loginApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(response.body);
      if (response.statusCode == 200) {
        save('Firstuser', true);
        var result = jsonDecode(response.body);
        print(result.toString());
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        //showToastMessage(userMessage);
        if (resultCheck == "true") {
          //Get.offAll(BottomBarScreen());

          update();
        }
        save("UserLogin", result["UserLogin"]);


        print("+++++++++++++++" + getData.read("Firstuser").toString());
        //initPlatformState();
        //OneSignal.User.addTagWithKey("user_id", getData.read("UserLogin")["id"]);
        update();
      }
    } catch (e) {

      print(e.toString());
    }
  }

  var familyMembers = <Map<String, dynamic>>[].obs;

  void setFamilyMembers(List<dynamic> membersList) {
    familyMembers.clear();
    for (var member in membersList) {
      familyMembers.add({
        'id': member['id'],
        'user_id': member['user_id'],
        'name': member['name'],
        'gender': member['gender'],
        'age': member['age'].toString(), // Ensure age is a string
        'relationship': member['relationship'],
        'profession': member['profession'],
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchFamilyMembers() async {
   try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      Uri uri = Uri.parse(Config.baseurl + Config.getMemberList);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {

        var result = jsonDecode(response.body);
        print(result.toString());

        var membersList = result["familylist"] as List<dynamic>;
        setFamilyMembers(membersList);
        update();
        return familyMembers;
      }else{
        throw Exception('Failed to load user data');
        return [];
      }
   } catch (e) {
     print("Exception occurred: $e");
     return [];
   }

  }

  addMemberApiData(List<Map<String, dynamic>> familyMembers) async {
    try {
      Map map = {
        "familyMembers": familyMembers,
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      Uri uri = Uri.parse(Config.baseurl + Config.addMember);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(map.toString());
      if (response.statusCode == 200) {

        var result = jsonDecode(response.body);
        print(result.toString());
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        showToastMessage(userMessage);
        if (resultCheck == "true") {
          //Get.offAll(BottomBarScreen());
          //Get.to(PayMembershipFeeScreen());
          showToastMessage(userMessage);
          update();
        }



        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }


  setForgetPasswordApi({
    String? mobile,
    String? ccode,
  }) async {
    try {
      Map map = {
        "mobile": mobile,
        "ccode": ccode,
        "password": newPassword.text,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.forgetPassword);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      //showToastMessage(response.body);
      //print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        forgetPasswprdResult = result["Result"];
        forgetMsg = result["ResponseMsg"];
        if (forgetPasswprdResult == "true") {
          save('isLoginBack', false);
          Get.to(LoginScreen());
          showToastMessage(forgetMsg);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  updateProfileImage(String? base64image) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
      };
      Uri uri = Uri.parse(Config.baseurl + Config.updateProfilePic);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  addPaymentImage(String? base64image, String? type ,String transactionMode,String transactionID) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "transaction_mode":transactionMode,
        "transaction_id": transactionID,
      };


      Uri uri = Uri.parse(Config.baseurl + Config.uploadPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      //print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);



        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  addSponsorPaymentImage(String? base64image, String? type ,String? amount ,String description,String transactionMode,String transactionID ) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "description":description,
        "transaction_mode":transactionMode,
        "transaction_id": transactionID,
      };


      Uri uri = Uri.parse(Config.baseurl + Config.uploadSponsorPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      //print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
      //  showToastMessage("Thank you for sharing your payment details. Our team will verify and update your sponsorship details.".tr);
        Get.back();

        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  addBhogPaymentImage(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname,String transactionMode,String transactionID) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
        "transaction_mode":transactionMode,
        "transaction_id": transactionID,
      };

      print(transactionMode+" " +transactionID);
      Uri uri = Uri.parse(Config.baseurl + Config.uploadBhogPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        showToastMessage("Thank you for sharing your payment details. Our team will verify and update your ${textname} details.".tr);
        Get.back();
        Get.back();
        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }



  addBhogPaymentImageKclub(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname,String transactionMode,String transactionID) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
        "transaction_mode":transactionMode,
        "transaction_id": transactionID,
      };

      print(transactionMode+" " +transactionID);
      Uri uri = Uri.parse(Config.baseurlKclub + Config.uploadBhogPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        showToastMessage("Thank you for sharing your payment details. Our team will verify and update your ${textname} details.".tr);
        Get.back();
        Get.back();
        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }



  addEventPaymentImage(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname,String transactionMode,String transactionID,String hallId,String seats) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
        'seats':seats,
        "transaction_mode":transactionMode,
        "transaction_id": transactionID,
      };

      print(transactionMode+" " +transactionID);
      Uri uri = Uri.parse(Config.baseurl + Config.bookTicketPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your ${textname} details.".tr);
        //showToastMessage("Thank you for sharing your payment details. Your Ticket is booked".tr);

        bookTicketOfEvent(enventid,hallId,seats);
        OrderPlacedSuccessfully();
        /*Get.back();
        Get.back();*/
        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }



  addKclubEventPaymentImage(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname,String transactionMode,String transactionID,String hallId,String seats) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
        'seats':seats,
        "transaction_mode":transactionMode,
        "transaction_id": transactionID,
      };

      print(transactionMode+" " +transactionID);
      Uri uri = Uri.parse(Config.baseurlKclub + Config.bookTicketPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your ${textname} details.".tr);
        //showToastMessage("Thank you for sharing your payment details. Your Ticket is booked".tr);

        bookTicketOfKclubEvent(enventid,hallId,seats);
        OrderPlacedSuccessfully();
        /*Get.back();
        Get.back();*/
        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }


  addKclubEventPerformerPaymentImage(String? base64image, String? type ,String? amount,String enventid,String edate,String eventname,String? textname,String transactionMode,String transactionID,String seats) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
        'seats':seats,
        "transaction_mode":transactionMode,
        "transaction_id": transactionID,
      };

      print(transactionMode+" " +transactionID);
      Uri uri = Uri.parse(Config.baseurlKclub + Config.bookTicketPaymentPerformerImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your ${textname} details.".tr);
        //showToastMessage("Thank you for sharing your payment details. Your Ticket is booked".tr);

        //bookTicketOfkclubPerformerEvent(enventid,seats);
        OrderPlacedSuccessfully();
        /*Get.back();
        Get.back();*/
        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }




  bookTicketOfEvent(String eventId, String hallId, String seats) async {
    try {

      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "event_id": eventId,
        "hall_id": hallId,
        "selected_seat": seats,

      };

      print("Data" + map.toString());
      Uri uri = Uri.parse(Config.baseurl + Config.bookHallTicket);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage(result["ResponseMsg"]);
        // Get.back();
      }
    } catch (e) {
      print(e.toString());
    }
  }


  bookTicketOfKclubEvent(String eventId, String hallId, String seats) async {
    try {

      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "event_id": eventId,
        "hall_id": hallId,
        "selected_seat": seats,

      };

      print("Data" + map.toString());
      Uri uri = Uri.parse(Config.baseurlKclub + Config.bookHallTicket);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage(result["ResponseMsg"]);
        // Get.back();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  addBhogFreePaymentImage(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
      };

     // print("Date"+map.toString());
      Uri uri = Uri.parse(Config.baseurl + Config.uploadBhogPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        showToastMessage(result["ResponseMsg"]);
        Get.back();

        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  addBhogFreePaymentImageKclub(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
      };

      // print("Date"+map.toString());
      Uri uri = Uri.parse(Config.baseurlKclub + Config.uploadBhogPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        showToastMessage(result["ResponseMsg"]);
        Get.back();

        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  bookTicketPaymentImage(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname, String join) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
        'seats':join,
      };

      print("Date"+map.toString());
      Uri uri = Uri.parse(Config.baseurl + Config.bookTicketPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage(result["ResponseMsg"]);
        OrderPlacedSuccessfully();

        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }


  bookFreeTicketPaymentImageKclub(String? base64image, String? type ,String? amount,String? bhogid ,String? mCount,String? gCount ,String enventid,String edate,String eventname,String? textname, String join) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "img": base64image,
        "type": type,
        "amount": amount,
        "bhogid":bhogid,
        "mCount":mCount,
        "gCount":gCount,
        "enventid":enventid,
        "edate":edate,
        "eventname":eventname,
        'seats':join,
      };

      print("Date"+map.toString());
      Uri uri = Uri.parse(Config.baseurlKclub + Config.bookTicketPaymentImage);

      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      //showToastMessage("Thank you for sharing your payment details. Our team will verify and update your membership details.".tr);
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //showToastMessage(result["ResponseMsg"]);
        OrderPlacedSuccessfully();

        //save("UserLogin", result["UserLogin"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

}
