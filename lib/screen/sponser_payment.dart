// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, sort_child_properties_last


import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jjcentre/Api/data_store.dart';
import 'package:jjcentre/controller/login_controller.dart';
import 'package:jjcentre/controller/signup_controller.dart';
import 'package:jjcentre/helpar/routes_helpar.dart';
import 'package:jjcentre/model/fontfamily_model.dart';
import 'package:jjcentre/screen/AddFamilyMemberScreen.dart';
import 'package:jjcentre/screen/LoginAndSignup/login_screen.dart';
import 'package:jjcentre/utils/Colors.dart';
import 'package:jjcentre/utils/Custom_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Api/config.dart';
import 'bottombar_screen.dart';

class SponserPaymentScreen extends StatefulWidget {
  @override
  _PayMembershipFeeState createState() => _PayMembershipFeeState();
}

class _PayMembershipFeeState extends State<SponserPaymentScreen> {
  SignUpController signUpController = Get.find();
  LoginController loginController=Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cuntryCode = "";
  File? paymentImage;
  File? reconciliationImage;
  String? path,path1=null;
  String? networkimage,networkimage1,networkimage2;
  String? base64Image;
  bool _isVisible = true;
  String? clubQr;
  bool _istextVisible = false;
  bool isPaid =false;
  String eventId = Get.arguments["eventId"];
  String description = Get.arguments["description"];
  String amount = Get.arguments["amount"];
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  String? _selectedTransactionMode;
  TextEditingController tansactionNo= new TextEditingController();
  final List<Map<String, String>> _transactionModes = [

    {"key": "upi", "label": "UPI"},
    {"key": "netbanking", "label": "Netbanking"},
    {"key": "debit-card", "label": "Debit Card"},
    {"key": "credit-card", "label": "Credit Card"},
    {"key": "cheque", "label": "Cheque"}
  ];
  @override
  void initState() {
    super.initState();
    networkimage1= "";

    getData.read("UserLogin") != null
        ? setState(() {

      clubQr = getData.read("clublist")["clubqr"] ?? "";

    })
        : clubQr = "";
   if((getData.read("UserLogin")["membership_photo"] ?? "")== ""){
     // _isVisible = true;
      ///_istextVisible=false;
      networkimage1= "";
      print("in null");

    }else{

      setState(() {
        //networkimage1 = Config.imageUrl + (getData.read("UserLogin")["membership_photo"] ?? "");
      //  _isVisible = !_isVisible;
      //  _istextVisible=true;
      });

      print("out of null");
    }

    if((getData.read("UserLogin")["reconciliation_status"] )== "paid"){

      isPaid= true;

    }


  }



  /*Future<void> requestPermission() async {
    if (await Permission.manageExternalStorage.isDenied) {
      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        print('Manage External Storage permission granted');
      } else {
        print('Manage External Storage permission denied');
      }
    }
  }*/



 /* Future<void> downloadImage(String imageUrl) async {
    try {
      // Request permission to access storage
      await requestPermission();
      var status = await Permission.storage.request();
      Dio dio = Dio();
      if (status.isGranted) {
        // Use path_provider to get the download directory
        Directory? downloadDir = await getExternalStorageDirectory();

        if (downloadDir != null) {
          String savePath = '${downloadDir.path}/downloaded_image.jpg';

          // Download the image data from the URL
          var response = await dio.get(imageUrl,
              options: Options(responseType: ResponseType.bytes));

          // Save the image using ImageGallerySaver
          final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            name: "downloaded_image",
          );

          if (result != null) {
            print('Image saved successfully to gallery');
          } else {
            print('Failed to save the image');
          }
        } else {
          print('Could not access external storage directory');
        }
      } else {
        print('Storage permission denied');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }*/

 /* Future<void> downloadImage(String imageUrl) async {
    try {
      // Request storage permission
      await requestPermission();

      // Get the application documents directory
      Directory? downloadDir = Directory('/storage/emulated/0/Download');

      if (!await downloadDir.exists()) {
        downloadDir = await getExternalStorageDirectory();
      }

      String savePath = '${downloadDir!.path}/downloaded_image.jpg'; // Modify file name and extension as needed

      // Use Dio to download the image
      Dio dio = Dio();
      await dio.download(imageUrl, savePath);

      showToastMessage('QR Code downloaded to Download folder');

    } catch (e) {
      showToastMessage('Error downloading image: $e');
    }
  }*/




