// To parse this JSON data, do
//
//     final eventInfo = eventInfoFromJson(jsonString);

import 'dart:convert';

EventInfo1 eventInfoFromJson(String str) =>
    EventInfo1.fromJson(json.decode(str));

String eventInfoToJson(EventInfo1 data) => json.encode(data.toJson());

class EventInfo1 {
  String? responseCode;
  String? result;
  String? responseMsg;
  EventData? eventData;
  List<String>? eventGallery;
  List<EventArtist>? eventArtist;
  List<EventFacility>? eventFacility;
  List<EventRestriction>? eventRestriction;
  List<Reviewdatum>? reviewdata;
  List<EventType>? eventypelist;

  EventInfo1({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.eventData,
    this.eventGallery,
    this.eventArtist,
    this.eventFacility,
    this.eventRestriction,
    this.reviewdata,
    this.eventypelist,
  });

  factory EventInfo1.fromJson(Map<String, dynamic> json) => EventInfo1(
    responseCode: json["ResponseCode"] ?? "",
    result: json["Result"] ?? "",
    responseMsg: json["ResponseMsg"] ?? "",
    eventData: json["EventData"] != null
        ? EventData.fromJson(json["EventData"])
        : null,
    eventGallery: json["Event_gallery"] != null
        ? List<String>.from(json["Event_gallery"].map((x) => x ?? ""))
        : [],
    eventArtist: json["Event_Artist"] != null
        ? List<EventArtist>.from(
        json["Event_Artist"].map((x) => EventArtist.fromJson(x)))
        : [],
    eventFacility: json["Event_Facility"] != null
        ? List<EventFacility>.from(
        json["Event_Facility"].map((x) => EventFacility.fromJson(x)))
        : [],
    eventRestriction: json["Event_Restriction"] != null
        ? List<EventRestriction>.from(
        json["Event_Restriction"].map((x) => EventRestriction.fromJson(x)))
        : [],
    reviewdata: json["reviewdata"] != null
        ? List<Reviewdatum>.from(
        json["reviewdata"].map((x) => Reviewdatum.fromJson(x)))
        : [],

    eventypelist: json["EventTypeData"] != null
        ? List<EventType>.from(
        json["EventTypeData"].map((x) => EventType.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode ?? "",
    "Result": result ?? "",
    "ResponseMsg": responseMsg ?? "",
    "EventData": eventData?.toJson(),
    "Event_gallery":
    eventGallery?.map((x) => x).toList() ?? [],
    "Event_Artist":
    eventArtist?.map((x) => x.toJson()).toList() ?? [],
    "Event_Facility":
    eventFacility?.map((x) => x.toJson()).toList() ?? [],
    "Event_Restriction":
    eventRestriction?.map((x) => x.toJson()).toList() ?? [],
    "reviewdata":
    reviewdata?.map((x) => x.toJson()).toList() ?? [],
    "EventTypeData":
    eventypelist?.map((x) => x.toJson()).toList() ?? [],
  };
}

class EventType {
  String eventType;
  String eventTypePrice;

  EventType({
    required this.eventType,
    required this.eventTypePrice,
  });

  // Factory method to create an object from JSON
  factory EventType.fromJson(Map<String, dynamic> json) => EventType(
    eventType: json["event_type"],
    eventTypePrice: json["event_type_price"],
  );

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() => {
    "event_type": eventType,
    "event_type_price": eventTypePrice,
  };
}


// Similarly, make fields nullable and add null checks in other related classes like EventData, EventFacility, etc.
class EventData {
  String? eventId;
  String? eventTitle;
  String? category_id;
  String? eventImg;
  List<String>? eventCoverImg;
  String? eventSdate;
  String? eventTimeDay;
  String? eventAddressTitle;
  String? eventAddress;
  String? eventLatitude;
  String? eventLongtitude;
  String? eventDisclaimer;
  String? eventAbout;
  String? flag;
  List<String>? eventTags;
  List<String>? eventVideoUrls;
  String? ticketPrice;
  String? memberprice;
  String? guestsprice;
  String? alloption;

  int? isBookmark;
  String? sponsoreId;
  String? sponsoreImg;
  String? sponsoreName;
  String? sponsoreMobile;
  int? totalTicket;
  int? isJoined;
  int? totalBookTicket;
  List<String>? memberList;

  EventData({
    this.eventId,
    this.eventTitle,
    this.category_id,
    this.eventImg,
    this.eventCoverImg,
    this.eventSdate,
    this.eventTimeDay,
    this.eventAddressTitle,
    this.eventAddress,
    this.eventLatitude,
    this.eventLongtitude,
    this.eventDisclaimer,
    this.eventAbout,
    this.flag,
    this.eventTags,
    this.eventVideoUrls,
    this.ticketPrice,
    this.memberprice,
    this.guestsprice,
    this.alloption,
    this.isBookmark,
    this.sponsoreId,
    this.sponsoreImg,
    this.sponsoreName,
    this.sponsoreMobile,
    this.totalTicket,
    this.isJoined,
    this.totalBookTicket,
    this.memberList,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    eventId: json["event_id"] ?? "",
    eventTitle: json["event_title"] ?? "",
    category_id: json["category_id"]?? "",
    eventImg: json["event_img"] ?? "",
    eventCoverImg: json["event_cover_img"] != null
        ? List<String>.from(json["event_cover_img"].map((x) => x ?? ""))
        : [],
    eventSdate: json["event_sdate"] ?? "",
    eventTimeDay: json["event_time_day"] ?? "",
    eventAddressTitle: json["event_address_title"] ?? "",
    eventAddress: json["event_address"] ?? "",
    eventLatitude: json["event_latitude"] ?? "",
    eventLongtitude: json["event_longtitude"] ?? "",
    eventDisclaimer: json["event_disclaimer"] ?? "",
    eventAbout: json["event_about"] ?? "",
    flag: json["flag"] ?? "",
    eventTags: (json["event_tags"] as List?)
        ?.map((e) => e as String? ?? "")
        .toList() ??
        [],
      eventVideoUrls: (json["event_video_urls"] as List?)
          ?.map((e) => e as String? ?? "")
          .toList() ??
          [],
    ticketPrice: json["ticket_price"] ?? "",
    memberprice: json["memberprice"] ?? "",
    guestsprice: json["guestsprice"] ?? "",
    alloption: json["alloption"] ?? "",
    isBookmark: json["IS_BOOKMARK"] ?? 0,
    sponsoreId: json["sponsore_id"] ?? "",
    sponsoreImg: json["sponsore_img"] ?? "",
    sponsoreName: json["sponsore_name"] ?? "",
    sponsoreMobile: json["sponsore_mobile"] ?? "",
    totalTicket: json["total_ticket"] ?? 0,
    isJoined: json["is_joined"] ?? 0,
    totalBookTicket: json["total_book_ticket"] ?? 0,
    memberList:(json["member_list"] as List?)
        ?.map((e) => e as String? ?? "")
        .toList() ??
        [],


  );

  Map<String, dynamic> toJson() => {
    "event_id": eventId ?? "",
    "event_title": eventTitle ?? "",
    "category_id": category_id ?? "",
    "event_img": eventImg ?? "",
    "event_cover_img":
    eventCoverImg?.map((x) => x).toList() ?? [],
    "event_sdate": eventSdate ?? "",
    "event_time_day": eventTimeDay ?? "",
    "event_address_title": eventAddressTitle ?? "",
    "event_address": eventAddress ?? "",
    "event_latitude": eventLatitude ?? "",
    "event_longtitude": eventLongtitude ?? "",
    "event_disclaimer": eventDisclaimer ?? "",
    "event_about": eventAbout ?? "",
    "flag": flag ?? "",
    "event_tags": eventTags?.map((x) => x).toList() ?? [],
    "event_video_urls":
    eventVideoUrls?.map((x) => x).toList() ?? [],
    "ticket_price": ticketPrice ?? "",
    "memberprice": memberprice ?? "",
    "guestsprice": guestsprice ?? "",
    "alloption": alloption ?? "",
    "IS_BOOKMARK": isBookmark ?? 0,
    "sponsore_id": sponsoreId ?? "",
    "sponsore_img": sponsoreImg ?? "",
    "sponsore_name": sponsoreName ?? "",
    "sponsore_mobile": sponsoreMobile ?? "",
    "total_ticket": totalTicket ?? 0,
    "is_joined": isJoined ?? 0,
    "total_book_ticket": totalBookTicket ?? 0,
    "member_list": memberList?.map((x) => x).toList() ?? [],
  };
}


class EventArtist {
  String? artistImg;
  String? artistTitle;
  String? artistRole;

  EventArtist({
    this.artistImg,
    this.artistTitle,
    this.artistRole,
  });

  factory EventArtist.fromJson(Map<String, dynamic> json) => EventArtist(
    artistImg: json["artist_img"] as String?,
    artistTitle: json["artist_title"] as String?,
    artistRole: json["artist_role"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "artist_img": artistImg?? '',
    "artist_title": artistTitle?? '',
    "artist_role": artistRole?? '',
  };
}



class EventFacility {
  String? facilityImg;
  String? facilityTitle;

  EventFacility({
    this.facilityImg,
    this.facilityTitle,
  });

  factory EventFacility.fromJson(Map<String, dynamic> json) => EventFacility(
    facilityImg: json["facility_img"] as String?, // Nullable
    facilityTitle: json["facility_title"] as String?, // Nullable
  );

  Map<String, dynamic> toJson() => {
    "facility_img": facilityImg ?? "", // Default empty string
    "facility_title": facilityTitle ?? "", // Default empty string
  };
}



/*class EventRestriction {
  String? restrictionImg;
  String? restrictionTitle;

  EventRestriction({
    this.restrictionImg,
    this.restrictionTitle,
  });

  factory EventRestriction.fromJson(Map<String, dynamic> json) =>
      EventRestriction(
        restrictionImg: json["restriction_img"] as String?,
        restrictionTitle: json["restriction_title"] as String?,
      );

  Map<String, dynamic> toJson() => {
    "restriction_img": restrictionImg?? '',
    "restriction_title": restrictionTitle?? '',
  };
}*/

class EventRestriction {
  String restrictionImg;
  String restrictionTitle;
  String restrictionId;
  String restriction_category;
  EventRestriction({
    required this.restrictionImg,
    required this.restrictionTitle,
    required this.restrictionId,
    required this.restriction_category,
  });

  factory EventRestriction.fromJson(Map<String, dynamic> json) =>
      EventRestriction(
        restrictionImg: json["restriction_img"],
        restrictionTitle: json["restriction_title"],
        restrictionId: json["restriction_id"],
        restriction_category: json["restriction_category"],

      );

  Map<String, dynamic> toJson() => {
    "restriction_img": restrictionImg,
    "restriction_title": restrictionTitle,
    "restriction_id": restrictionId,
    "restriction_category": restriction_category,
  };
}

class Reviewdatum {
  String? userImg;
  String? customername;
  String? rateNumber;
  String? rateText;

  Reviewdatum({
    this.userImg,
    this.customername,
    this.rateNumber,
    this.rateText,
  });

  factory Reviewdatum.fromJson(Map<String, dynamic> json) => Reviewdatum(
    userImg: json["user_img"] as String?,
    customername: json["customername"] as String?,
    rateNumber: json["rate_number"] as String?,
    rateText: json["rate_text"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "user_img": userImg?? '',
    "customername": customername?? '',
    "rate_number": rateNumber?? '',
    "rate_text": rateText?? '',
  };
}
