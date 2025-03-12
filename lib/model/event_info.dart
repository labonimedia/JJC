// To parse this JSON data, do
//
//     final eventInfo = eventInfoFromJson(jsonString);

import 'dart:convert';

EventInfo eventInfoFromJson(String str) => EventInfo.fromJson(json.decode(str));

String eventInfoToJson(EventInfo data) => json.encode(data.toJson());

class EventInfo {
  String responseCode;
  String result;
  String responseMsg;
  EventData eventData;
  List<String> eventGallery;
  List<EventArtist> eventArtist;
  List<EventFacility> eventFacility;
  List<EventRestriction> eventRestriction;
  List<Reviewdatum> reviewdata;
  PlannerData? plannerData;
  SpacialAttraction? spacialAttraction;
  SponsorGallery? sponsorGallery;
  EventInfo({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.eventData,
    required this.eventGallery,
    required this.eventArtist,
    required this.eventFacility,
    required this.eventRestriction,
    required this.reviewdata,
    this.plannerData,
    required this.spacialAttraction,
    required this.sponsorGallery,

  });

  factory EventInfo.fromJson(Map<String, dynamic> json) => EventInfo(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
        eventData: EventData.fromJson(json["EventData"]),
        eventGallery: List<String>.from(json["Event_gallery"].map((x) => x)),
        eventArtist: List<EventArtist>.from(
            json["Event_Artist"].map((x) => EventArtist.fromJson(x))),
        eventFacility: List<EventFacility>.from(
            json["Event_Facility"].map((x) => EventFacility.fromJson(x))),
        eventRestriction: List<EventRestriction>.from(
            json["Event_Restriction"].map((x) => EventRestriction.fromJson(x))),
        reviewdata: List<Reviewdatum>.from(
            json["reviewdata"].map((x) => Reviewdatum.fromJson(x))),
    plannerData: json["plannerdata"] != null ? PlannerData.fromJson(json["plannerdata"]) : null,

    spacialAttraction: json['spacialattraction'] != null
        ? SpacialAttraction.fromJson(json['spacialattraction'])
        : null,
        sponsorGallery: json['sponsor_gallery'] != null ?SponsorGallery.fromJson(json['sponsor_gallery']): null,
      );


  // Model for the spacialattraction part




  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
        "EventData": eventData.toJson(),
        "Event_gallery": List<dynamic>.from(eventGallery.map((x) => x)),
        "Event_Artist": List<dynamic>.from(eventArtist.map((x) => x.toJson())),
        "Event_Facility":
            List<dynamic>.from(eventFacility.map((x) => x.toJson())),
        "Event_Restriction":
            List<dynamic>.from(eventRestriction.map((x) => x.toJson())),
        "reviewdata": List<dynamic>.from(reviewdata.map((x) => x.toJson())),
    "plannerdata": plannerData?.toJson(),
       //"plannerEvent": List<dynamic>.from(plannerEvent.map((x) => x.toJson())),

      };


}

class SponsorGalleryDetail {
  String? eventId;
  String? title;
  String? description;
  String? img;

  SponsorGalleryDetail({
    required this.eventId,
    required this.title,
    required this.description,
    required this.img,
  });

  // Factory constructor for creating a new instance from a map (parsed JSON)
  factory SponsorGalleryDetail.fromJson(Map<String, dynamic> json) {
    return SponsorGalleryDetail(
      eventId: json['event_id'],
      title: json['title'],
      description: json['description'],
      img: json['img'],
    );
  }
}

// Model for Sponsor Gallery
class SponsorGallery {
  List<SponsorGalleryDetail>? details;

  SponsorGallery({required this.details});

  // Factory constructor for creating a new instance from a map (parsed JSON)
  factory SponsorGallery.fromJson(Map<String, dynamic> json) {
    var detailsList = json['details'] as List;
    List<SponsorGalleryDetail> details = detailsList
        .map((detailJson) => SponsorGalleryDetail.fromJson(detailJson))
        .toList();

    return SponsorGallery(details: details);
  }
}



class SpacialAttraction {
  List<EventDetails>? details;

  SpacialAttraction({
    this.details,
  });

  factory SpacialAttraction.fromJson(Map<String, dynamic> json) {
    var list = json['details'] as List;
    List<EventDetails> detailsList =
    list.map((i) => EventDetails.fromJson(i)).toList();

    return SpacialAttraction(
      details: detailsList,
    );
  }
}
// Model for individual event details
class EventDetails {
  String? eventId;
  String? title;
  String? date;
  String? time;
  String? description;
  String? img;
  String? path;