  Future<void> pickImage(ImageSource source, bool isPaymentImage) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);


    if (pickedFile != null) {
      path = pickedFile.path;

      File imageFile = File(path.toString());
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      //loginController.addPaymentImage(base64Image);


      setState(() {

        path1 = pickedFile.path;
        paymentImage = File(pickedFile.path);
        //signUpController.uploadImage(image,'pay_image');


      });
    }

    /* if (image != null) {
      setState(() {
        if (isPaymentImage) {
          paymentImage = File(image.path);
          signUpController.uploadImage(image,'pay_image');
        } else {
          reconciliationImage = File(image.path);
          signUpController.uploadImage(image,'rec_image');
        }

      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: transparent,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/app_bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: Get.height * 0.30,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.03),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(13),
                          margin: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/back.png',
                            color: WhiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF000000).withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      /*SizedBox(
                        width: Get.width * 0.25,
                      ),*/
                      /* Text(
                        "Membership Status".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 17,
                          color: WhiteColor,
                        ),
                      ),*/


                      Spacer(),
                    ],
                  ),
                  /*   SizedBox(
                    height: Get.size.height * 0.025,
                  ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyMedium,
                          fontSize: 15,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(LoginScreen());
                        },
                        child: Text(
                          " Login Now",
                          style: TextStyle(
                            color: Color(0xFFFBBC04),
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.size.height * 0.04,
                  )
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Image.asset(
                      "assets/Rectangle326.png",
                      height: 25,
                    ),
                  ),,*/
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Sponsor's".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Gilroy Bold",
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),

            ),
            Positioned(
              top: Get.height * 0.22,
              child: Container(
                height: Get.height * 0.8,
                width: Get.size.width,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child:Text(
                            "Thank you for sponsoring: "+description ,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: "Gilroy Bold",
                              fontSize: 16,
                            ),
                          ),
                        ),
                     /*   Visibility(
                          visible: isPaid,
                          child:
                          Text(
                            "Durga Puja updates will be available soon.",
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: "Gilroy Bold",
                              fontSize: 16,
                            ),
                          ),
                        ),*/
                        SizedBox(
                          height: 10,
                        ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                        child:TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter amount',
                            hintText: 'Enter amount',
                          ),
                          onChanged: (text) {
                            setState(() {
                             // _inputText = text;
                              _errorText = _validateInput(text);
                            });
                          },
                          onSubmitted: (text) {
                            print('Submitted text: $text');
                          },
                        ),

                    ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Kindly Pay by scanning below QR code" ,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Bold",
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        clubQr != ""
                            ?
                        Image.network(
                          "${Config.imageUrl}${clubQr ?? ""}",
                          width: 200,
                          height: 200,
                        ):SizedBox(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "UPI QR Code" ,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Bold",
                            fontSize: 14,
                          ),
                        ),
                       /* clubQr != "" ?
                        GestureDetector(
                          onTap: () => downloadImage("${Config.imageUrl}${clubQr ?? ""}"),
                          child: Text(
                            'Click to download',
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ):Text(
                          "UPI QR Code is not avaialbe" ,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Bold",
                            fontSize: 14,
                          ),
                        ),*/
                        SizedBox(
                          height: 60,
                        ),Text(
                          "If paid kindly upload/share image of Cheque / UPI \nTransaction Image and Transaction details." ,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Bold",
                            fontSize: 14,
                          ),
                        ),
                        /*  Text(
                          "Create your free account in seconds".tr,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Medium",
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),*/
                        /*Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["membership_status"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              *//* prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/Profile.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              ),*//*
                              labelText: "Membership Status".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["membership_date"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "Date".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["reconciliation_status"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              *//* prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/Profile.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              ),*//*
                              labelText: "Reconciliation Status".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            initialValue: getData.read("UserLogin")["reconciliation_date"],
                            enabled: false,
                            cursorColor: BlackColor,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              labelText: "Date".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                          ),
                        ),*/

                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width,
                                // Ensures the dropdown takes up available space
                                child: DropdownButtonFormField<String>(
                                  hint: Text('Select Transaction Mode'),
                                  value: _selectedTransactionMode,
                                  items: _transactionModes.map((mode) {
                                    return DropdownMenuItem<String>(
                                      value: mode['key'],
                                      // Key is used as the value
                                      child: Text(mode[
                                      'label']!), // Label is shown in the dropdown
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTransactionMode = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    /*prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(Icons.account_box,
                                          color: Colors.grey),
                                    ),*/
                                    labelText: "Transaction Mode",
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Gilroy',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: tansactionNo,
                            cursorColor: BlackColor,

                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            keyboardType: TextInputType.number, // Show numeric keyboard
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                            ],
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              /*   prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/Calendar.png",
                                  height: 10,
                                  width: 10,
                                  color: greycolor,
                                ),
                              ),*/
                              labelText: "Transaction ID".tr,
                              labelStyle: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter transaction id'.tr;
                              }else if( value.length>5  || value.length<5){
                                return 'Please enter last 5 digit of transaction id'.tr;
                              }
                              return null;
                            },
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),child:
                        Text(
                          "Enter last 5 digits of transaction id to verify your transaction.",
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: "Gilroy Bold",
                            fontSize: 14,
                          ),
                        ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Other form fields for family members...

                              SizedBox(height: 20),
                              /* Text('Payment Image'),*/
                              Row( mainAxisAlignment: MainAxisAlignment.center,

                                children: [

                                  Visibility(
                                    visible: _isVisible,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          pickImage(ImageSource.gallery, true),
                                      child: Text('Choose File'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: path1 == null
                                        ? networkimage1 != ""
                                        ?  Image.network(
                                      "${networkimage1 ?? ""}",
                                      fit: BoxFit.contain,

                                    )
                                        :  Center(
                                        child:Text('No file chosen') )
                                        : paymentImage != null
                                        ? Image.file(paymentImage!,
                                      fit: BoxFit.contain,)
                                        : Text('No file chosen'),

                                  ),
                                  /* paymentImage != null
                                      ? Image.file(paymentImage!,
                                          width: 100, height: 100)
                                      : Text('No file chosen'),*/
                                ],
                              ),

                              SizedBox(height: 20),
                              SizedBox(
                                height: 20,
                              ),

                              Visibility(
                                visible: _istextVisible,
                                child: Text(
                                  "Thank you for sharing your payment details. Our team will verify and update your sponsorship details." ,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily: "Gilroy Bold",
                                    fontSize: 14,

                                  ),
                                ),
                              ),



                              /*    Text('Reconciliation Image'),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        pickImage(ImageSource.gallery, false),
                                    child: Text('Choose File'),
                                  ),
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: path2 == null
                                        ? networkimage2 != ""
                                        ?  Image.network(
                                      "${networkimage2 ?? ""}",
                                      fit: BoxFit.cover,

                                    )
                                        :  Image.asset(
                                      "assets/profile-default.png",
                                      fit: BoxFit.cover,

                                    )
                                        : reconciliationImage != null
                                        ? Image.file(reconciliationImage!,
                                        width: 100, height: 100)
                                        : Text('No file chosen'),

                                  ),

                                ],
                              ),*/
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: _isVisible,
                          child: GestButton(
                            Width: Get.size.width,
                            height: 50,
                            buttoncolor: RedColor1,
                            margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                            buttontext: "Submit".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: WhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            onclick: () {
                              final amountText = _controller.text;
                              final transactionID = tansactionNo.text;

                              if(amountText.isEmpty) {
                                showToastMessage(
                                    "Please enter amount".tr);

                              }else if(_selectedTransactionMode == null) {
                                showToastMessage(
                                    "Please select Transaction Mode".tr);
                              }else if(transactionID.length > 5 || transactionID.length < 5) {
                                showToastMessage(
                                    "Please enter last 5 digit of transaction id".tr);
                              }else if (base64Image == null) {
                                showToastMessage("Please select image".tr);
                              }else{
                                loginController.addSponsorPaymentImage(
                                    base64Image, "pay_image", _controller.text,
                                    description,_selectedTransactionMode!,tansactionNo.text);
                                 setState(() {
                                _isVisible = !_isVisible;
                                _istextVisible=true;
                              });
                              }
                              //loginController.addPaymentImage(base64Image,"pay_image");
                              /* if(getData.read("UserLogin")["membership_status"] == 'paid')
                                  {
                                    Get.offAll(BottomBarScreen());
                                  }else {
                                  showToastMessage(
                                      "Your membership fee is not paid yet. Kindly contact admin !".tr);
                                }
*/
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: WhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? _validateInput(String text) {
    if (text.isEmpty) {
      return 'This field cannot be empty';
    }
    if (int.tryParse(text) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}
