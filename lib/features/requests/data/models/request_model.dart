class RequestModel {
  String? id;
  final String idClient;
  final String title;
  final int idTypeService;
  final String details;
  final String addres;
  String status;
  DateTime dateCreated;

  DateTime? dateFinish;

  RequestModel({
    this.id,
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
      id: map['id'],
      idClient: map['idClient'],
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

  RequestModel copyWith({
    String? id,
    String? idClient,
    String? title,
    int? idTypeService,
    String? details,
    String? addres,
    String? status,
    DateTime? dateCreated,
    DateTime? dateFinish,
  }) {
    return RequestModel(
      id: id ?? this.id,
      idClient: idClient ?? this.idClient,
      title: title ?? this.title,
      idTypeService: idTypeService ?? this.idTypeService,
      details: details ?? this.details,
      addres: addres ?? this.addres,
      status: status ?? this.status,
      dateCreated: dateCreated ?? this.dateCreated,
      dateFinish: dateFinish ?? this.dateFinish,
    );
  }
}
