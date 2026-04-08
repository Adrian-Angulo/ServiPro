import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  RequestModel({
    super.id,
    required super.idClient,
    required super.idTypeService,
    required super.details,
    required super.addres,
    required super.title,
    super.status,
    super.dateCreated,
    super.dateFinish,
  });
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'],
      idClient: map['idClient'],
      title: map['title'],
      idTypeService: map['idTypeService'],
      details: map['details'],
      addres: map['addres'],
      status: map['status'],
      dateCreated: map['dateCreated'] != null
          ? DateTime.parse(map['dateCreated'])
          : DateTime.now(),
      dateFinish: map['dateFinish'] != null
          ? DateTime.parse(map['dateFinish'])
          : null,
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
    String? idTypeService,
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
