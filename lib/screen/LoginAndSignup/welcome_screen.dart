import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For navigation
import 'package:jjcentre/screen/bottombar_screen.dart';
import '../../Api/config.dart';
import '../../Api/data_store.dart';
import '../welcomepagescreen.dart';
 // Next screen after Welcome

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String clubName = "";
  @override
  void initState() {
    super.initState();
    getData.read("UserLogin") != null
        ? setState(() {
      clubName = getData.read("clublist")["title"] != "Jain Jagruti Centre"? getData.read("clublist")["title"] ?? "" : "";
    }): clubName="";
    // Automatically navigate to HomeScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => BottomBarScreen()); // Navigate without back button
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/jjc_centername.png', // Change this to your image path
            fit: BoxFit.cover,
          ),

          // Overlay with Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Jain Jagruti Centre",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                SizedBox(height: 10),
                getData.read("clublist")["logoimg"] !=null ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    // This will center the Image inside its available space//${Config.imageUrl}
                    child: Image.network(
                      "${Config.imageUrl}${getData.read("clublist")["logoimg"]}",
                      width: 150,
                    ),
                  ),
                ):SizedBox(),

                Text(
                  clubName,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
