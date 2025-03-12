import 'dart:convert';

class ResponseData {
  final String responseCode;
  final String result;
  final String responseMsg;
  final HomeData homeData;

  ResponseData({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.homeData,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
      homeData: HomeData.fromJson(json['HomeData']),
    );
  }
}

class HomeData {
  final List<Category> catList;

  HomeData({required this.catList});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    var list = json['Catlist'] as List;
    List<Category> catList = list.map((i) => Category.fromJson(i)).toList();
    return HomeData(catList: catList);
  }
}

class Category {
  final String id;
  final String title;

  Category({required this.id, required this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
    );
  }
}
