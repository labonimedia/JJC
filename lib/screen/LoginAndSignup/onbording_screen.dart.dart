// ignore_for_file: camel_case_types, use_key_in_widget_constructors, annotate_overrides, prefer_const_literals_to_create_immutables, file_names, unused_element, prefer_const_constructors, prefer_typing_uninitialized_variables, sort_child_properties_last

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/AddFamilyMemberScreen.dart';
import 'package:jjcentre/screen/LoginAndSignup/login_screen.dart';
import 'package:jjcentre/screen/LoginAndSignup/welcome_screen.dart';
import 'package:jjcentre/screen/bottombar_screen.dart';
import 'package:jjcentre/screen/language/language_check_screen.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../qr_scanner_screen.dart';
import '../welcomepagescreen.dart';



// ignore: unused_import
var lat=0.00;
var long=0.00;

class onBording extends StatefulWidget {

  const onBording({Key? key}) : super();

  @override
  State<onBording> createState() => _onbordingStatea();
}

class _onbordingStatea extends State<onBording>   with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    getCurrentLatAndLong();

    _controller = VideoPlayerController.asset("assets/jain.mp4") // Specify your video file
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

    _controller.setLooping(false);
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // Navigate to the next screen when the video ends
        /*Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => HomeScreen()),

        );*/
        setScreen();
      }
    });


  }
  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this); // Remove the observer when disposing
    super.dispose();
  }


  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getCurrentLatAndLong() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {}
    var currentLocation = await locateUser();
    setState(() {

      lat = currentLocation.latitude;
      long = currentLocation.longitude;

    });
  }

 /* setScreen() async {
    Timer(
      const Duration(seconds: 3),
      () => getData.read('Remember') != true
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                )
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Welcomepagescreen(),
                  ),
                ),
    );
  }*/
  setScreen() async {
    Timer(
      const Duration(seconds: 3),
          () {
        if (!mounted) return; // Check if the widget is still mounted
        var userData = getData.read("UserLogin");
      /*  if (getData.read('Remember') != true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LanguageCheckScreen(),
            ),
          );
        } else*/ if (userData != null && userData["volunteer"] == "1"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QRScannerScreen(),
            ),
          );
        }else if(getData.read("UserLogin") != null){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
            ),
          );
        }else{

          String? storedLangCode = box.read("lan2");
          String? storedCountryCode = box.read("lan1");

          if (storedLangCode != null && storedCountryCode != null) {
            // Language already set, update locale and navigate to LoginScreen
            Get.updateLocale(Locale(storedLangCode, storedCountryCode));
            Future.delayed(Duration(milliseconds: 500), () {
              Get.off(LoginScreen()); // Navigate to login screen
            });
          }else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LanguageCheckScreen(),
              ),
            );
          }
        }
      },
    );
  }

  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = ((prefs.getInt('counter') ?? 0) + 1);
      prefs.setInt('counter', _counter);
    });
  }

  int _counter = 0;

  @override
  /*Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage("assets/Splash.png"), fit: BoxFit.fill),
          gradient: gradient.redgradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Logo.png", height: 80, width: 80),
              SizedBox(
                height: 5,
              ),
              Text(
                "Aamibengali".tr,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 20,
                  color: WhiteColor,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Pause the video when the app is not active
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      // Resume the video when the app becomes active again
      if (!_controller.value.isPlaying) {
        _controller.play();
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Stack(
        fit: StackFit.expand, // Make the Stack fill the entire screen
        children: [
          FittedBox(
            fit: BoxFit.fill, // Ensures the video covers the entire screen
            child: SizedBox(
              width: _controller.value.size.width-5,
              height: _controller.value.size.height-5,
              child: VideoPlayer(_controller),
            ),
          ),
          // Optional: Add any overlay UI elements here, like a logo
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

}

class BoardingPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingPage> {
  // creating all the widget before making our home screeen

  void initState() {
    super.initState();

    _currentPage = 0;

    _slides = [
      Slide("assets/Onboarding1.png", provider.discover, provider.healthy),
      Slide("assets/Onboarding2.png", provider.order, provider.orderthe),
      Slide("assets/Onboarding3.png", provider.lets, provider.cooking),
    ];
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  int _currentPage = 0;
  List<Slide> _slides = [];
  PageController _pageController = PageController();

  // the list which contain the build slides
  List<Widget> _buildSlides() {
    return _slides.map(_buildSlide).toList();
  }

  Widget _buildSlide(Slide slide) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: WhiteColor,
      body: Column(
        children: <Widget>[
          // ignore: sized_box_for_whitespace
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.04), //upar thi jagiya mukeli che
          // ignore: sized_box_for_whitespace
          Container(
            height: MediaQuery.of(context).size.height * 0.55, //imagee size
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              slide.image,
              fit: BoxFit.cover,
            ),
            // color: BlackColor,
          ),
          Column(
            children: [
              SizedBox(height: Get.height * 0.1),
              SizedBox(
                width: Get.width * 0.70,
                child: Text(
                  slide.heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 21,
                      fontFamily: "Gilroy Bold",
                      color: BlackColor), //heding Text
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              SizedBox(
                width: Get.width * 0.70,
                child: Text(
                  slide.subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: greycolor,
                      fontFamily: "Gilroy Medium"), //subtext
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // handling the on page changed
  void _handlingOnPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  // building page indicator
  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1)
        // ignore: curly_braces_in_flow_control_structures
        row.children.add(const SizedBox(
          width: 10,
        ));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 12 : 8,
      height: index == _currentPage ? 12 : 8,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == _currentPage ? gradient.defoultColor : greycolor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: WhiteColor,
      body: Stack(
        children: <Widget>[
          Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: _handlingOnPageChanged,
                physics: const BouncingScrollPhysics(),
                children: _buildSlides(),
              ),
              Positioned(
                top: 4,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    // Get.toNamed(Routes.loginScreen);
                    Get.to(LoginScreen());
                    save('isLoginBack', false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 40),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Get.to(LoginScreen());
                        },
                        child: Text(
                          provider.skip,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Gilroy Bold",
                            color: gradient.defoultColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 15,
            child: Column(
              children: <Widget>[
                _buildPageIndicator(),
                SizedBox(
                  height: Get.height * 0.22, //indicator set screen
                ),
                _currentPage == 2
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            // Get.toNamed(Routes.loginScreen);
                            Get.to(LoginScreen());
                            save('isLoginBack', false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: gradient.btnGradient,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                provider.getstart,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: WhiteColor,
                                    fontFamily: "Gilroy Bold"),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            _pageController.nextPage(
                                duration: const Duration(microseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: gradient.btnGradient,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                provider.next,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: WhiteColor,
                                    fontFamily: "Gilroy Bold"),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: Get.height * 0.012, //indicator set screen
                ),
                const SizedBox(height: 20)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Slide {
  String image;
  String heading;
  String subtext;

  Slide(this.image, this.heading, this.subtext);
}

// class BoardingPage extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _BoardingPageState createState() => _BoardingPageState();
// }

// class _BoardingPageState extends State<BoardingPage> {
//   // creating all the widget before making our home screeen
//   // SubscribeController subscribeController = Get.find();
//   // ListOfPropertiController listOfPropertiController = Get.find();

//   void initState() {
//     // getdarkmodepreviousstate();
//     super.initState();

//     _currentPage = 0;

//     _slides = [
//       Slide("assets/introimg.png", "The leading job board for Blockchain jobs",
//           "Curates the best new blockchain jobs at leading companies that use blockchain technology"),
//       Slide("assets/introimg1.png", "Show your skills be an innovator",
//           "Seize the moment and help shape the future by starting a career in blockchain now"),
//       Slide("assets/introimg2.png", "Show your skills be an innovator",
//           "Seize the moment and help shape the future by starting a career in blockchain now"),
//     ];
//     _pageController = PageController(initialPage: _currentPage);
//     super.initState();
//   }

//   int _currentPage = 0;
//   List<Slide> _slides = [];
//   PageController _pageController = PageController();

//   // the list which contain the build slides
//   List<Widget> _buildSlides() {
//     return _slides.map(_buildSlide).toList();
//   }

//   // late ColorNotifire notifire;

//   Widget _buildSlide(Slide slide) {
//     // notifire = Provider.of<ColorNotifire>(context, listen: true);
//     return Scaffold(
//       backgroundColor: WhiteColor,
//       body: Column(
//         children: <Widget>[
//           SizedBox(
//               height: MediaQuery.of(context).size.height *
//                   0.09), //upar thi jagiya mukeli che
//           // ignore: sized_box_for_whitespace
//           Container(
//             height: MediaQuery.of(context).size.height * 0.5, //imagee size
//             width: MediaQuery.of(context).size.width,
//             alignment: Alignment.topRight,
//             child: Image.asset(
//               slide.image,
//               fit: BoxFit.cover,
//             ),
//             // color: BlackColor,
//           ),
//           // SizedBox(
//           //   height: MediaQuery.of(context).size.height * 0.02,
//           // ),
//           SizedBox(
//             width: Get.width * 0.75,
//             child: Text(
//               slide.heading,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontSize: 24,
//                   fontFamily: "Gilroy Bold",
//                   color: BlackColor), //heding Text
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           SizedBox(
//             width: Get.width * 0.79,
//             child: Text(
//               slide.subtext,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontSize: 15,
//                   color: greycolor,
//                   fontFamily: "Gilroy Medium"), //subtext
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // handling the on page changed
//   void _handlingOnPageChanged(int page) {
//     setState(() => _currentPage = page);
//   }

//   // building page indicator
//   Widget _buildPageIndicator() {
//     Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
//     for (int i = 0; i < _slides.length; i++) {
//       row.children.add(_buildPageIndicatorItem(i));
//       if (i != _slides.length - 1)
//         // ignore: curly_braces_in_flow_control_structures
//         row.children.add(
//           const SizedBox(
//             width: 10,
//           ),
//         );
//     }
//     return row;
//   }

//   Widget _buildPageIndicatorItem(int index) {
//     return Container(
//       width: index == _currentPage ? 25 : 25,
//       height: index == _currentPage ? 6 : 6,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: index == _currentPage ? appcolor : greycolor.withOpacity(0.5)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: WhiteColor,
//       body: Stack(
//         children: <Widget>[
//           PageView(
//             controller: _pageController,
//             onPageChanged: _handlingOnPageChanged,
//             physics: const BouncingScrollPhysics(),
//             children: _buildSlides(),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 60,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height *
//                       0.28, //indicator set screen
//                 ),
//                 _currentPage == 2
//                     ? GestureDetector(
//                         onTap: () {
//                           Get.to(() => const LoginScreen());
//                           // listOfPropertiController.getPropertiList();
//                           // subscribeController.getSubscribeDetailsList();
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 15),
//                           decoration: BoxDecoration(
//                               gradient: gradient.btnGradient,
//                               borderRadius: BorderRadius.circular(15)),
//                           height: 50,
//                           width: double.infinity,
//                           child: Center(
//                             child: Text(
//                               "Get Started".tr,
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   color: WhiteColor,
//                                   fontFamily: "Gilroy Bold"),
//                             ),
//                           ),
//                         ),
//                       )
//                     : GestureDetector(
//                         onTap: () {
//                           _pageController.nextPage(
//                               duration: const Duration(microseconds: 300),
//                               curve: Curves.easeIn);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 15),
//                           decoration: BoxDecoration(
//                               gradient: gradient.btnGradient,
//                               borderRadius: BorderRadius.circular(15)),
//                           height: 50,
//                           width: double.infinity,
//                           child: Center(
//                             child: Text(
//                               "Next".tr,
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   color: WhiteColor,
//                                   fontFamily: "Gilroy Bold"),
//                             ),
//                           ),
//                         ),
//                       ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height *
//                       0.03, //indicator set screen
//                 ),
//                 // GestureDetector(
//                 //   onTap: () {},
//                 //   child: Text(
//                 //     "Skip",
//                 //     style: TextStyle(
//                 //       fontSize: 18,
//                 //       color: Darkblue,
//                 //       fontFamily: "Gilroy Bold",
//                 //     ),
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 20)
//                 _buildPageIndicator(),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

// //   getdarkmodepreviousstate() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     bool? previusstate = prefs.getBool("setIsDark");
// //     if (previusstate == null) {
// //       notifire.setIsDark = false;
// //     } else {
// //       notifire.setIsDark = previusstate;
// //     }
// //   }
// }
