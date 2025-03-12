import 'dart:convert';

// Main response model
class ApiResponseNew {
  final String? responseCode;
  final String? result;
  final String? responseMsg;
  final BhogDataNew? bhogdata;

  ApiResponseNew({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.bhogdata,
  });

  factory ApiResponseNew.fromJson(Map<String, dynamic> json) {
    return ApiResponseNew(
      responseCode: json['ResponseCode'] as String?,
      result: json['Result'] as String?,
      responseMsg: json['ResponseMsg'] as String?,
      bhogdata: json['bhogdata'] != null
          ? BhogDataNew.fromJson(json['bhogdata'])
          : null,
    );
  }
}


// BhogData model
class BhogDataNew {
  final List<BhogDetail>? bhogdetails;

  BhogDataNew({
    this.bhogdetails,
  });

  factory BhogDataNew.fromJson(Map<String, dynamic> json) {
    var list = json['bhogdetails'] as List?;
    List<BhogDetail>? bhogdetailsList = list?.map((i) => BhogDetail.fromJson(i)).toList();

    return BhogDataNew(
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
  final String? kseats;

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
    this.kseats,
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
      kseats: json['kseats'] != null ?json['kseats'] as String? : null,
    );
  }
}

