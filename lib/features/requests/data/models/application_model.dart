enum StateAplication { pending, inProgress, finished }

class ApplicationModel {
  final int _id;
  final int _idWorker;
  final int _idRequest;
  final DateTime _dateCreated;
  final StateAplication _state;

  ApplicationModel({
    required int id,
    required int idWorker,
    required int idRequest,
    required DateTime dateCreated,
    required StateAplication state,
  }) : _id = id,
       _idWorker = idWorker,
       _idRequest = idRequest,
       _dateCreated = dateCreated,
       _state = state;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'idWorker': _idWorker,
      'idRequest': _idRequest,
      'dateCreated': _dateCreated.toIso8601String(),
      'state': _state.name,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: int.parse(map['id']),
      idWorker: int.parse(map['idWorker']),
      idRequest: int.parse(map['idRequest']),
      dateCreated: DateTime.parse(map['dateCreated'] as String),
      state: StateAplication.values.byName(map['state'] as String),
    );
  }
}
