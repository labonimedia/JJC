// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jjcentre/controller/notification_controller.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // Load notifications from SharedPreferences
  Future<void> _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  // Show confirmation dialog before deleting a notification
  Future<void> _confirmDeleteNotification(int index) async {
    bool confirm = await _showConfirmationDialog(
      title: "Delete Notification?",
      content: "Are you sure you want to delete this notification?",
    );
    if (confirm) {
      _deleteNotification(index);
    }
  }

  // Show confirmation dialog before clearing all notifications
  Future<void> _confirmClearAllNotifications() async {
    bool confirm = await _showConfirmationDialog(
      title: "Clear All Notifications?",
      content: "This will remove all notifications. Are you sure?",
    );
    if (confirm) {
      _clearAllNotifications();
    }
  }

  // Delete a single notification
  Future<void> _deleteNotification(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications.removeAt(index);
      prefs.setStringList('notifications', notifications);
    });
  }

  // Clear all notifications
  Future<void> _clearAllNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications.clear();
      prefs.remove('notifications');
    });
  }

  // Show a confirmation dialog
  Future<bool> _showConfirmationDialog({required String title, required String content}) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false; // Default to false if dismissed
  }

  // Refresh function
  Future<void> _onRefresh() async {
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: _confirmClearAllNotifications, // Ask before clearing all
              tooltip: "Clear All",
            ),
        ],
      ),

      body: RefreshIndicator(
      onRefresh: _onRefresh,
    child: notifications.isEmpty
          ? Center(
        child: Text(
          "No notifications found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          List<String> parts = notifications[index].split(': ');
          String title = parts[0];
          String message = parts.length > 1 ? parts[1] : "";
          String time = parts.length > 2 ? parts[2] : "";

          return Dismissible(
            key: Key(notifications[index]),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) => _showConfirmationDialog(
              title: "Delete Notification?",
              content: "Are you sure you want to delete this notification?",
            ),
            onDismissed: (direction) {
              _deleteNotification(index);
            },
            child: Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.notifications_active, color: Colors.blue),
                title: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
    );
  }
}

/*class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: BlackColor,
          ),
        ),
        title: Text(
          "Notification".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<NotificationController>(builder: (context) {
        return Column(
          children: [
            Expanded(
              child: notificationController.isLoading
                  ? notificationController
                          .notificationInfo!.notificationData.isNotEmpty
                      ? ListView.builder(
                          itemCount: notificationController
                              .notificationInfo?.notificationData.length,
                          itemBuilder: (context, index) {
                            String time =
                                "${DateFormat.jm().format(DateTime.parse("2023-03-20T${notificationController.notificationInfo?.notificationData[index].datetime.toString().split(" ").last}"))}";
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  padding: EdgeInsets.all(15),
                                  child: Image.asset(
                                    "assets/Notification1.png",
                                    color: gradient.defoultColor,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFeef4ff),
                                  ),
                                ),
                                title: Text(
                                  notificationController.notificationInfo
                                          ?.notificationData[index].title ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: FontFamily.gilroyBold,
                                    color: BlackColor,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      notificationController.notificationInfo
                                              ?.notificationData[index].datetime
                                              .toString()
                                              .split(" ")
                                              .first ??
                                          "",
                                      style: TextStyle(
                                        color: greytext,
                                        fontFamily: FontFamily.gilroyMedium,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      time,
                                      style: TextStyle(
                                        color: greytext,
                                        fontFamily: FontFamily.gilroyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 30),
                              //   child: Image.asset(
                              //     "assets/images/bookingEmpty.png",
                              //     height: 120,
                              //     width: 120,
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "We'll let you know when we\nget news for you"
                                    .tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: greytext,
                                  fontFamily: FontFamily.gilroyBold,
                                ),
                              )
                            ],
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(
                        color: gradient.defoultColor,
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}*/
