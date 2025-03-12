class DistrictsResponse {
  final List<StateDistrict> states;

  DistrictsResponse({required this.states});

  factory DistrictsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['states'] as List;
    List<StateDistrict> statesList = list.map((i) => StateDistrict.fromJson(i)).toList();

    return DistrictsResponse(
      states: statesList,
    );
  }
}

class StateDistrict {
  final String state;
  final List<String> districts;

  StateDistrict({required this.state, required this.districts});

  factory StateDistrict.fromJson(Map<String, dynamic> json) {
    var list = json['districts'] as List;
    List<String> districtsList = list.map((i) => i as String).toList();

    return StateDistrict(
      state: json['state'],
      districts: districtsList,
    );
  }
}
