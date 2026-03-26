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
        .map((doc) => RequestModel.fromMap(doc.data()).copyWith(id: doc.id))
        .toList();
  }

  @override
  Future<void> registerRequest(RequestModel r) async {
    await _firestore.collection('requests').add(r.toMap());
  }

  @override
  Future<void> deleteRequest(String id) async {
    await _firestore.collection('requests').doc(id).delete();
  }
}
