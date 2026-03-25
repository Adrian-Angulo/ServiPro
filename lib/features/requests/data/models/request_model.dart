class RequestModel {
  final int id;
  final int idClient;
  final int idTypeService;
  final String details;
  final String addres;
  final DateTime dateCreated;
  final DateTime dateUpdate;
  final DateTime dateFinish;

  RequestModel({
    required this.id,
    required this.idClient,
    required this.idTypeService,
    required this.details,
    required this.addres,
    required this.dateCreated,
    required this.dateUpdate,
    required this.dateFinish,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] as int,
      idClient: map['idClient'] as int,
      idTypeService: map['idTypeService'] as int,
      details: map['details'] as String,
      addres: map['addres'] as String,
      dateCreated: DateTime.parse(map['dateCreated'] as String),
      dateUpdate: DateTime.parse(map['dateUpdate'] as String),
      dateFinish: DateTime.parse(map['dateFinish'] as String),
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
