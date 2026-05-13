import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  RequestModel({
    super.id,
    required super.idClient,
    required super.idTypeService,
    required super.details,
    required super.addres,
    required super.title,
    super.postulationsCount = 0,
    super.status,
    super.dateCreated,
    super.dateAssigned,
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
      postulationsCount: map['postulationsCount'] as int? ?? 0,
      status: ServiceStatus.values.firstWhere((e) => e.name == map['status']),
      dateCreated: map['dateCreated'] != null
          ? DateTime.parse(map['dateCreated'])
          : DateTime.now(),
      dateAssigned: map['dateAssigned'] != null
          ? DateTime.parse(map['dateAssigned'])
          : null,
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
      'postulationsCount': postulationsCount,
      'status': status.name,
      'dateCreated': dateCreated.toIso8601String(),
      'dateAssigned': dateAssigned?.toIso8601String(),
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
    int? postulationsCount,
    ServiceStatus? status,
    DateTime? dateCreated,
    DateTime? dateAssigned,
    DateTime? dateFinish,
  }) {
    return RequestModel(
      id: id ?? this.id,
      idClient: idClient ?? this.idClient,
      title: title ?? this.title,
      idTypeService: idTypeService ?? this.idTypeService,
      details: details ?? this.details,
      addres: addres ?? this.addres,
      postulationsCount: postulationsCount ?? this.postulationsCount,
      status: status ?? this.status,
      dateCreated: dateCreated ?? this.dateCreated,
      dateAssigned: dateAssigned ?? this.dateAssigned,
      dateFinish: dateFinish ?? this.dateFinish,
    );
  }
}
