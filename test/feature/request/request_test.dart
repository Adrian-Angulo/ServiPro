import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';
import 'package:servi_pro/features/requests/domain/useCase/deleted_request_use_case.dart';
import 'package:servi_pro/features/requests/domain/useCase/get_all_requests_use_case.dart';
import 'package:servi_pro/features/requests/domain/useCase/register_use_case.dart';

import 'request_test.mocks.dart';

@GenerateMocks([RequestRepository])
void main() {
  late MockRequestRepository mockRepository;
  late RegisterUseCase registerUseCase;
  late GetAllRequestsUseCase getAllRequestsUseCase;
  late DeletedRequestUseCase deletedRequestUseCase;

  setUp(() {
    mockRepository = MockRequestRepository();
    registerUseCase = RegisterUseCase(mockRepository);
    getAllRequestsUseCase = GetAllRequestsUseCase(mockRepository);
    deletedRequestUseCase = DeletedRequestUseCase(repository: mockRepository);

    // Proporcionar valores dummy para Either
    provideDummy<Either<Failure, Unit>>(right(unit));
    provideDummy<Either<Failure, List<RequestEntity>>>(right([]));
  });

  final request = RequestEntity(
    idClient: 'Usuario1',
    idTypeService: "Plomeria",
    details: "Se necesita reparar una tuberia rota",
    addres: "Calle 123 #45-67",
    title: "Reparacion de tuberia",
  );

  final request2 = RequestEntity(
    id: 'request123',
    idClient: 'Usuario1',
    idTypeService: "Electricidad",
    details: "Instalacion de lampara",
    addres: "Calle 456 #78-90",
    title: "Instalacion electrica",
  );

  group("Gestión de solicitudes", () {
    group("Crear solicitud", () {
      test(
        'deberia retornar Right(unit) cuando la creacion de una solicitud sea exitosa',
        () async {
          // Arrange: Configurar el mock
          when(
            mockRepository.registerRequest(request),
          ).thenAnswer((_) async => right(unit));

          // Act: Ejecutar el caso de uso
          final result = await registerUseCase(request);

          // Assert: Verificar el resultado
          expect(result, right(unit));
          verify(mockRepository.registerRequest(request)).called(1);
        },
      );

      test(
        'deberia retornar Right(List<RequestEntity>) al consultar todas las solicitudes',
        () async {
          // Arrange: Crear lista de solicitudes de prueba
          final requestsList = [request, request2];

          when(
            mockRepository.allRequest(),
          ).thenAnswer((_) async => right(requestsList));

          // Act: Ejecutar el caso de uso
          final result = await getAllRequestsUseCase();

          // Assert: Verificar el resultado
          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Deberia retornar una lista de solicitudes'),
            (requests) {
              expect(requests, isA<List<RequestEntity>>());
              expect(requests.length, 2);
              expect(requests[0].title, "Reparacion de tuberia");
              expect(requests[1].title, "Instalacion electrica");
            },
          );

          verify(mockRepository.allRequest()).called(1);
        },
      );



      test('deberia filtrar solicitudes por usuario correctamente', () async {
        // Arrange: Crear solicitudes de diferentes usuarios
        final requestsList = [
          request, // Usuario1
          request2, // Usuario1
          RequestEntity(
            id: 'request456',
            idClient: 'Usuario2',
            idTypeService: "Carpinteria",
            details: "Reparacion de puerta",
            addres: "Calle 789",
            title: "Reparacion",
          ),
        ];

        when(
          mockRepository.allRequest(),
        ).thenAnswer((_) async => right(requestsList));

        // Act: Ejecutar el caso de uso con filtro por usuario
        final result = await getAllRequestsUseCase.getByUserId('Usuario1');

        // Assert: Verificar que solo retorna solicitudes del Usuario1
        expect(result.isRight(), true);
        result.fold((_) => fail('Deberia retornar solicitudes filtradas'), (
          requests,
        ) {
          expect(requests.length, 2);
          expect(requests.every((r) => r.idClient == 'Usuario1'), true);
        });

        verify(mockRepository.allRequest()).called(1);
      });

      test(
        'deberia retornar Right(unit) al cancelar una solicitud exitosamente',
        () async {
          // Arrange: Configurar el mock
          const requestId = 'request123';
          when(
            mockRepository.deleteRequest(requestId),
          ).thenAnswer((_) async => right(unit));

          // Act: Ejecutar el caso de uso
          final result = await deletedRequestUseCase(requestId);

          // Assert: Verificar el resultado
          expect(result, right(unit));
          verify(mockRepository.deleteRequest(requestId)).called(1);
        },
      );

      
    });
  });
}
