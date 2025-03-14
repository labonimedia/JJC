// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class FontFamily {
  static const String gilroyBlack = "Gilroy Black";
  static const String gilroyLight = "Gilroy Light";
  static const String gilroyHeavy = "Gilroy Heavy";
  static const String gilroyMedium = "Gilroy Medium";
  static const String gilroyBold = "Gilroy Bold";
  static const String gilroyExtraBold = "Gilroy ExtraBold";
  static const String gilroyRegular = "Gilroy Regular";
}

class gradient {
  static const Gradient btnGradient = LinearGradient(
    colors: [Color(0xff1E20FF), Color(0xff0001A8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient redgradient = LinearGradient(
    colors: [Color(0xffFF6B6B), Color(0xffFF4747)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Gradient greenGradient = LinearGradient(
    colors: [Color(0xff5bd80e), Color.fromARGB(255, 100, 199, 64)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const Gradient lightGradient = LinearGradient(
    colors: [Color(0xffdaedfd), Color(0xffdaedfd)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  // static const Color defoultColor = Color(0xFF6F3DE9);
  static const Color defoultColor = Color(0xff1E20FF);
  static const Color defoultColor1 = Color(0xffFF6B6B);
}
