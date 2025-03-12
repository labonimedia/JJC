import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



import '../LoginAndSignup/login_screen.dart';  // Assume you have a Colors utility file

class LanguageCheckScreen extends StatefulWidget {
  @override
  State<LanguageCheckScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageCheckScreen> {
  int? _selectedIndex;
  final box = GetStorage();

  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'ગુજરાતી', 'locale': const Locale('gu', 'IN')},
    {'name': 'हिंदी', 'locale': const Locale('hi', 'IN')},
  ];

  void updateLanguage(Locale locale, int index) {
    setState(() {
      _selectedIndex = index;
    });
    box.write("lan1", locale.countryCode);
    box.write("lan2", locale.languageCode);
    Get.updateLocale(locale);
    Future.delayed(Duration(milliseconds: 500), () {
      Get.off(LoginScreen()); // Navigate to Login after selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Select Your Language", style: TextStyle(fontFamily: 'GilroyBold', fontSize: 18,color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),*/
      appBar: AppBar(title: Text("Select Your Language")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Choose Your Language",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'GilroyBold',
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ...List.generate(locale.length, (index) {
                    return GestureDetector(
                      onTap: () => updateLanguage(locale[index]['locale'], index),
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          title: Text(
                            locale[index]['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'GilroyMedium',
                              color: Colors.black,
                            ),
                          ),
                          leading: Radio(
                            value: index,
                            groupValue: _selectedIndex,
                            onChanged: (value) => updateLanguage(locale[index]['locale'], index),
                            activeColor: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedIndex != null) {
                        Get.off(LoginScreen());
                      } else {
                        // Show a Snackbar or Alert if no language is selected
                        Get.snackbar("Select a Language", "Please select a language to proceed.",
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'GilroyBold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
