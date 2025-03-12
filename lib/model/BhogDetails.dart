import 'dart:convert';

// Main response model
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