  EventDetails({
    this.eventId,
    this.title,
    this.date,
    this.time,
    this.description,
    this.img,
    this.path,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      eventId: json['event_id'],
      title: json['title'],
      date: json['date'],
      time: json['time'],
      description: json['description'],
      img: json['img'],
      path: json['path'],
    );
  }
}

class EventArtist {
  String artistImg;
  String artistTitle;
  String artistRole;

  EventArtist({
    required this.artistImg,
    required this.artistTitle,
    required this.artistRole,
  });

  factory EventArtist.fromJson(Map<String, dynamic> json) => EventArtist(
        artistImg: json["artist_img"],
        artistTitle: json["artist_title"],
        artistRole: json["artist_role"],
      );

  Map<String, dynamic> toJson() => {
        "artist_img": artistImg,
        "artist_title": artistTitle,
        "artist_role": artistRole,
      };
}

class EventData {
  String eventId;
  String eventTitle;
  String eventImg;
  List<String> eventCoverImg;
  String eventSdate;
  String eventTimeDay;
  String eventAddressTitle;
  String eventAddress;
  String eventLatitude;
  String eventLongtitude;
  String eventDisclaimer;
  String eventAbout;
  List<String> eventTags;
  List<String> eventVideoUrls;
  String ticketPrice;
  int isBookmark;
  String sponsoreId;
  String sponsoreImg;
  String sponsoreName;
  String sponsoreMobile;
  int totalTicket;
  int isJoined;
  int totalBookTicket;
  List<String> memberList;

