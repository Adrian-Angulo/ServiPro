import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_pro/features/application/data/models/application_model.dart';
import 'package:servi_pro/features/application/domain/entites/application_entity.dart';

class ApplicationFirebaseDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addAplication(ApplicationEntity application) async {
    try {
      final model = ApplicationModel.fromEntity(application);
      await firestore.collection("applications").add(model.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }
}
