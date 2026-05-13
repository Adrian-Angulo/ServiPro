import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/features/requests/data/models/request_model.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class RequestImpl implements RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RequestImpl();

  @override
  Future<Either<Failure, List<RequestEntity>>> allRequest() async {
    try {
      final snapshot = await _firestore.collection('requests').get();
      final requests = snapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return right(requests);
    } on SocketException {
      return left(const NetworkFailure());
    } on FirebaseException catch (e) {
      return left(
        FirebaseFailure(
          message: 'Error de Firebase: ${e.message ?? "Error desconocido"}',
          code: e.code,
        ),
      );
    } catch (e) {
      return left(
        UnexpectedFailure(
          message: 'Error al obtener solicitudes: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Stream<List<RequestEntity>> watchAllRequests() {
    return _firestore.collection('requests').snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => RequestModel.fromMap(doc.data()).copyWith(id: doc.id),
          )
          .toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request) async {
    try {
      // Convertir la entidad a modelo para guardar en Firestore
      final requestModel = RequestModel(
        id: request.id,
        idClient: request.idClient,
        title: request.title,
        idTypeService: request.idTypeService,
        details: request.details,
        addres: request.addres,
        status: request.status,
        dateCreated: request.dateCreated,
        dateFinish: request.dateFinish,
      );

      await _firestore.collection('requests').add(requestModel.toMap());

      return right(unit);
    } on SocketException {
      return left(const NetworkFailure());
    } on FirebaseException catch (e) {
      return left(
        FirebaseFailure(
          message: 'Error al guardar: ${e.message ?? "Error desconocido"}',
          code: e.code,
        ),
      );
    } catch (e) {
      return left(
        UnexpectedFailure(
          message: 'Error al crear la solicitud: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRequest(String id) async {
    try {
      await _firestore.collection('requests').doc(id).delete();

      return right(unit);
    } on SocketException {
      return left(const NetworkFailure());
    } on FirebaseException catch (e) {
      return left(
        FirebaseFailure(
          message: 'Error al eliminar: ${e.message ?? "Error desconocido"}',
          code: e.code,
        ),
      );
    } catch (e) {
      return left(
        UnexpectedFailure(
          message: 'Error al eliminar la solicitud: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RequestEntity>> getRequestById(String id) async {
    try {
      final doc = await _firestore.collection('requests').doc(id).get();

      if (!doc.exists || doc.data() == null) {
        return left(
          const UnexpectedFailure(message: 'Solicitud no encontrada'),
        );
      }

      final request = RequestModel.fromMap(doc.data()!).copyWith(id: doc.id);

      return right(request);
    } on SocketException {
      return left(const NetworkFailure());
    } on FirebaseException catch (e) {
      return left(
        FirebaseFailure(
          message: 'Error de Firebase: ${e.message ?? "Error desconocido"}',
          code: e.code,
        ),
      );
    } catch (e) {
      return left(
        UnexpectedFailure(
          message: 'Error al obtener la solicitud: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsCompleted({
    required String requestId,
    required String workerId,
  }) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({
        'status': ServiceStatus.awaitingConfirmation.name,
        'completedByWorker': true,
        'completedAt': DateTime.now().toIso8601String(),
      });

      return right(unit);
    } on SocketException {
      return left(const NetworkFailure());
    } on FirebaseException catch (e) {
      return left(
        FirebaseFailure(
          message:
              'Error al marcar como completado: ${e.message ?? "Error desconocido"}',
          code: e.code,
        ),
      );
    } catch (e) {
      return left(
        UnexpectedFailure(
          message:
              'Error al marcar la solicitud como completada: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmCompletion({
    required String requestId,
    required String clientId,
  }) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({
        'status': ServiceStatus.completed.name,
        'confirmedByClient': true,
        'confirmedAt': DateTime.now().toIso8601String(),
      });

      return right(unit);
    } on SocketException {
      return left(const NetworkFailure());
    } on FirebaseException catch (e) {
      return left(
        FirebaseFailure(
          message:
              'Error al confirmar finalización: ${e.message ?? "Error desconocido"}',
          code: e.code,
        ),
      );
    } catch (e) {
      return left(
        UnexpectedFailure(
          message: 'Error al confirmar la finalización: ${e.toString()}',
        ),
      );
    }
  }
}
