class RequestModel {
  int id;
  final int idClient;
  final String title;
  final int idTypeService;
  final String details;
  final String addres;
  String status;
  DateTime dateCreated;

  DateTime? dateFinish;

  RequestModel({
    this.id = 0,
    required this.idClient,
    required this.idTypeService,
    required this.details,
    required this.addres,
    this.status = "pending",
    DateTime? dateCreated,

    this.dateFinish,
    required this.title,
  }) : dateCreated = dateCreated ?? DateTime.now();
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] as int? ?? 0,
      idClient: map['idClient'] as int? ?? 0,
      idTypeService: map['idTypeService'] as int? ?? 0,
      details: map['details'] as String? ?? '',
      addres: map['addres'] as String? ?? '',
      status: map['status'] as String,
      dateCreated: map['dateCreated'] != null
          ? DateTime.parse(map['dateCreated'] as String)
          : DateTime.now(),
      dateFinish: map['dateFinish'] != null
          ? DateTime.parse(map['dateFinish'] as String)
          : null,
      title: map['title'] ?? "no definido",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idClient': idClient,
      'title': title,
      'idTypeService': idTypeService,
      'details': details,
      'addres': addres,
      'status': status,
      'dateCreated': dateCreated.toIso8601String(),
      'dateFinish': dateFinish?.toIso8601String(),
    };
  }
}
