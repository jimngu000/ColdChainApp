class Hospital {
  final int? id;
  final String name;
  final int district;
  final int user;

  Hospital(
      {this.id, // primary key
      required this.name,
      required this.district,
      required this.user});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'district': district,
      'user': user,
    };
  }

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
      id: json['pk'],
      name: json["fields"]['name'],
      district: json["fields"]['district'],
      user: json["fields"]['user']);

  // for print
  @override
  String toString() {
    return 'Hospital{id: $id, name: $name, district: $district, user: $user}';
  }
}
