class Hospital {
  final int? id;
  final String name;
  final String location;
  final int? districtId;
  final String district;
  final String other;

  Hospital({this.id, // primary key
           required this.name,
           required this.location,
           this.districtId,
           required this.district,
           required this.other});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'district_id': districtId,
      'district': district,
      'other': other,
    };
  }

  factory Hospital.fromMap(Map<String, dynamic> map) => Hospital(
    id: map['id'],
    name: map['name'],
    location: map['location'],
    districtId: map['district_id'],
    district: map['district'],
    other: map['other'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'district_id': districtId,
    'district': district,
    'other': other,
  };

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    districtId: json['district_id'],
    district: json['district'],
    other: json['other'],
    );

  // for print
  @override
  String toString() {
    return 'Hospital{id: $id, name: $name, location: $location, district_id: $districtId, district: $district, other: $other}';
  }
}