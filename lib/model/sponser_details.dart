import 'dart:convert';

class FamilyListItem {
  final String id;
  final String description;
  final String eTime;
  final String eventId;

  FamilyListItem({
    required this.id,
    required this.description,
    required this.eTime,
    required this.eventId,
  });

  factory FamilyListItem.fromJson(Map<String, dynamic> json) {
    return FamilyListItem(
      id: json['id'],
      description: json['description'],
      eTime: json['e_time'],
      eventId: json['event_id'],
    );
  }
}

class ResponseDataNew {
  final List<FamilyListItem> familyList;

  ResponseDataNew({required this.familyList});

  factory ResponseDataNew.fromJson(Map<String, dynamic> json) {
    var list = json['familylist'] as List;
    List<FamilyListItem> familyList = list.map((i) => FamilyListItem.fromJson(i)).toList();
    return ResponseDataNew(familyList: familyList);
  }
}

ResponseDataNew parseResponse(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return ResponseDataNew.fromJson(parsed);
}
