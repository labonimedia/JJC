import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model/BhogDetails.dart';

class TicketQrCodePerformer extends StatefulWidget {
  final String ticketData;
  final String eventId;
  final String eventype;
  const TicketQrCodePerformer({required this.ticketData,required this.eventId, required this.eventype});
  @override
  _BhogQRScreenState createState() => _BhogQRScreenState();
}

class _BhogQRScreenState extends State<TicketQrCodePerformer> {

  ApiResponse? apiResponseOther;
  bool isLoading = true; // Loading flag
  bool hasError = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    // Load your data here if needed

    try {


      final data2;

        data2 = await getbookingInfoKclub();

      setState(() {

        apiResponseOther=data2;

        isLoading = false; // Data loaded successfully, stop loading
      });
    } catch (error) {
      setState(() {
        hasError = true; // An error occurred while loading data
        isLoading = false;
      });
    }
  }



  Future getbookingInfoKclub() async {
    final Uri uri = Uri.parse(Config.baseurlKclub + Config.performanceBookingDetailsSingle);
    final response = await http.post(
      uri,
      body: jsonEncode({
        "uid": getData.read("UserLogin")["id"].toString(),
        "username": getData.read("UserLogin")["name"].toString(),
        "eventid": widget.eventId,
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Check if the request was successful
    print("sdasd" + response.body);

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Create an instance of BhogResponse from the JSON map
      ApiResponse bhogResponse = ApiResponse.fromJson(jsonMap);

      // Return the parsed BhogResponse object
      return bhogResponse;
      // showToastMessage(result["ResponseMsg"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: /*QrImageView(
          data: ticketData,
          version: QrVersions.auto,
          size: 200.0,  // Size of the QR code
          gapless: false,
        ),*/
        apiResponseOther?.bhogdata?.bhogdetails != null &&
            apiResponseOther!.bhogdata!.bhogdetails!.isNotEmpty ?

        buildPageKclub(
          apiResponseOther!.bhogdata!.bhogdetails!.first.eventName!,
          widget.ticketData,
          apiResponseOther!.bhogdata!.bhogdetails!.first.collected!,
          apiResponseOther!.bhogdata!.bhogdetails!.first.pending!,
          apiResponseOther!.bhogdata!.bhogdetails!.first.date!,
          apiResponseOther!.bhogdata!.bhogdetails!.first.time!,
          apiResponseOther!.bhogdata!.bhogdetails!.first.venue_name ?? '',
          apiResponseOther!.bhogdata!.bhogdetails!.first.paymentStatus!,
          apiResponseOther!.bhogdata!.bhogdetails!.first.familyCount?? "" ,
          apiResponseOther!.bhogdata!.bhogdetails!.first.guestCount?? '',
        ):

        SizedBox(),
      ),
    );
  }



  Widget buildPage(String title, String qrData, String collected,
      String pending, String date,String time,String venue_name,String status,String totalcount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 24,
            ),
          ),
        ),
        Center(
          child: Text(
            "Venue: ${venue_name}",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 16,
            ),
          ),
        ),
        Center(
          child: Text(
            formatDate(date),
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 16,
            ),
          ),
        ),
        Center(
          child: Text(
            formatTimeRange(time),
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 14,
            ),
          ),
        ),


        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*IconButton(
              icon: Icon(Icons.arrow_back, size: 40),
              onPressed: _previousPage,
            ),*/
            SizedBox(width: 20),
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0, // QR code size
                gapless: false,
              ),
            ),
            SizedBox(width: 20),
            /* IconButton(
              icon: Icon(Icons.arrow_forward, size: 40),
              onPressed: _nextPage,
            ),*/
          ],
        ),

        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                "Entered: ${collected}", // Example collected value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 45),
              child: Text(
                "Pending: ${pending}", // Example pending value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),

        SizedBox(width: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child:Text(
                "Total Booking: "+totalcount,
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              /* Text(
                "Payment for Extras: ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),*/
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left:20,right:20),
              child: status == "0"
                  ? Text(
                "Payment for Extras: Pending",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
                  : Text(
                "Payment for Extras: Paid",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              /* Text(
                "Payment for Extras: ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),*/
            ),
          ],
        ),
      ],
    );
  }




  Widget buildPageKclub(String title, String qrData, String collected,
      String pending, String date,String time,String venue_name,String status,String audienceCnt,performerCnt) {
    return Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0),child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 24,
            ),
          ),
        ),
        Center(
          child: Text(
            "Venue: ${venue_name}",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 16,
            ),
          ),
        ),
        Center(
          child: Text(
            formatDate(date),
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 16,
            ),
          ),
        ),
        Center(
          child: Text(
            formatTimeRange(time),
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Gilroy Bold",
              fontSize: 14,
            ),
          ),
        ),


        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*IconButton(
              icon: Icon(Icons.arrow_back, size: 40),
              onPressed: _previousPage,
            ),*/
            SizedBox(width: 20),
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0, // QR code size
                gapless: false,
              ),
            ),
            SizedBox(width: 20),
            /* IconButton(
              icon: Icon(Icons.arrow_forward, size: 40),
              onPressed: _nextPage,
            ),*/
          ],
        ),

        SizedBox(height: 20),
        /*  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                "Entered: ${collected}", // Example collected value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 45),
              child: Text(
                "Pending: ${pending}", // Example pending value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),*/

        SizedBox(height: 20),


        /*  Row(mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Padding(
              padding: EdgeInsets.only(left:20,right:20),
              child: Text(
                "Audience Booking: ${audienceCnt}", // Example collected value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),

          ],
        ),
        SizedBox(height: 10),
*/
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left:20,right:20),
              child: Text(
                "Performer Booking: ${performerCnt}", // Example pending value
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left:20,right:20),
              child: status == "0"
                  ? Text(
                "Payment for Extras: Pending",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
                  : Text(
                "Payment for Extras: Paid",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            ),
          ],
        ),
      ],
    ),);
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

  String formatTimeRange(String timeRange) {
    List<String> times = timeRange.split('-'); // Split start and end times
    DateFormat inputFormat = DateFormat("HH:mm:ss"); // 24-hour format
    DateFormat outputFormat = DateFormat("hh:mm a"); // 12-hour AM/PM format

    String startTime = outputFormat.format(inputFormat.parse(times[0])); // Convert start time
    String endTime = outputFormat.format(inputFormat.parse(times[1]));   // Convert end time

    return "$startTime - $endTime"; // Return formatted time range
  }

}
class ApiResponse {
  final String? responseCode;
  final String? result;
  final String? responseMsg;
  final BhogData? bhogdata;

