class District {
  final int? id;
  final String name;
  final String other;

  District({this.id, // primary key
           required this.name,
           required this.other});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'other': other,
    };
  }

  factory District.fromMap(Map<String, dynamic> map) => District(
    id: map['id'],
    name: map['name'],
    other: map['other'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'other': other,
  };

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json['id'],
    name: json['name'],
    other: json['other'],
    );

  // for print
  @override
  String toString() {
    return 'District{id: $id, name: $name, other: $other}';
  }
}