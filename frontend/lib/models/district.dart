class District {
  final int? id;
  final int? userId;
  final String name;

  District({this.id, // primary key
            this.userId,
           required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
    };
  }

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json['pk'],
    userId: json["fields"]['user_id'],
    name: json["fields"]['name'],
    );

  // for print
  @override
  String toString() {
    return 'District{id: $id, user_id: $userId, name: $name}';
  }
}