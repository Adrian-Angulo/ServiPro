import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_pro/features/application/data/datasources/i_application_datasource.dart';
import 'package:servi_pro/features/application/data/models/application_model.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';

class ApplicationFirebaseDatasource implements IApplicationDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addAplication(ApplicationEntity application) async {
    try {
      final model = ApplicationModel.fromEntity(application);
      
      final batch = firestore.batch();
      
      // Crear referencia para la nueva postulación
      final applicationRef = firestore.collection("applications").doc();
      batch.set(applicationRef, model.toMap());
      
      // Incrementar el contador en la solicitud
      final requestRef = firestore.collection("requests").doc(application.idrequest);
      batch.update(requestRef, {
        "postulationsCount": FieldValue.increment(1)
      });
      
      await batch.commit();
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

  Future<void> cancelApplication(String id, String idRequest) async {
    try {
      final applicationRef = firestore.collection("applications").doc(id);
      
      // Obtener el documento para verificar si estaba aceptado
      final docSnapshot = await applicationRef.get();
      if (!docSnapshot.exists) return;
      
      final state = docSnapshot.data()?['state'];

      final batch = firestore.batch();
      
      // Eliminar la referencia de la postulación
      batch.delete(applicationRef);
      
      // Actualizar la solicitud: decrementar contador y, si estaba aceptada, volver a pending
      final requestRef = firestore.collection("requests").doc(idRequest);
      final updates = <String, dynamic>{
        "postulationsCount": FieldValue.increment(-1)
      };
      
      if (state == "aceptado") {
        updates["status"] = "pending";
      }
      
      batch.update(requestRef, updates);
      
      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> acceptApplication(String applicationId, String requestId) async {
    try {
      final batch = firestore.batch();
      
      // 1. Actualizar estado de la postulación a aceptado
      final applicationRef = firestore.collection("applications").doc(applicationId);
      batch.update(applicationRef, {
        "state": "aceptado"
      });
      
      // 2. Actualizar estado de la solicitud a inProgress
      final requestRef = firestore.collection("requests").doc(requestId);
      batch.update(requestRef, {
        "status": "inProgress",
        "dateAssigned": DateTime.now().toIso8601String()
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> completeRequest(String applicationId, String requestId) async {
    try {
      final batch = firestore.batch();
      
      // 1. Actualizar estado de la postulación a finalizado
      final applicationRef = firestore.collection("applications").doc(applicationId);
      batch.update(applicationRef, {
        "state": "finalizado"
      });
      
      // 2. Actualizar estado de la solicitud a completed y asignar dateFinish
      final requestRef = firestore.collection("requests").doc(requestId);
      batch.update(requestRef, {
        "status": "completed",
        "dateFinish": DateTime.now().toIso8601String()
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }
}
