import 'package:servi_pro/features/application/domain/entities/application_entity.dart';

class ApplicationModel {
  final String id;
  final String idworker;
  final String idrequest;
  final ApplicationStatus state;
  final DateTime createdAt;

  ApplicationModel({
    required this.id,
    required this.idworker,
    required this.idrequest,
    required this.state,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idworker': idworker,
      'idrequest': idrequest,
      'state': state.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'] ?? '',
      idworker: map['idworker'] ?? '',
      idrequest: map['idrequest'] ?? '',
      state: ApplicationStatus.values.firstWhere(
        (e) => e.name == map['state'],
        orElse: () => ApplicationStatus.postulado,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  factory ApplicationModel.fromEntity(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      idworker: entity.idworker,
      idrequest: entity.idrequest,
      state: entity.state,
      createdAt: entity.createdAt,
    );
  }

  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      idworker: idworker,
      idrequest: idrequest,
      state: state,
      createdAt: createdAt,
    );
  }
}