  ApiResponse({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.bhogdata,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      responseCode: json['ResponseCode'] as String?,
      result: json['Result'] as String?,
      responseMsg: json['ResponseMsg'] as String?,
      bhogdata: json['bhogdata'] != null
          ? BhogData.fromJson(json['bhogdata'])
          : null,
    );
  }
}


// BhogData model
class BhogData {
  final List<BhogDetail>? bhogdetails;

  BhogData({
    this.bhogdetails,
  });

  factory BhogData.fromJson(Map<String, dynamic> json) {
    var list = json['bhogdetails'] as List?;
    List<BhogDetail>? bhogdetailsList = list?.map((i) => BhogDetail.fromJson(i)).toList();

    return BhogData(
      bhogdetails: bhogdetailsList,
    );
  }
}

// BhogDetail model
class BhogDetail {
  final String? id;
  final String? eventId;
  final String? bhogid;
  final String? alloption;
  final String? eventName;
  final String? guestCount;
  final String? familyCount;
  final String? username;
  final String? userid;
  final String? paymentStatus;
  final String? date; // Nullable
  final String? flag;
  final String? collected;
  final String? pending;
  final String? time;
  final String? venue_name;

  BhogDetail({
    this.id,
    this.eventId,
    this.bhogid,
    this.alloption,
    this.eventName,
    this.guestCount,
    this.familyCount,
    this.username,
    this.userid,
    this.paymentStatus,
    this.date,
    this.flag,
    this.collected,
    this.pending,
    this.time,
    this.venue_name,
  });

  factory BhogDetail.fromJson(Map<String, dynamic> json) {
    return BhogDetail(
      id: json['id'] as String?,
      eventId: json['eventId'] as String?,
      bhogid: json['bhogid'] as String?,
      alloption: json['alloption'] as String?,
      eventName: json['eventName'] as String?,
      guestCount: json['guestCount'] as String?,
      familyCount: json['familyCount'] as String?,
      username: json['username'] as String?,
      userid: json['userid'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      date: json['date'] as String?,
      flag: json['flag'] as String?,
      collected: json['collected'] as String?,
      pending: json['pending'] as String?,
      time: json['time'] as String?,
      venue_name: json['venue_name'] != null ?json['venue_name'] as String? : null,
    );
  }
}

