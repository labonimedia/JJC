// To parse this JSON data, do
//
//     final homeInfo = homeInfoFromJson(jsonString);

import 'dart:convert';

HomeInfo homeInfoFromJson(String str) => HomeInfo.fromJson(json.decode(str));

String homeInfoToJson(HomeInfo data) => json.encode(data.toJson());

class HomeInfo {
  String responseCode;
  String result;
  String responseMsg;
  HomeData homeData;

  HomeInfo({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.homeData,
  });

  factory HomeInfo.fromJson(Map<String, dynamic> json) => HomeInfo(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
        homeData: HomeData.fromJson(json["HomeData"]),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
        "HomeData": homeData.toJson(),
      };
}

class HomeData {
  List<Catlist> catlist;
  MainData mainData;
  List<LatestEvent> latestEvent;
  List<LatestEvent> karaokePractice; // New list
  List<LatestEvent> karaokeEvent; // New list
  List<LatestEvent> socialEvent;
  List<Club> clubList;
  List<News>? newsList;
  List<VideoData>? videoGalleryList;
  List<VideoData>? livevideoList;
  String? wallet;
  List<Event> upcomingEvent;
  List<NearbyEvent> nearbyEvent;
  List<Event> thisMonthEvent;
  List<EventList> eventList;
  HomeData({
    required this.catlist,
    required this.mainData,
    required this.latestEvent,
    required this.karaokePractice,
    required this.karaokeEvent,
    required this.socialEvent,
    required this.clubList,
    this.videoGalleryList,
    this.livevideoList,
    this.newsList,
     this.wallet,
    required this.upcomingEvent,
    required this.nearbyEvent,
    required this.thisMonthEvent,
    required this.eventList,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        catlist:
            List<Catlist>.from(json["Catlist"].map((x) => Catlist.fromJson(x))),
        mainData: MainData.fromJson(json["Main_Data"]),
        latestEvent: List<LatestEvent>.from(
            json["latest_event"].map((x) => LatestEvent.fromJson(x))),
    socialEvent: json["social_event"] != null
        ? List<LatestEvent>.from(
        json["social_event"].map((x) => LatestEvent.fromJson(x)))
        : [],
    karaokePractice: json["latest_event_next1"] != null
        ? List<LatestEvent>.from(
        json["latest_event_next1"].map((x) => LatestEvent.fromJson(x)))
        : [], // Handling missing list
    karaokeEvent: json["latest_event_next2"] != null
        ? List<LatestEvent>.from(
        json["latest_event_next2"].map((x) => LatestEvent.fromJson(x)))
        : [], // Handling missing list
        clubList: List<Club>.from(
        json["Club_Data"].map((x) => Club.fromJson(x))),
    newsList: json["News_Data"] != null
        ? List<News>.from(json["News_Data"].map((x) => News.fromJson(x)))
        : [],
    videoGalleryList: List<VideoData>.from(
        json["Video_Data"].map((x) => VideoData.fromJson(x))),
    livevideoList: List<VideoData>.from(
        json["Video_Live"].map((x) => VideoData.fromJson(x))),
        wallet: json["wallet"],
        upcomingEvent: List<Event>.from(
            json["upcoming_event"].map((x) => Event.fromJson(x))),
        nearbyEvent: List<NearbyEvent>.from(
            json["nearby_event"].map((x) => NearbyEvent.fromJson(x))),
        thisMonthEvent: List<Event>.from(json["this_month_event"].map((x) => Event.fromJson(x))),
        eventList:List<EventList>.from (json['eventlist'] .map((x) => EventList.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
        "Catlist": List<dynamic>.from(catlist.map((x) => x.toJson())),
        "Main_Data": mainData.toJson(),
        "latest_event": List<dynamic>.from(latestEvent.map((x) => x.toJson())),
        "social_event": List<dynamic>.from(socialEvent.map((x) => x.toJson())),
        "latest_event_next1": List<dynamic>.from(karaokePractice.map((x) => x.toJson())),
        "latest_event_next2": List<dynamic>.from(karaokeEvent.map((x) => x.toJson())),
        "wallet": wallet,
        "upcoming_event": List<dynamic>.from(upcomingEvent.map((x) => x.toJson())),
        "nearby_event": List<dynamic>.from(nearbyEvent.map((x) => x.toJson())),
        "this_month_event": List<dynamic>.from(thisMonthEvent.map((x) => x.toJson())),
        "eventlist": List<dynamic>.from(eventList.map((x) => x.toJson())),
      };
}


class EventList {
  final String id;
  final String title;
  final List<Event> events;

  EventList({
    required this.id,
    required this.title,
    required this.events,
  });

  factory EventList.fromJson(Map<String, dynamic> json) {
    return EventList(
      id: json['id'],
      title: json['title'],
      events: (json['events'] as List)
          .map((eventJson) => Event.fromJson(eventJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "events": events,

  };

}

class Club{
  String id;
  String title;
  String img;
  String? location;
  String? url;

  Club({
    required this.id,
    required this.title,
    required this.img,
    this.location,
    this.url,
  });


  factory Club.fromJson(Map<String, dynamic> json) => Club(
    id: json["id"],
    title: json["title"],
    img: json["img"],
    location: json["location"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
    "location": location,
    "url": url,
  };


}


class News{

  String title;
  String thumbnail;
  String? news_file;
  String? date;

  News({

    required this.title,
    required this.thumbnail,
    this.news_file,
    this.date,
  });


  factory News.fromJson(Map<String, dynamic> json) => News(

    title: json["title"],
    thumbnail: json["thumbnail"],
    news_file: json["news_file"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {

    "title": title,
    "thumbnail": thumbnail,
    "news_file": news_file,
    "date": date,
  };


}


class VideoData{

  String title;
  String thumbnail;
  String? video_path;
  String? date;

  VideoData({
    required this.title,
    required this.thumbnail,
    this.video_path,
    this.date,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
    title: json["title"],
    thumbnail: json["thumbnail"],
    video_path: json["video_path"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {

    "title": title,
    "thumbnail": thumbnail,
    "video_path": video_path,
    "date": date,
  };
}


class Catlist {
  String id;
  String title;
  String catImg;
  String coverImg;
  int totalEvent;

  Catlist({
    required this.id,
    required this.title,
    required this.catImg,
    required this.coverImg,
    required this.totalEvent,
  });

  factory Catlist.fromJson(Map<String, dynamic> json) => Catlist(
        id: json["id"],
        title: json["title"],
        catImg: json["cat_img"],
        coverImg: json["cover_img"],
        totalEvent: json["total_event"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "cat_img": catImg,
        "cover_img": coverImg,
        "total_event": totalEvent,
      };
}

class Event {
  String eventId;
  String eventTitle;

  String eventImg;
  String eventSdate;
  String eventPlaceName;

  Event({
    required this.eventId,
    required this.eventTitle,

    required this.eventImg,
    required this.eventSdate,
    required this.eventPlaceName,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventId: json["event_id"],
        eventTitle: json["event_title"],

        eventImg: json["event_img"],
        eventSdate: json["event_sdate"],
        eventPlaceName: json["event_place_name"],
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "event_title": eventTitle,

        "event_img": eventImg,
        "event_sdate": eventSdate,
        "event_place_name": eventPlaceName,
      };
}


class LatestEvent {
  String eventId;
  String eventTitle;

  String eventImg;
  String eventSdate;
  String eventPlaceName;
  String flag;

  LatestEvent({
    required this.eventId,
    required this.eventTitle,

    required this.eventImg,
    required this.eventSdate,
    required this.eventPlaceName,
    required this.flag,
  });

  factory LatestEvent.fromJson(Map<String, dynamic> json) => LatestEvent(
    eventId: json["event_id"],
    eventTitle: json["event_title"],

    eventImg: json["event_img"],
    eventSdate: json["event_sdate"],
    eventPlaceName: json["event_place_name"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "event_id": eventId,
    "event_title": eventTitle,

    "event_img": eventImg,
    "event_sdate": eventSdate,
    "event_place_name": eventPlaceName,
    "flag": flag,
  };
}

class MainData {
  String id;
  String currency;
  String scredit;
  String rcredit;
  String tax;
  String maxmember;
  String maxguest;
  MainData({
    required this.id,
    required this.currency,
    required this.scredit,
    required this.rcredit,
    required this.tax,
    required this.maxmember,
    required this.maxguest,
  });

  factory MainData.fromJson(Map<String, dynamic> json) => MainData(
        id: json["id"],
        currency: json["currency"],
        scredit: json["scredit"],
        rcredit: json["rcredit"],
        tax: json["tax"],
        maxmember: json["maxmember"],
        maxguest: json["maxguest"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency": currency,
        "scredit": scredit,
        "rcredit": rcredit,
        "tax": tax,
        "maxmember": maxmember,
        "maxguest": maxguest,
      };
}

class NearbyEvent {
  String eventId;
  String eventTitle;
  String eventImg;
  String eventSdate;
  String eventPlaceName;
  String eventLatitude;
  String eventLongtitude;
  String flag;
  NearbyEvent({
    required this.eventId,
    required this.eventTitle,
    required this.eventImg,
    required this.eventSdate,
    required this.eventPlaceName,
    required this.eventLatitude,
    required this.eventLongtitude,
    required this.flag,
  });

  factory NearbyEvent.fromJson(Map<String, dynamic> json) => NearbyEvent(
        eventId: json["event_id"],
        eventTitle: json["event_title"],
        eventImg: json["event_img"],
        eventSdate: json["event_sdate"],
        eventPlaceName: json["event_place_name"],
        eventLatitude: json["event_latitude"],
        eventLongtitude: json["event_longtitude"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "event_title": eventTitle,
        "event_img": eventImg,
        "event_sdate": eventSdate,
        "event_place_name": eventPlaceName,
        "event_latitude": eventLatitude,
        "event_longtitude": eventLongtitude,
        "flag": flag,
      };
}
