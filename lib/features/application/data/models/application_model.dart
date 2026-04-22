import 'package:servi_pro/features/application/domain/entites/application_entity.dart';

class ApplicationModel extends ApplicationEntity {
  ApplicationModel({
    required super.id,
    required super.idworker,
    required super.idrequest,
    required super.state,
  });

  Map<String, dynamic> toMap() {
    return {'idworker': idworker, 'idrequest': idrequest, 'state': state};
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'],
      idworker: map['idworker'],
      idrequest: map['idrequest'],
      state: map['state'],
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

  factory ApplicationModel.fromEntity(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      idworker: entity.idworker,
      idrequest: entity.idrequest,
      state: entity.state,
    );
  }
}
