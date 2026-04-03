import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_pro/features/requests/data/models/type_services.dart';
import 'package:servi_pro/features/requests/domain/repository/type_services_repository.dart';

class TypeServicesRepositoryImpl implements TypeServicesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'type_services';

  @override
  Future<void> create(TypeServices typeServices) async {
    await _firestore.collection(_collection).add(typeServices.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  @override
  Future<List<TypeServices>> getAll() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => TypeServices.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<TypeServices?> getById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return TypeServices.fromJson(doc.data()!);
  }

  @override
  Future<void> update(TypeServices typeServices) async {
    await _firestore
        .collection(_collection)
        .doc(typeServices.id)
        .update(typeServices.toJson());
  }
}