  EventData({
    required this.eventId,
    required this.eventTitle,
    required this.eventImg,
    required this.eventCoverImg,
    required this.eventSdate,
    required this.eventTimeDay,
    required this.eventAddressTitle,
    required this.eventAddress,
    required this.eventLatitude,
    required this.eventLongtitude,
    required this.eventDisclaimer,
    required this.eventAbout,
    required this.eventTags,
    required this.eventVideoUrls,
    required this.ticketPrice,
    required this.isBookmark,
    required this.sponsoreId,
    required this.sponsoreImg,
    required this.sponsoreName,
    required this.sponsoreMobile,
    required this.totalTicket,
    required this.isJoined,
    required this.totalBookTicket,
    required this.memberList,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        eventId: json["event_id"],
        eventTitle: json["event_title"],
        eventImg: json["event_img"],
        eventCoverImg: List<String>.from(json["event_cover_img"].map((x) => x)),
        eventSdate: json["event_sdate"],
        eventTimeDay: json["event_time_day"],
        eventAddressTitle: json["event_address_title"],
        eventAddress: json["event_address"],
        eventLatitude: json["event_latitude"],
        eventLongtitude: json["event_longtitude"],
        eventDisclaimer: json["event_disclaimer"],
        eventAbout: json["event_about"],
        eventTags: List<String>.from(json["event_tags"].map((x) => x)),
        eventVideoUrls: List<String>.from(
            json["event_video_urls"].map((x) => x.toString())),
        ticketPrice: json["ticket_price"],
        isBookmark: json["IS_BOOKMARK"],
        sponsoreId: json["sponsore_id"].toString(),
        sponsoreImg: json["sponsore_img"].toString(),
        sponsoreName: json["sponsore_name"].toString(),
        sponsoreMobile: json["sponsore_mobile"].toString(),
        totalTicket: json["total_ticket"],
        isJoined: json["is_joined"],
        totalBookTicket: json["total_book_ticket"],
        memberList: List<String>.from(json["member_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "event_title": eventTitle,
        "event_img": eventImg,
        "event_cover_img": List<dynamic>.from(eventCoverImg.map((x) => x)),
        "event_sdate": eventSdate,
        "event_time_day": eventTimeDay,
        "event_address_title": eventAddressTitle,
        "event_address": eventAddress,
        "event_latitude": eventLatitude,
        "event_longtitude": eventLongtitude,
        "event_disclaimer": eventDisclaimer,
        "event_about": eventAbout,
        "event_tags": List<dynamic>.from(eventTags.map((x) => x)),
        "event_video_urls": List<dynamic>.from(eventVideoUrls.map((x) => x)),
        "ticket_price": ticketPrice,
        "IS_BOOKMARK": isBookmark,
        "sponsore_id": sponsoreId,
        "sponsore_img": sponsoreImg,
        "sponsore_name": sponsoreName,
        "sponsore_mobile": sponsoreMobile,
        "total_ticket": totalTicket,
        "is_joined": isJoined,
        "total_book_ticket": totalBookTicket,
        "member_list": List<dynamic>.from(memberList.map((x) => x)),
      };
}

class EventFacility {
  String facilityImg;
  String facilityTitle;

  EventFacility({
    required this.facilityImg,
    required this.facilityTitle,
  });

  factory EventFacility.fromJson(Map<String, dynamic> json) => EventFacility(
        facilityImg: json["facility_img"],
        facilityTitle: json["facility_title"],
      );

  Map<String, dynamic> toJson() => {
        "facility_img": facilityImg,
        "facility_title": facilityTitle,
      };
}

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
  String userImg;
  String customername;
  String rateNumber;
  String rateText;

  Reviewdatum({
    required this.userImg,
    required this.customername,
    required this.rateNumber,
    required this.rateText,
  });

  factory Reviewdatum.fromJson(Map<String, dynamic> json) => Reviewdatum(
        userImg: json["user_img"],
        customername: json["customername"],
        rateNumber: json["rate_number"],
        rateText: json["rate_text"],
      );

  Map<String, dynamic> toJson() => {
        "user_img": userImg,
        "customername": customername,
        "rate_number": rateNumber,
        "rate_text": rateText,
      };
}




class EventDetail {
  final String description;
  final String eTime;
  final String dayId;

  EventDetail({
    required this.description,
    required this.eTime,
    required this.dayId,
  });



  factory EventDetail.fromJson(Map<String, dynamic> json) => EventDetail(
    description: json['description'],
    eTime: json['e_time'],
    dayId: json['dayid'],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "e_time": eTime,
    "dayid": dayId,

  };

}

class CuturalDetail {
  final String description;
  final String eTime;
  final String dayId;

  CuturalDetail({
    required this.description,
    required this.eTime,
    required this.dayId,
  });



  factory CuturalDetail.fromJson(Map<String, dynamic> json) => CuturalDetail(
    description: json['description'],
    eTime: json['e_time'],
    dayId: json['dayid'],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "e_time": eTime,
    "dayid": dayId,

  };

}

class BhogDetail {
  final String bhogid;
  final String alloption;
  final String dayid;
  final String textname;
  final String guestsprice;
  final String memberprice;
  final String flag;
  BhogDetail({
    required this.bhogid,
    required this.alloption,
    required this.dayid,
    required this.textname,
    required this.guestsprice,
    required this.memberprice,
    required this.flag,
  });

  // Factory constructor to create an instance from a JSON map


  factory BhogDetail.fromJson(Map<String, dynamic> json) => BhogDetail(
    bhogid: json['bhogid'],
    alloption: json['alloption'],
    dayid: json['dayid'],
    textname: json['textname'],
    guestsprice: json['guestsprice'],
    memberprice: json['memberprice'],
    flag: json['flag'],
  );

  Map<String, dynamic> toJson() => {
    "bhogid": bhogid,
    "v": alloption,
    "dayid": dayid,
    "textname": textname,
    "guestsprice": guestsprice,
    "memberprice": memberprice,
    "flag": flag,
  };

}




class Event {
  final String eventDate;
  final String eventName;
  final List<EventDetail> details;
  final List<CuturalDetail> cutural;
  final List<BhogDetail> bhogDetails;
  Event({
    required this.eventDate,
    required this.eventName,
    required this.details,
    required this.cutural,
    required this.bhogDetails,
  });



  factory Event.fromJson(Map<String, dynamic> json) => Event(
    eventDate: json['event_date'],
    eventName: json['event_name'],
    details: (json['details'] as List<dynamic>?)
        ?.map((detailJson) => EventDetail.fromJson(detailJson as Map<String, dynamic>))
        .toList() ?? [],
    cutural: (json['cutural'] as List<dynamic>?)
        ?.map((cuturalJson) => CuturalDetail.fromJson(cuturalJson as Map<String, dynamic>))
        .toList() ?? [],
    bhogDetails: (json['bhogdetails'] as List<dynamic>?)
        ?.map((bhogJson) => BhogDetail.fromJson(bhogJson as Map<String, dynamic>))
        .toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    "event_date": eventDate,
    "event_name": eventName,
    "details": List<dynamic>.from(details.map((x) => x)),
    "cutural": List<dynamic>.from(cutural.map((x) => x)),
    "bhogDetails": List<dynamic>.from(bhogDetails.map((x) => x)),

  };

}

class PlannerData {
  final Map<String, Event> events;

  PlannerData({required this.events});

  // Factory constructor for creating a new PlannerData instance from a JSON map
  factory PlannerData.fromJson(Map<String, dynamic> json) {
    Map<String, Event> events = {};
    json.forEach((key, value) {
      events[key] = Event.fromJson(value);
    });
    return PlannerData(events: events);
  }

  // Method for converting a PlannerData instance to a JSON map
  Map<String, dynamic> toJson() {
    return events.map((key, event) {
      return MapEntry(key, event.toJson());
    });
  }
}
