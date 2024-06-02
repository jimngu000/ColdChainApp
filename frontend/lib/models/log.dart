import 'dart:convert';

class Log {
  final int? id;
  final int user;
  final int district;
  final int hospital;
  final int? refrigerator;
  final Map<String, dynamic> previousValue;
  final Map<String, dynamic> newValue;
  final DateTime timestamp;

  Log({
    this.id, // primary key
    required this.user,
    required this.district,
    required this.hospital,
    this.refrigerator,
    required this.previousValue,
    required this.newValue,
    required this.timestamp,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    // Safely get the 'fields' map
    final fields = json['fields'] ?? {};

    return Log(
      id: json['pk'],
      user: json["fields"]['user'] ?? -1,
      district: json["fields"]['district'] ?? -1,
      hospital: json["fields"]['hospital'] ?? -1,
      refrigerator: json["fields"]['refrigerator'],
      previousValue: fields['previous_value'] is String 
          ? jsonDecode(fields['previous_value']) 
          : fields['previous_value'] ?? {},
      newValue: fields['new_value'] is String 
          ? jsonDecode(fields['new_value']) 
          : fields['new_value'] ?? {},
      timestamp: DateTime.parse(json["fields"]['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'district': district,
      'hospital': hospital,
      'refrigerator': refrigerator,
      'previous_value': jsonEncode(previousValue),
      'new_value': jsonEncode(newValue),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // for print
  @override
  String toString() {
    return 'Log{id: $id, user id: $user, district id: $district, hospital id: $hospital, refrigerator id: $refrigerator, previous val: $previousValue, new val: $newValue, timestamp: $timestamp}';
  }
}