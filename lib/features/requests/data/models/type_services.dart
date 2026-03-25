class TypeServices {
  final int id;
  final String name;
  final String description;
  final DateTime dateCreated;

  TypeServices({
    required this.id,
    required this.name,
    required this.description,
    required this.dateCreated,
  });

  factory TypeServices.fromJson(Map<String, dynamic> json) {
    return TypeServices(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dateCreated: DateTime.parse(json['dateCreated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }
}
