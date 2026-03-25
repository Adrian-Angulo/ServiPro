class RequestModel {
  int id;
  final int idClient;
  final int idTypeService;
  final String details;
  final String addres;
  DateTime dateCreated;
  DateTime dateUpdate;
  DateTime dateFinish;

  RequestModel({
    this.id = 0,
    required this.idClient,
    required this.idTypeService,
    required this.details,
    required this.addres,
    DateTime? dateCreated,
    DateTime? dateUpdate,
    DateTime? dateFinish,
  }) : dateCreated = dateCreated ?? DateTime.now(),
       dateUpdate = dateUpdate ?? DateTime.now(),
       dateFinish = dateFinish ?? DateTime.now();

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] as int? ?? 0,
      idClient: map['idClient'] as int? ?? 0,
      idTypeService: map['idTypeService'] as int? ?? 0,
      details: map['details'] as String? ?? '',
      addres: map['addres'] as String? ?? '',
      dateCreated: map['dateCreated'] != null
          ? DateTime.parse(map['dateCreated'] as String)
          : DateTime.now(),
      dateUpdate: map['dateUpdate'] != null
          ? DateTime.parse(map['dateUpdate'] as String)
          : DateTime.now(),
      dateFinish: map['dateFinish'] != null
          ? DateTime.parse(map['dateFinish'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idClient': idClient,
      'idTypeService': idTypeService,
      'details': details,
      'addres': addres,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdate': dateUpdate.toIso8601String(),
      'dateFinish': dateFinish.toIso8601String(),
    };
  }
}
