import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_pro/features/application/data/datasources/i_application_datasource.dart';
import 'package:servi_pro/features/application/data/models/application_model.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';

class ApplicationFirebaseDatasource implements IApplicationDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addAplication(ApplicationEntity application) async {
    try {
      final model = ApplicationModel.fromEntity(application);
      await firestore.collection("applications").add(model.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ApplicationEntity>> getAppliForWorker(String idWorker) async {
    try {
      final snapshot = await firestore
          .collection("applications")
          .where("idworker", isEqualTo: idWorker)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ApplicationModel.fromMap(data).toEntity();
      }).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ApplicationEntity>> getAppliForRequest(String idRequest) async {
    try {
      final snapshot = await firestore
          .collection("applications")
          .where("idrequest", isEqualTo: idRequest)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ApplicationModel.fromMap(data).toEntity();
      }).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
