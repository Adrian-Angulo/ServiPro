import 'package:servi_pro/core/utils/enums.dart';

class RequestEntity {
  String? id;
  final String idClient;
  final String title;
  final String idTypeService;
  final String details;
  final String addres;
  ServiceStatus status;
  DateTime dateCreated;
  DateTime? dateFinish;

  RequestEntity({
    this.id,
    required this.idClient,
    required this.idTypeService,
    required this.details,
    required this.addres,
    this.status = ServiceStatus.pending,
    DateTime? dateCreated,

    this.dateFinish,
    required this.title,
  }) : dateCreated = dateCreated ?? DateTime.now();
  factory RequestEntity.fromMap(Map<String, dynamic> map) {
    return RequestEntity(
      id: map['id'],
      idClient: map['idClient'],
      idTypeService: map['idTypeService'] ?? "",
      details: map['details'] as String? ?? '',
      addres: map['addres'] as String? ?? '',
      status: ServiceStatus.values.firstWhere((e) => e.name == map['status']),
      dateCreated: map['dateCreated'] != null
          ? DateTime.parse(map['dateCreated'] as String)
          : DateTime.now(),
      dateFinish: map['dateFinish'] != null
          ? DateTime.parse(map['dateFinish'] as String)
          : null,
      title: map['title'] ?? "no definido",
    );
  }
}
