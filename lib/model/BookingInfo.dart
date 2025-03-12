import 'dart:convert';

// Model for individual collected list item
class CollectedListItem {
  String id;
  String userId;
  String bhogId;
  String isAllFlag;
  String edate;
  String collectedCnt;
  String pendingCnt;
  String totalCnt;

  CollectedListItem({
    required this.id,
    required this.userId,
    required this.bhogId,
    required this.isAllFlag,
    required this.edate,
    required this.collectedCnt,
    required this.pendingCnt,
    required this.totalCnt,
  });

  factory CollectedListItem.fromJson(Map<String, dynamic> json) {
    return CollectedListItem(
      id: json['id'],
      userId: json['user_id'],
      bhogId: json['bhog_id'],
      isAllFlag: json['is_all_flag'] ?? "",
      edate: json['edate'],
      collectedCnt: json['collected_cnt'],
      pendingCnt: json['pending_cnt'] ?? "",
      totalCnt: json['total_cnt'],
    );
  }
}

// Model for the entire response
class BookingResponse {
  List<CollectedListItem> collectedlist;
  String responseCode;
  String result;
  String responseMsg;

  BookingResponse({
    required this.collectedlist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    var list = json['collectedlist'] as List;
    List<CollectedListItem> collectedItems = list.map((i) => CollectedListItem.fromJson(i)).toList();

    return BookingResponse(
      collectedlist: collectedItems,
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
    );
  }
}
