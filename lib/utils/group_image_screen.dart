import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Api/config.dart';
import '../screen/seeAll/gallery_view.dart';

class GroupImageScreen extends StatelessWidget {
  final String title;
  final List<dynamic> images; // List of images in the group
  final String desc;
  final String date;
  GroupImageScreen({required this.title, required this.images,required this.desc, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Date: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: formatDate(date),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Description: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: desc,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Show images in a 2-column grid
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => FullScreenImage(
                      imageUrl: "${Config.imageUrl}${images[index].img}",
                      tag: "image_${index}",
                    ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/ezgif.com-crop.gif",
                      image: "${Config.imageUrl}${images[index].img}",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  String formatDate(String dateString) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateTime.parse(dateString);

      // Format the parsed date
      return DateFormat('EEE, dd MMM yyyy').format(parsedDate);
    } catch (e) {
      // Handle invalid date input
      return "Invalid date";
    }
  }
}
