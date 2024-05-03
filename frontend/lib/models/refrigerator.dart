class Refrigerator {
  final int? id;
  final int? hospitalId;
  final String name;
  final String hospital;
  final String other;

  Refrigerator({this.id, // primary key
           required this.name,
           this.hospitalId,
           required this.hospital,
           required this.other});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hospital_id': hospitalId,
      'name': name,
      'hospital': hospital,
      'other': other,
    };
  }

  factory Refrigerator.fromMap(Map<String, dynamic> map) => Refrigerator(
    id: map['id'],
    hospitalId: map['hospital_id'],
    name: map['name'],
    hospital: map['hospital'],
    other: map['other'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'hospital_id': hospitalId,
    'name': name,
    'hospital': hospital,
    'other': other,
  };

  factory Refrigerator.fromJson(Map<String, dynamic> json) => Refrigerator(
    id: json['id'],
    hospitalId: json['hospital_id'],
    name: json['name'],
    hospital: json['hospital'],
    other: json['other'],
    );

  // for print
  @override
  String toString() {
    return 'Refrigerator{id: $id, name: $name, hospital_id: $hospitalId, hospital: $hospital, other: $other}';
  }
}