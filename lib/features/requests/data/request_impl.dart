import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:servi_pro/features/requests/data/models/request_model.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class RequestImpl implements RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RequestImpl();

  @override
  Future<List<RequestModel>> allRequest() async {
    final snapshot = await _firestore.collection('requests').get();
    return snapshot.docs
        .map((doc) => RequestModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> registerRequest(RequestModel r) async {
    await _firestore.collection('requests').add({
      'id_client': r.idClient,
      'idTypeService': r.idTypeService,
      'details': r.details,
      'status': "pending",
      'date_created': FieldValue.serverTimestamp(),
      'date_update': "",
    });
  }
}
