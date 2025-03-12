// ignore_for_file: prefer_const_constructors

import 'package:get/route_manager.dart';
import 'package:jjcentre/screen/LoginAndSignup/onbording_screen.dart.dart';
import 'package:jjcentre/screen/LoginAndSignup/otp_screen.dart';
import 'package:jjcentre/screen/LoginAndSignup/verify_opt_screen.dart';
import 'package:jjcentre/screen/LoginAndSignup/resetpassword_screen.dart';
import 'package:jjcentre/screen/LoginAndSignup/signup_screen.dart';
import 'package:jjcentre/screen/addwallet/addwallet_screen.dart';
import 'package:jjcentre/screen/addwallet/wallet_screen.dart';
import 'package:jjcentre/screen/bottombar_screen.dart';
import 'package:jjcentre/screen/catwise_event.dart';
import 'package:jjcentre/screen/coupon_screen.dart';
import 'package:jjcentre/screen/event_details.dart';
import 'package:jjcentre/screen/event_details_screen1.dart';
import 'package:jjcentre/screen/memberprofilescreen.dart';
import 'package:jjcentre/screen/message.dart';
import 'package:jjcentre/screen/order_details.dart';
import 'package:jjcentre/screen/profile/editprofile_screen.dart';
import 'package:jjcentre/screen/profile/loream.dart';
import 'package:jjcentre/screen/ticket_details.dart';
import 'package:jjcentre/screen/welcomepagescreen.dart';

import '../screen/bhog_booking.dart';
import '../screen/bhog_deatail_screen.dart';
import '../screen/bhog_payment.dart';
import '../screen/bhog_payment_kclub.dart';
import '../screen/club_details.dart';
import '../screen/club_membership_screen.dart';
import '../screen/event_details_kclub.dart';
import '../screen/event_details_kclub_practice.dart';
import '../screen/event_details_new.dart';
import '../screen/event_details_screen_other.dart';
import '../screen/hall_detail_screen.dart';
import '../screen/kclubEventPerformerPayment.dart';
import '../screen/kclub_event_payment.dart';
import '../screen/other_event_screen.dart';
import '../screen/sponser_payment.dart';
import '../screen/sponsor_gallery_details.dart';
import '../screen/stall_details.dart';
import '../screen/ticket_booking_hall_admin.dart';
import '../screen/ticket_booking_hall_kclub.dart';
import '../screen/ticket_booking_hall_screen.dart';
import '../screen/ticket_booking_kclub.dart';
import '../screen/ticket_booking_screen.dart';
import '../screen/ticket_booking_screen_admin.dart';
import '../screen/view_sponser.dart';

class Routes {
  static String initial = "/";
  static String message = "/message";
  static String sponserGalleryDetailScreen= "/sponserGalleryDetailScreen";
  static String eventDetailsScreen = "/eventDetailsScreen";
  static String eventDetailsScreen1 = "/eventDetailsScreen1";
  static String eventDetailsScreenKclub = "/eventDetailsScreenKclub";
  static String eventDetailsScreenKclubPractice = "/eventDetailsScreenKclubPractice";

  static String eventDetailsScreenOther = "/eventDetailsScreenOther";
  static String eventDetailsScreenNew = "/eventDetailsScreenNew";
  static String bhogDetailsScreen = "/bhogDetailsScreen";
  static String hallDetailsScreen = "/hallDetailsScreen";
  static String sponserDetailsScreen = "/sponserDetailsScreen";
  static String bhogPaymentScreen = "/bhogPaymentScreen";
  static String bhogPaymentScreenKclub = "/bhogPaymentScreenKclub";
  static String otherEventPaymentScreen = "/otherEventPaymentScreen";
  static String kclubEventPaymentScreen = "/kclubEventPaymentScreen";
  static String kclubEventPerformerPayment = "/kclubEventPerformerPayment";
  static String stallDetailScreen = "/stallDetailScreen";
  static String sponserPaymentScreen = "/sponserPaymentScreen";
  static String bhogBookingScreen = "/bhogBookingScreen";
  static String tikitBookingScreen = "/tikitBookingScreen";
  static String tikitBookingScreenKclub = "/tikitBookingScreenKclub";

  static String tikitBookingScreenAdmin = "/tikitBookingScreenAdmin";
  static String tikitBookingHallScreen = "/tikitBookingHallScreen";
  static String tikitBookingHallScreenAdmin = "/tikitBookingHallScreenAdmin";
  static String tikitBookingHallScreenKclub = "/tikitBookingHallScreenKclub";
  static String clubDetailsScreen = "/clubDetailsScreen";
  static String tikitDetailsScreen = "/tikitDetailsScreen";
  static String orderDetailsScreen = "/orderDetailsScreen";
  static String otpScreen = '/otpScreen';
  static String verifyOtpScreen='/verifyOtpScreen';
  static String welcomscreenpage = '/welcomscreenpage';
  static String memberprofile = '/memberprofile';
  static String bottoBarScreen = "/bottoBarScreen";
  static String resetPassword = "/resetPassword";
  static String signUpScreen = "/signUpScreen";
  static String editProfileScreen = "/viewProfileScreen";
  static String loreamScreen = "/loreamScreen";
  static String addWalletScreen = "/addWalletScreen";
  static String walletScreen = "/walletScreen";
  static String couponScreen = "/couponScreen";
  static String catWiseEventScreen = "/catWiseEvent";
  static String getClubMembershipScreen="/getClubMembershipScreen";
}

