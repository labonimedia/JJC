class FamilyMember {
  final String id;
  final String userId;
  final String days;
  final String gnumberofpack;
  final String numberofpack;
  final String? paymentType;
  final String? image;
  final String bhogid;
  final String amount;
  final String status;


  FamilyMember({
    required this.id,
    required this.userId,
    required this.days,
    required this.gnumberofpack,
    required this.numberofpack,
    this.paymentType,
    this.image,
    required this.bhogid,
    required this.amount,
    required this.status,

  });

  // Factory constructor to create an instance from a JSON map
  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      userId: json['user_id'],
      days: json['days'],
      gnumberofpack: json['gnumberofpack'],
      numberofpack: json['numberofpack'],
      paymentType: json['payment_type'],
      image: json['image'],
      bhogid: json['bhogid'],
      amount: json['amount'],
      status: json['status'],

    );
  }
}

class BhogResponse {
  final List<FamilyMember> familyList;
  final String responseCode;
  final String result;
  final String responseMsg;

  BhogResponse({
    required this.familyList,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  // Factory constructor to create an instance from a JSON map
  factory BhogResponse.fromJson(Map<String, dynamic> json) {
    List<FamilyMember> familyList = [];
    if (json['familylist'] != null) {
      var list = json['familylist'] as List;
      familyList = list.map((i) => FamilyMember.fromJson(i)).toList();
    }

    return BhogResponse(
      familyList: familyList,
      responseCode: json['ResponseCode'],
      result: json['Result'],
      responseMsg: json['ResponseMsg'],
    );
  }
}
