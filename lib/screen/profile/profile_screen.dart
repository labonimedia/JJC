// ignore_for_file: prefer_const_constructors, deprecated_member_use, sort_child_properties_last, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jjcentre/Api/config.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/controller/faq_controller.dart';
import 'package:jjcentre/controller/login_controller.dart';
import 'package:jjcentre/controller/pagelist_controller.dart';
import 'package:jjcentre/controller/wallet_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/LoginAndSignup/login_screen.dart';
import 'package:jjcentre/screen/bottombar_screen.dart';
import 'package:jjcentre/screen/language/language_screen.dart';
import 'package:jjcentre/screen/profile/faq_screen.dart';
import 'package:jjcentre/screen/profile/notification_screen.dart';
import 'package:jjcentre/screen/profile/refer&earn_screen.dart';
import 'package:jjcentre/utils/Colors.dart';

import '../memberprofilescreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LoginController loginController = Get.find();
  PageListController pageListController = Get.find();
  FaqController faqController = Get.find();
  WalletController walletController = Get.find();

  String? path;
  String? networkimage;
  String? base64Image;

  String userName = "";

  @override
  void initState() {
    super.initState();
    getData.read("UserLogin") != null
        ? setState(() {
            userName = getData.read("UserLogin")["name"] ?? "";
            networkimage = getData.read("UserLogin")["pro_pic"] ?? "";
            getData.read("UserLogin")["pro_pic"] != "null"
                ? setState(() {
                    networkimageconvert();
                  })
                : const SizedBox();
          })
        : null;
  }

  networkimageconvert() {
    (() async {
      http.Response response =
          await http.get(Uri.parse(Config.imageUrl + networkimage.toString()));
      if (mounted) {
        print(response.bodyBytes);
        setState(() {
          base64Image = const Base64Encoder().convert(response.bodyBytes);
        });
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leadingWidth: 0,
        leading: SizedBox(),
        title: Text(
          "Profile".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 16,
            color: BlackColor,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<LoginController>(builder: (context) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        _openGallery(Get.context!);
                      },
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: path == null
                            ? networkimage != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: Image.network(
                                      "${Config.imageUrl}${networkimage ?? ""}",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: Get.height / 17,
                                    child: Image.asset(
                                      "assets/profile-default.png",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.file(
                                  File(path.toString()),
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: -5,
                      child: InkWell(
                        onTap: () {
                          _openGallery(Get.context!);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          padding: EdgeInsets.all(7),
                          child: Image.asset(
                            "assets/Edit.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(
                height: 10,
              ),
              Text(
                getData.read("UserLogin")["name"],
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 20,
                  color: BlackColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              settingWidget(
                name: "My Booking".tr,
                imagePath: "assets/Calendar.png",
                onTap: () {
                  save("currentIndex", true);
                  loginController.changeIndex(2);
                  Get.to(BottomBarScreen());
                  setState(() {});
                  // myBookingController.statusWiseBooking();
                  // Get.toNamed(Routes.mybookingScreen);
                },
              ),
              SizedBox(
                height: 10,
              ),
             /* settingWidget(
                name: "Wallet".tr,
                imagePath: "assets/wallet.png",
                onTap: () {
                  Get.toNamed(Routes.walletScreen);
                },
              ),
              SizedBox(
                height: 5,
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              settingWidget(
                name: "Profile".tr,
                imagePath: "assets/Profile.png",
                onTap: () {
                  Get.to(MemberProfileScreen());
                },
              ),
              SizedBox(
                height: 5,
              ),
              settingWidget(
                name: "Language".tr,
                imagePath: "assets/Globeweb.png",
                onTap: () {
                  Get.to(LanguageScreen());
                },
              ),
              SizedBox(
                height: 5,
              ),
              GetBuilder<PageListController>(builder: (context) {
                return pageListController.isLodding
                    ? ListView.builder(
                        itemCount:
                            pageListController.pageListInfo?.pagelist.length,
                        shrinkWrap: true,
                        itemExtent: 60,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Column(
                              children: [
                                settingWidget(
                                  name: pageListController
                                      .pageListInfo?.pagelist[index].title,
                                  imagePath: "assets/documentpage.png",
                                  onTap: () {
                                    Get.toNamed(Routes.loreamScreen,
                                        arguments: {
                                          "title": pageListController
                                              .pageListInfo
                                              ?.pagelist[index]
                                              .title,
                                          "discription": pageListController
                                              .pageListInfo
                                              ?.pagelist[index]
                                              .description,
                                        });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: gradient.defoultColor,
                        ),
                      );
              }),
              settingWidget(
                name: "Notification".tr,
                imagePath: "assets/Notification.png",
                onTap: () {
                  Get.to(NotificationScreen());
                },
              ),
              SizedBox(
                height: 10,
              ),
             /* settingWidget(
                name: "Help Center".tr,
                imagePath: "assets/HelpCenter.png",
                onTap: () {
                  faqController.getFaqDataApi();
                  Get.to(FaqScreen());
                },
              ),
              SizedBox(
                height: 10,
              ),*/
             /* settingWidget(
                name: "Invite Friends".tr,
                imagePath: "assets/invitefriends.png",
                onTap: () {
                  walletController.getReferData();
                  Get.to(ReferFriendScreen());
                },
              ),
              SizedBox(
                height: 10,
              ),*/
              InkWell(
                onTap: () {
                  deleteSheet();
                },
                child: SizedBox(
                  height: 45,
                  width: Get.size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        "assets/Delete.png",
                        height: 22,
                        width: 22,
                        color: BlackColor,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Delete Account".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyMedium,
                          fontSize: 16,
                          color: BlackColor,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 17,
                        color: BlackColor,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  logoutSheet();
                },
                child: SizedBox(
                  height: 40,
                  width: Get.size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        "assets/Logout.png",
                        height: 25,
                        width: 25,
                        color: RedColor,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Logout".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyMedium,
                          fontSize: 16,
                          color: RedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingWidget({Function()? onTap, String? name, String? imagePath}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 45,
        width: Get.size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            Image.asset(
              imagePath ?? "",
              height: 25,
              width: 25,
              color: BlackColor,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              name ?? "",
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 17,
              color: BlackColor,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      path = pickedFile.path;
      setState(() {});
      File imageFile = File(path.toString());
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      loginController.updateProfileImage(base64Image);
      setState(() {});
    }
  }

  Future deleteSheet() {
    return Get.bottomSheet(
      Container(
        height: 220,
        width: Get.size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Delete Account".tr,
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.gilroyBold,
                color: RedColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Divider(
                color: greytext,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Are you sure you want to delete account?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Cancle".tr,
                        style: TextStyle(
                          color: gradient.defoultColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFeef4ff),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      pageListController.deletAccount();
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes, Remove".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        //gradient: gradient.btnGradient,
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Future logoutSheet() {
    return Get.bottomSheet(
      Container(
        height: 220,
        width: Get.size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Logout".tr,
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.gilroyBold,
                color: RedColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Divider(
                color: greytext,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Are you sure you want to log out?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Cancle".tr,
                        style: TextStyle(
                          color: gradient.defoultColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFeef4ff),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      setState(() async {
                        save('isLoginBack', true);
                        getData.remove('Firstuser');
                        getData.remove("UserLogin");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      });
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Logout".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        //gradient: gradient.btnGradient,
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
