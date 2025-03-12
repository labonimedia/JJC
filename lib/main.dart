 // ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/screen/language/local_string.dart';
import 'package:jjcentre/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpar/get_di.dart' as di;

final navigatorKey = GlobalKey<NavigatorState>();

// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received in background...");
  }
}

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
    ),
  );
}

void saveNotification(String title, String message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the existing notification list
  List<String>? notifications = prefs.getStringList('notifications');

  // If there are no saved notifications, initialize the list
  if (notifications == null) {
    notifications = [];
  }
  /*String getCurrentTime() {
    return DateTime.now().toLocal().toString().split('.')[0]; // HH:mm:ss
  }*/
 // String currentTime=getCurrentTime();
  String formattedDateTime = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
  // Add the new notification to the start of the list
  notifications.insert(0, '$title: $message: $formattedDateTime');

  // Save the updated list
  await prefs.setStringList('notifications', notifications);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await GetStorage.init();
  await Firebase.initializeApp();
  // initialize firebase messaging
   await PushNotifications.init();
  await PushNotifications.getDeviceToken();

  // initialize local notifications
  // dont use local notifications for web platform
  if (!kIsWeb) {
    await PushNotifications.localNotiInit();
  }

  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)  {
    if (message.notification != null) {
      print("Background Notification Tapped");
      //navigatorKey.currentState!.pushNamed("/message", arguments: message);

      Get.toNamed(Routes.message, arguments: message);
      }

  });

// to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {

      if (kIsWeb) {
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
      } else {
        final String title = message.notification?.title ?? 'No Title';
        final String body = message.notification?.body ?? 'No Message';


        // Save notification to local storage
        saveNotification(title, body);

        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    }
  });



  // for handling in terminated state
  final RemoteMessage? message =
  await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      //navigatorKey.currentState!.pushNamed("/message", arguments: message);
      Get.toNamed(Routes.message, arguments: message);
    });
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Gilroy",
      ),
      translations: LocaleString(),
      locale: getData.read("lan2") != null
          ? Locale(getData.read("lan2"), getData.read("lan1"))
          : Locale('en', 'US'),
      // Adjust locale syntax here
      fallbackLocale: Locale('en', 'US'),
      // Set a fallbackLocale to ensure a locale is always available
      initialRoute: Routes.initial,
      getPages: getPages,
    ),
  );
}
