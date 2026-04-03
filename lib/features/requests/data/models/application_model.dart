enum StateAplication { pending, inProgress, finished }

class ApplicationModel {
  final String? _id;
  final String _idWorker;
  final String _idRequest;
  final DateTime _dateCreated;
  final StateAplication _state;

  ApplicationModel({
    String? id,
    required int idWorker,
    required int idRequest,
    required DateTime dateCreated,
    required StateAplication state,
  }) : _id = id,
       _idWorker = idWorker.toString(),
       _idRequest = idRequest.toString(),
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
      idWorker: int.parse(map['idWorker'].toString()),
      idRequest: int.parse(map['idRequest'].toString()),
      dateCreated: DateTime.parse(map['dateCreated'] as String),
      state: StateAplication.values.byName(map['state'] as String),
    );
  }
}
