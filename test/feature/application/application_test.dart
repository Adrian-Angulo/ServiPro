import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/domain/repositories/application_repository.dart';
import 'package:servi_pro/features/application/domain/usecases/add_application_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/get_applications_for_request_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/get_applications_for_worker_usecase.dart';

import 'application_test.mocks.dart';

@GenerateMocks([ApplicationRepository])
void main() {
  late MockApplicationRepository mockRepository;
  late AddApplicationUsecase addApplicationUsecase;
  late GetApplicationsForWorkerUsecase getApplicationsForWorkerUsecase;
  late GetApplicationsForRequestUsecase getApplicationsForRequestUsecase;

  setUp(() {
    mockRepository = MockApplicationRepository();
    addApplicationUsecase = AddApplicationUsecase(repository: mockRepository);
    getApplicationsForWorkerUsecase = GetApplicationsForWorkerUsecase(
      repository: mockRepository,
    );
    getApplicationsForRequestUsecase = GetApplicationsForRequestUsecase(
      repository: mockRepository,
    );

    provideDummy<Either<Failure, Unit>>(right(unit));
    provideDummy<Either<Failure, List<ApplicationEntity>>>(right([]));
  });

  // Datos de prueba
  const idWorker = 'worker_001';
  const idRequest = 'request_001';

  final applicationPending = ApplicationEntity(
    id: 'app_001',
    idworker: idWorker,
    idrequest: idRequest,
    state: 'pending',
  );

  final applicationInProgress = ApplicationEntity(
    id: 'app_002',
    idworker: idWorker,
    idrequest: 'request_002',
    state: 'in_progress',
  );

  final applicationFromOtherWorker = ApplicationEntity(
    id: 'app_003',
    idworker: 'worker_002',
    idrequest: idRequest,
    state: 'pending',
  );

  // ─────────────────────────────────────────────
  // TEST 1: Postularse a una solicitud
  // ─────────────────────────────────────────────
  group('Postularse a una solicitud (AddApplicationUsecase)', () {
    test(
      'éxito: debe retornar Right(unit) cuando la postulación se crea correctamente',
      () async {
        // Arrange
        when(
          mockRepository.addAplication(
            idWorker: idWorker,
            idRequest: idRequest,
          ),
        ).thenAnswer((_) async => right(unit));

        // Act
        final result = await addApplicationUsecase(
          idWorker: idWorker,
          idRequest: idRequest,
        );

        // Assert
        expect(result, right(unit));
        expect(result.isRight(), true);
        verify(
          mockRepository.addAplication(
            idWorker: idWorker,
            idRequest: idRequest,
          ),
        ).called(1);
      },
    );

    test(
      'fallo: debe retornar Left(FirebaseFailure) cuando ocurre un error en Firebase',
      () async {
        // Arrange
        const failure = FirebaseFailure(
          message: 'Error al guardar la postulación',
        );
        when(
          mockRepository.addAplication(
            idWorker: idWorker,
            idRequest: idRequest,
          ),
        ).thenAnswer((_) async => left(failure));

        // Act
        final result = await addApplicationUsecase(
          idWorker: idWorker,
          idRequest: idRequest,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((f) {
          expect(f, isA<FirebaseFailure>());
          expect(f.message, 'Error al guardar la postulación');
        }, (_) => fail('Debería retornar un Left con FirebaseFailure'));
        verify(
          mockRepository.addAplication(
            idWorker: idWorker,
            idRequest: idRequest,
          ),
        ).called(1);
      },
    );
  });

  // ─────────────────────────────────────────────
  // TEST 2: Trabajador ve sus postulaciones
  // ─────────────────────────────────────────────
  group('Trabajador ve sus postulaciones (GetApplicationsForWorkerUsecase)', () {
    test(
      'éxito: debe retornar Right con la lista de postulaciones del trabajador',
      () async {
        // Arrange
        final workerApplications = [applicationPending, applicationInProgress];
        when(
          mockRepository.getAppliForWorker(idWorker: idWorker),
        ).thenAnswer((_) async => right(workerApplications));

        // Act
        final result = await getApplicationsForWorkerUsecase(
          idWorker: idWorker,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Debería retornar una lista de postulaciones'),
          (applications) {
            expect(applications, isA<List<ApplicationEntity>>());
            expect(applications.length, 2);
            expect(applications.every((a) => a.idworker == idWorker), true);
            expect(applications[0].state, 'pending');
            expect(applications[1].state, 'in_progress');
          },
        );
        verify(mockRepository.getAppliForWorker(idWorker: idWorker)).called(1);
      },
    );

    test(
      'fallo: debe retornar Left(FirebaseFailure) cuando no se pueden obtener las postulaciones',
      () async {
        // Arrange
        const failure = FirebaseFailure(
          message: 'Error al obtener postulaciones del trabajador',
        );
        when(
          mockRepository.getAppliForWorker(idWorker: idWorker),
        ).thenAnswer((_) async => left(failure));

        // Act
        final result = await getApplicationsForWorkerUsecase(
          idWorker: idWorker,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((f) {
          expect(f, isA<FirebaseFailure>());
          expect(f.message, 'Error al obtener postulaciones del trabajador');
        }, (_) => fail('Debería retornar un Left con FirebaseFailure'));
        verify(mockRepository.getAppliForWorker(idWorker: idWorker)).called(1);
      },
    );
  });

  // ─────────────────────────────────────────────
  // TEST 3: Cliente ve postulaciones de su solicitud
  // ─────────────────────────────────────────────
  group(
    'Cliente ve postulaciones de su solicitud (GetApplicationsForRequestUsecase)',
    () {
      test(
        'éxito: debe retornar Right con todas las postulaciones de la solicitud',
        () async {
          // Arrange — dos trabajadores se postularon a la misma solicitud
          final requestApplications = [
            applicationPending,
            applicationFromOtherWorker,
          ];
          when(
            mockRepository.getAppliForRequest(idRequest: idRequest),
          ).thenAnswer((_) async => right(requestApplications));

          // Act
          final result = await getApplicationsForRequestUsecase(
            idRequest: idRequest,
          );

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Debería retornar una lista de postulaciones'),
            (applications) {
              expect(applications, isA<List<ApplicationEntity>>());
              expect(applications.length, 2);
              expect(applications.every((a) => a.idrequest == idRequest), true);
              // Verifica que son de trabajadores distintos
              final workerIds = applications.map((a) => a.idworker).toSet();
              expect(workerIds.length, 2);
            },
          );
          verify(
            mockRepository.getAppliForRequest(idRequest: idRequest),
          ).called(1);
        },
      );

      test(
        'fallo: debe retornar Left(FirebaseFailure) cuando no se pueden obtener las postulaciones de la solicitud',
        () async {
          // Arrange
          const failure = FirebaseFailure(
            message: 'Error al obtener postulaciones de la solicitud',
          );
          when(
            mockRepository.getAppliForRequest(idRequest: idRequest),
          ).thenAnswer((_) async => left(failure));

          // Act
          final result = await getApplicationsForRequestUsecase(
            idRequest: idRequest,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((f) {
            expect(f, isA<FirebaseFailure>());
            expect(f.message, 'Error al obtener postulaciones de la solicitud');
          }, (_) => fail('Debería retornar un Left con FirebaseFailure'));
          verify(
            mockRepository.getAppliForRequest(idRequest: idRequest),
          ).called(1);
        },
      );
    },
  );
}
