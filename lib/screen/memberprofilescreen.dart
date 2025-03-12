import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jjcentre/screen/profile/editprofile_screen.dart';
import 'package:jjcentre/screen/welcomepagescreen.dart';
import 'package:jjcentre/screen/pay_membership_fee.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller/login_controller.dart';
import '../helpar/routes_helpar.dart';
import '../model/fontfamily_model.dart';
import '../utils/Colors.dart';
import '../utils/Custom_widget.dart';

class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen({super.key});

  @override
  State<MemberProfileScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginController loginController = Get.find();
  File? paymentImage;
  List<Map<String, dynamic>> familyMembers = [];
  List<FocusNode> focusNodes = [];
  String? path, path1, path2;
  String? networkimage;
  String? base64Image;
  String cuntryCode = "";
  String userName = "";
  bool isPaid =false;
  String maxmember= "";
  bool isLoading = true; // Loading flag
  bool hasError = false;

  @override
  void initState() {
    super.initState();



    getData.read("UserLogin") != null
        ? setState(() {
      userName = getData.read("UserLogin")["name"] ?? "";
      networkimage = getData.read("UserLogin")["pro_pic"] ?? "";
      if (getData.read("UserLogin")["pro_pic"] != "null") {
        networkimageconvert();
      }
      if((getData.read("UserLogin")["membership_status"]) == "pending"){
        isPaid= true;
      }

    }) : null;

    getData.read("Memberlimit") != null
        ? setState(() {
      maxmember= getData.read("Memberlimit")["maxmember"] ?? "0";


    }):null;

   print(maxmember);

    _loadFamilyMembers();
  }

  Future<void> _loadFamilyMembers() async {




    try {
      List<Map<String, dynamic>> fetchedData = await loginController.fetchFamilyMembers();
      setState(() {
        familyMembers = fetchedData;
        for (int i = 0; i < familyMembers.length; i++) {
          focusNodes.add(FocusNode());
        }
        isLoading = false; // Data loaded successfully, stop loading
      });
    } catch (error) {
      setState(() {
        hasError = true; // An error occurred while loading data
        isLoading = false;
      });
    }

  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  void _addNewMember() {
    int maxlimit=0;

    maxlimit= int.parse(maxmember!);
    if (familyMembers.length < maxlimit-1) {
      setState(() {
        FocusNode newFocusNode = FocusNode();
        focusNodes.add(newFocusNode);
        familyMembers.add({
          'name': '',
          'gender': 'Male',
          'age': '',
          'relationship': 'Self',
          'profession': '',
        });
        newFocusNode.requestFocus();
      });
    } else {
      // Show a message indicating the limit has been reached
      Get.snackbar(
        "Limit Reached",
        "You can only add up to ${maxlimit-1} family members.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
    }
  }

  networkimageconvert() {
    (() async {
      http.Response response = await http.get(Uri.parse(Config.imageUrl + networkimage.toString()));
      if (mounted) {
        setState(() {
          base64Image = const Base64Encoder().convert(response.bodyBytes);
        });
      }
    })();
  }

  Future<void> pickImage(ImageSource source, bool isPaymentImage) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      path = pickedFile.path;

      File imageFile = File(path.toString());
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);

      setState(() {
        path1 = pickedFile.path;
        paymentImage = File(pickedFile.path);
      });
    }
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Container(

          height: Get.height,
          decoration: BoxDecoration(
            /*image: DecorationImage(
              image: AssetImage('assets/app_bg.png'),
              fit: BoxFit.cover,
            ),*/
            color: Colors.pinkAccent
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: Get.height * 0.30,
                  width: double.infinity,


                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          Spacer(),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Profile".tr,
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
              ),
              Positioned(
                top: Get.height * 0.22,
                left: 0,
                right: 0,
                child: Container(
                  //color: Colors.green,
                  height: Get.height * 0.8,
                  width: Get.size.width,
                  child:Form(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Registered Member".tr,
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontFamily: "Gilroy Bold",
                            fontSize: 22,
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        SizedBox(height: 10),
                        Stack(
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
                            /*Positioned(
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
                            ),*/
                          ],
                        ),

                        /*ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Darkblue,

                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                           Get.to(ViewProfileScreen());
                          },
                          child: Center(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                          ),
                        ),
                        GestButton(
                          Width: Get.size.width,
                          height: 50,
                          buttoncolor: gradient.defoultColor,
                          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                          buttontext: "Update".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: WhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          onclick: () {
                            Get.to(ViewProfileScreen());
                          },
                        ),*/

                       Padding(padding: EdgeInsets.only(right: 16),child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,

                         children: [
                           Text(
                             "",
                             style: TextStyle(fontSize: 18),
                           ),
                           ElevatedButton(
                             onPressed: () {
                               // Handle Edit button press

                               Get.to(ViewProfileScreen());
                             },
                             child: Text("Edit Profile".tr,style: TextStyle(color: Colors.white)) ,
                             style: ElevatedButton.styleFrom(
                               padding: EdgeInsets.symmetric(horizontal: 20),
                               backgroundColor: Colors.pinkAccent,
                               textStyle: TextStyle(fontWeight: FontWeight.bold),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8),
                               ),
                             ),
                           ),
                         ],
                       ),),

                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Name', userName),
                              _buildDetailRow('Gender', getData.read("UserLogin")["gender"] ?? ""),
                              _buildDetailRow('Age', getData.read("UserLogin")["age"] ?? ""),
                              _buildDetailRow('Mobile Number', getData.read("UserLogin")["mobile"] ?? ""),
                              _buildDetailRow('Email', getData.read("UserLogin")["email"] ?? ""),
                              _buildDetailRow('Profession', getData.read("UserLogin")["profession"] ?? ""),
                              _buildDetailRow('Centre volunteer/ Participation',  getData.read("UserLogin")["volunteer1"] ?? ""),
                              _buildDetailRow('Membership fee ', getData.read("UserLogin")["reconciliation_status"] ?? ""),
                              Visibility(
                                visible: isPaid,
                                child: Container(

                                  padding: EdgeInsets.all(16),
                                child:
                                ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent,
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(PayMembershipFeeScreen());
                                  },
                                  child: Center(
                                    child: Text(
                                      'Pay Now',
                                      style: TextStyle(fontSize: 18,color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "As a registered member, you can add up to ${int.parse(maxmember)-1} family members (excl. Registered Member) to the club.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Family Members".tr,
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Divider(color: Colors.black),

                              isLoading
                                  ? Center(
                                  child:
                                  CircularProgressIndicator()) // Show loading indicator
                                  : hasError
                                  ? Center(
                                  child: Text(
                                      'Failed to load data. Try again.')) // Show error message
                                  : familyMembers.isEmpty
                                  ? Center(
                                  child: Text(
                                      'No data available.Please check your internet connection.')) // Handle empty data case
                                  :
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: familyMembers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildFamilyMemberTile(index);
                                },
                              ),

                              IconButton(
                                icon: Icon(Icons.add_circle, color: Colors.pinkAccent),
                                onPressed: () {
                                  _addNewMember();

                                },
                              ),
                              Divider(color: Colors.black),

                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent,
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    loginController.addMemberApiData(familyMembers);
                                  },
                                  child: Center(
                                    child: Text(
                                      'Save'.tr,
                                      style: TextStyle(fontSize: 18,color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 120),

                            ],
                          ),
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

              ),



            ],

          ),
        ),
       /* bottomNavigationBar: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/app_bg.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            // BottomAppBar with buttons
            BottomAppBar(
              height: 70,
              color: Colors.transparent, // Make the BottomAppBar transparent
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      // Add your back button functionality here
                      Get.back();
                    },
                  ),

                ],
              ),
            ),
          ],
        ),*/
      );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$title:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberTile(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          familyMembers[index]['name'] ?? 'Member ${index + 1}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Tap to expand'),
        leading: Icon(Icons.person),
        childrenPadding: EdgeInsets.all(8.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            focusNode: focusNodes[index],
            onChanged: (value) {
              familyMembers[index]['name'] = value;
            },
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            initialValue: familyMembers[index]['name'],
          ),
          SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            value: familyMembers[index]['gender'],
            items: ['Male', 'Female', 'Other']
                .map((String gender) => DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            ))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                familyMembers[index]['gender'] = newValue ?? 'Male';
              });
            },
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) {
              familyMembers[index]['age'] = value;
            },
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            initialValue: familyMembers[index]['age'],
          ),
          SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            value: familyMembers[index]['relationship'],
            items: [
              'Self', 'Spouse', 'Son', 'Daughter', 'Father', 'Mother',
              'GrandParent', 'GrandChild', 'Uncle', 'Aunt', 'Nephew',
              'Niece', 'Cousin', 'Daughter-in-law', 'Father-in-law',
              'Mother-in-law', 'Other'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                familyMembers[index]['relationship'] = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Relationship with the Member',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) {
              familyMembers[index]['profession'] = value;
            },
            decoration: InputDecoration(
              labelText: 'Profession',
              border: OutlineInputBorder(),
            ),
            initialValue: familyMembers[index]['profession'],
          ),
          SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) {
              familyMembers[index]['volunteer'] = value;
            },
            decoration: InputDecoration(
              labelText: 'Club volunteer/ Participation',
              border: OutlineInputBorder(),
            ),
            initialValue: familyMembers[index]['volunteer'],
          ),
        ],
      ),
    );
  }

}
