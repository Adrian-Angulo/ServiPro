class TypeServices {
  final String id;
  final String name;
  final String description;
  final DateTime dateCreated;

  TypeServices({
    required this.id,
    required this.name,
    required this.description,
    required this.dateCreated,
  });

  TypeServices copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dateCreated,
  }) {
    return TypeServices(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

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
      'name': name,
      'description': description,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }
}