final getPages = [
  GetPage(
    name: Routes.initial,
    page: () => onBording(),
  ),
 /* GetPage(
    name: Routes.message,
    page: () => Message(),
  ),*/
  GetPage(
    name: Routes.getClubMembershipScreen,
    page: () => GetMembershipScreen(),
  ),
  GetPage(
    name: Routes.sponserGalleryDetailScreen,
    page: () => SponsorGalleryDetailScreen(),
  ),
  GetPage(
    name: Routes.welcomscreenpage,
    page: () => Welcomepagescreen(),
  ),
  GetPage(
    name: Routes.memberprofile,
    page: () => MemberProfileScreen(),
  ),
  GetPage(
    name: Routes.stallDetailScreen,
    page: () => StallDetailScreen(),
  ),
  GetPage(
    name: Routes.sponserDetailsScreen,
    page: () => ViewSponserScreen(),
  ),
  GetPage(
    name: Routes.sponserPaymentScreen,
    page: () => SponserPaymentScreen(),
  ),
  GetPage(
    name: Routes.bhogPaymentScreen,
    page: () => BhogPaymentScreen(),
  ),

  GetPage(
    name: Routes.bhogPaymentScreenKclub,
    page: () => BhogPaymentScreenKclub(),
  ),
  GetPage(
    name: Routes.otherEventPaymentScreen,
    page: () => OtherEventPaymentScreen(),
  ),

  GetPage(
    name: Routes.kclubEventPaymentScreen,
    page: () => KclubEventPaymentScreen(),
  ),

  GetPage(
    name: Routes.kclubEventPerformerPayment,
    page: () => KclubEventPerformerPayment(),
  ),
  GetPage(
    name: Routes.eventDetailsScreen,
    page: () => EventDetailsScreen(),
  ),
  GetPage(
    name: Routes.eventDetailsScreen1,
    page: () => EventDetailsScreen1(),
  ),

  GetPage(
    name: Routes.eventDetailsScreenKclub,
    page: () => EventDetailsScreenKclub(),
  ),
  GetPage(
    name: Routes.eventDetailsScreenKclubPractice,
    page: () => EventDetailsScreenKclubPractice(),
  ),
  GetPage(
    name: Routes.eventDetailsScreenOther,
    page: () => EventDetailsScreenOther(),
  ),
  GetPage(
    name: Routes.eventDetailsScreenNew,
    page: () => EventDetailsScreenNew(),
  ),
  GetPage(
    name: Routes.bhogDetailsScreen,
    page: () => BhogDetailsScreen(),
  ),

  GetPage(
    name: Routes.hallDetailsScreen,
    page: () => HallDetailsScreen(),
  ),
  GetPage(
    name: Routes.bhogBookingScreen,
    page: () => BhogBookingScreen(),
  ),

  GetPage(
    name: Routes.tikitBookingScreen,
    page: () => TicketBookingScreen(),
  ),
  GetPage(
    name: Routes.tikitBookingScreenKclub,
    page: () => TicketBookingScreenKclub(),
  ),
  GetPage(
    name: Routes.tikitBookingScreenAdmin,
    page: () => TicketBookingScreenAdmin(),
  ),
  GetPage(
    name: Routes.tikitBookingHallScreen,
    page: () => TicketBookingHallScreen(),
  ),

  GetPage(
    name: Routes.tikitBookingHallScreenAdmin,
    page: () => TicketBookingHallScreenAdmin(),
  ),

  GetPage(
    name: Routes.tikitBookingHallScreenKclub,
    page: () => TicketBookingHallScreenKclub(),
  ),
  GetPage(
    name: Routes.clubDetailsScreen,
    page: () => ClubDetailsScreen(),
  ),
  GetPage(
    name: Routes.tikitDetailsScreen,
    page: () => TicketDetailsScreen(),
  ),
  GetPage(
    name: Routes.orderDetailsScreen,
    page: () => OrderDetailsScreen(),
  ),
  GetPage(
    name: Routes.otpScreen,
    page: () => OtpScreen(),
  ),

  GetPage(
    name: Routes.verifyOtpScreen,
    page: () => VerifyOtpScreen(),
  ),
  GetPage(
    name: Routes.bottoBarScreen,
    page: () => BottomBarScreen(),
  ),
  GetPage(
    name: Routes.resetPassword,
    page: () => ResetPasswordScreen(),
  ),
  GetPage(
    name: Routes.signUpScreen,
    page: () => SignUpScreen(),
  ),
  GetPage(
    name: Routes.editProfileScreen,
    page: () => ViewProfileScreen(),
  ),
  GetPage(
    name: Routes.loreamScreen,
    page: () => Loream(),
  ),
  GetPage(
    name: Routes.addWalletScreen,
    page: () => AddWalletScreen(),
  ),
  GetPage(
    name: Routes.walletScreen,
    page: () => WalletHistoryScreen(),
  ),
  GetPage(
    name: Routes.couponScreen,
    page: () => CouponScreen(),
  ),
  GetPage(
    name: Routes.catWiseEventScreen,
    page: () => CatWiseEvent(),
  ),
];
