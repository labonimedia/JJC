import 'dart:convert';

class StallItem {
  final String id;
  final String itemname;
  final String? menu_image1;
  final String? menu_image2;
  final String? menu_image3;
  final String? menu_image4;

  StallItem({required this.id, required this.itemname,this.menu_image1,this.menu_image2,this.menu_image3,this.menu_image4});

  factory StallItem.fromJson(Map<String, dynamic> json) {
    return StallItem(
      id: json['id'],
      itemname: json['title'],
      menu_image1: json['menu_image1'],
      menu_image2: json['menu_image2'],
      menu_image3: json['menu_image3'],
      menu_image4: json['menu_image4'],
    );
  }
}

class StallResponse {
  final List<StallItem> familylist;
  final String responseCode;
  final String result;
  final String responseMsg;

  StallResponse({
    required this.familylist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory StallResponse.fromJson(Map<String, dynamic> json) {
    var list = json['familylist'] as List;
    List<StallItem> itemList = list.map((i) => StallItem.fromJson(i)).toList();

    return StallResponse(
      familylist: itemList,
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
    );
  }
}
