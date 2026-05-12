import 'package:servi_pro/features/application/domain/entities/application_entity.dart';

class ApplicationModel {
  final String id;
  final String idworker;
  final String idrequest;
  final ApplicationStatus state;

  ApplicationModel({
    required this.id,
    required this.idworker,
    required this.idrequest,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {'idworker': idworker, 'idrequest': idrequest, 'state': state.name};
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
    );
  }

  factory ApplicationModel.fromEntity(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      idworker: entity.idworker,
      idrequest: entity.idrequest,
      state: entity.state,
    );
  }

  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      idworker: idworker,
      idrequest: idrequest,
      state: state,
    );
  }
}
