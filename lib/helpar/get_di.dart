import 'package:get/get.dart';
import 'package:jjcentre/controller/bookevent_controller.dart';
import 'package:jjcentre/controller/club_signup_controller.dart';
import 'package:jjcentre/controller/coupon_controller.dart';
import 'package:jjcentre/controller/eventdetails_controller.dart';
import 'package:jjcentre/controller/eventdetails_controller1.dart';
import 'package:jjcentre/controller/eventdetailskclub_controller.dart';
import 'package:jjcentre/controller/faq_controller.dart';
import 'package:jjcentre/controller/favorites_controller.dart';
import 'package:jjcentre/controller/home_controller.dart';
import 'package:jjcentre/controller/login_controller.dart';
import 'package:jjcentre/controller/my_club_home_controller.dart';
import 'package:jjcentre/controller/mybooking_controller.dart';
import 'package:jjcentre/controller/notification_controller.dart';
import 'package:jjcentre/controller/org_controller.dart';
import 'package:jjcentre/controller/pagelist_controller.dart';
import 'package:jjcentre/controller/search_controller.dart';
import 'package:jjcentre/controller/signup_controller.dart';
import 'package:jjcentre/controller/wallet_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/club_controller.dart';
import '../controller/my_club_controller.dart';

init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => SignUpController());
  Get.lazyPut(() => HomePageController());
  Get.lazyPut(() => MyClubHomePageController());
  Get.lazyPut(() => ClubDetailsController());
  Get.lazyPut(() => MyClubDetailsController());
  Get.lazyPut(() => ClubSignUpController());
  Get.lazyPut(() => PageListController());
  Get.lazyPut(() => WalletController());
  Get.lazyPut(() => EventDetailsController());
  Get.lazyPut(() => EventDetailsController1());
  Get.lazyPut(() => EventDetailsControllerKclub());
  Get.lazyPut(() => FavoriteController());
  Get.lazyPut(() => CouponController());
  Get.lazyPut(() => BookEventController());
  Get.lazyPut(() => MyBookingController());
  Get.lazyPut(() => SearchController());
  Get.lazyPut(() => FaqController());
  Get.lazyPut(() => NotificationController());
  Get.lazyPut(() => OrgController());
}
