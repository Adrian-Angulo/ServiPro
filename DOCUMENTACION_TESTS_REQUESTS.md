# Documentación de Pruebas Unitarias - Feature Requests

## Índice
1. [Introducción a las Pruebas Unitarias](#introducción-a-las-pruebas-unitarias)
2. [Configuración del Entorno de Pruebas](#configuración-del-entorno-de-pruebas)
3. [Estructura de los Tests](#estructura-de-los-tests)
4. [Casos de Prueba Implementados](#casos-de-prueba-implementados)
5. [Conceptos Clave](#conceptos-clave)
6. [Ejecución de Tests](#ejecución-de-tests)
7. [Mejores Prácticas](#mejores-prácticas)

---

## Introducción a las Pruebas Unitarias

Las pruebas unitarias son fragmentos de código que verifican que una unidad específica de tu aplicación (como una función o clase) funcione correctamente de forma aislada.

### ¿Por qué son importantes?

- ✅ **Detectan errores temprano**: Encuentran bugs antes de que lleguen a producción
- ✅ **Documentación viva**: Los tests muestran cómo usar el código
- ✅ **Refactorización segura**: Puedes cambiar código con confianza
- ✅ **Diseño mejor**: Código testeable suele ser código bien diseñado

### Tecnologías Utilizadas

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0           # Para crear mocks (objetos simulados)
  build_runner: ^2.4.0      # Para generar código automáticamente
  fpdart: ^1.1.0            # Para programación funcional (Either)
```

---

## Configuración del Entorno de Pruebas

### 1. Estructura de Archivos

```
test/
└── feature/
    └── request/
        ├── request_test.dart        # Tests principales
        └── request_test.mocks.dart  # Mocks generados automáticamente
```

### 2. Imports Necesarios

```dart
import 'package:flutter_test/flutter_test.dart';  // Framework de testing
import 'package:fpdart/fpdart.dart';              // Either, Unit, right, left
import 'package:mockito/annotations.dart';        // @GenerateMocks
import 'package:mockito/mockito.dart';            // when, verify, provideDummy
```

### 3. Generación de Mocks

Los **mocks** son objetos simulados que imitan el comportamiento de objetos reales.

```dart
// Anotación que le dice a Mockito qué clases simular
@GenerateMocks([RequestRepository])
void main() {
  // Los tests van aquí
}
```

**Generar los mocks**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Esto crea automáticamente `request_test.mocks.dart` con la clase `MockRequestRepository`.

### 4. Configuración Inicial (setUp)

```dart
void main() {
  late MockRequestRepository mockRepository;
  late RegisterUseCase registerUseCase;
  late GetAllRequestsUseCase getAllRequestsUseCase;
  late DeletedRequestUseCase deletedRequestUseCase;

  setUp(() {
    // Se ejecuta ANTES de cada test
    mockRepository = MockRequestRepository();
    registerUseCase = RegisterUseCase(mockRepository);
    getAllRequestsUseCase = GetAllRequestsUseCase(mockRepository);
    deletedRequestUseCase = DeletedRequestUseCase(repository: mockRepository);

    // Valores dummy para tipos genéricos
    provideDummy<Either<Failure, Unit>>(right(unit));
    provideDummy<Either<Failure, List<RequestEntity>>>(right([]));
  });
}
```

**¿Qué es `setUp`?**
- Función que se ejecuta antes de cada test
- Inicializa objetos que todos los tests necesitan
- Garantiza que cada test empiece con un estado limpio

**¿Qué es `provideDummy`?**
- Mockito necesita valores "dummy" para tipos genéricos como `Either<Failure, Unit>`
- Le decimos qué valor usar cuando necesite crear una instancia de ese tipo

---

## Estructura de los Tests

### Patrón AAA (Arrange-Act-Assert)

Todos los tests siguen este patrón de 3 pasos:

```dart
test('descripción del test', () async {
  // 1. ARRANGE (Preparar)
  // Configurar datos de prueba y comportamiento de mocks
  when(mockRepository.registerRequest(request))
      .thenAnswer((_) async => right(unit));

  // 2. ACT (Actuar)
  // Ejecutar la función que queremos probar
  final result = await registerUseCase(request);

  // 3. ASSERT (Afirmar)
  // Verificar que el resultado es el esperado
  expect(result, right(unit));
  verify(mockRepository.registerRequest(request)).called(1);
});
```

### Anatomía de un Test

```dart
test(
  'descripción clara de lo que se prueba',  // ← Nombre descriptivo
  () async {                                 // ← Función asíncrona
    // Código del test
  },
);
```

### Grupos de Tests

Los tests se organizan en grupos lógicos:

```dart
group("Gestión de solicitudes", () {
  group("Crear solicitud", () {
    test('caso 1', () {});
    test('caso 2', () {});
  });
  
  group("Consultar solicitudes", () {
    test('caso 1', () {});
  });
});
```

---

## Casos de Prueba Implementados

### Grupo 1: Crear Solicitud (4 tests)

#### Test 1.1: Creación Exitosa

```dart
test('deberia retornar Right(unit) cuando la creacion de una solicitud sea exitosa',
  () async {
    // ARRANGE: Configurar el mock para simular éxito
    when(mockRepository.registerRequest(request))
        .thenAnswer((_) async => right(unit));

    // ACT: Ejecutar el caso de uso
    final result = await registerUseCase(request);

    // ASSERT: Verificar que retorna éxito
    expect(result, right(unit));
    verify(mockRepository.registerRequest(request)).called(1);
  },
);
```

**¿Qué verifica?**
- ✅ El caso de uso retorna `Right(unit)` (éxito)
- ✅ El repositorio fue llamado exactamente 1 vez
- ✅ Se pasaron los datos correctos al repositorio

**Conceptos**:
- `when(...).thenAnswer(...)`: Configura el comportamiento del mock
- `right(unit)`: Representa éxito en programación funcional
- `verify(...).called(1)`: Verifica que se llamó la función 1 vez

---

#### Test 1.2: Error - Título Vacío

```dart
test('deberia retornar Left(ValidationFailure) cuando el titulo esta vacio',
  () async {
    // ARRANGE: Crear solicitud inválida
    final invalidRequest = RequestEntity(
      idClient: 'Usuario1',
      idTypeService: "Plomeria",
      details: "Detalles validos",
      addres: "Direccion valida",
      title: "",  // ← Título vacío (inválido)
    );

    // ACT: Ejecutar el caso de uso
    final result = await registerUseCase(invalidRequest);

    // ASSERT: Verificar que retorna error
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'El título es requerido');
      },
      (_) => fail('Deberia retornar un error'),
    );

    // Verificar que NO se llamó al repositorio
    verifyNever(mockRepository.registerRequest(invalidRequest));
  },
);
```

**¿Qué verifica?**
- ✅ Retorna `Left(ValidationFailure)` (error)
- ✅ El mensaje de error es correcto
- ✅ NO se llamó al repositorio (validación temprana)

**Conceptos**:
- `result.isLeft()`: Verifica que es un error
- `result.fold(...)`: Maneja ambos casos (error y éxito)
- `isA<ValidationFailure>()`: Verifica el tipo de error
- `verifyNever(...)`: Verifica que NUNCA se llamó la función

---

#### Test 1.3: Error - Descripción Vacía

```dart
test('deberia retornar Left(ValidationFailure) cuando la descripcion esta vacia',
  () async {
    // ARRANGE
    final invalidRequest = RequestEntity(
      idClient: 'Usuario1',
      idTypeService: "Plomeria",
      details: "",  // ← Descripción vacía
      addres: "Direccion valida",
      title: "Titulo valido",
    );

    // ACT
    final result = await registerUseCase(invalidRequest);

    // ASSERT
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'La descripción es requerida');
      },
      (_) => fail('Deberia retornar un error'),
    );

    verifyNever(mockRepository.registerRequest(invalidRequest));
  },
);
```

**¿Qué verifica?**
- ✅ Valida que la descripción no esté vacía
- ✅ Mensaje de error específico
- ✅ No se ejecuta lógica innecesaria

---

#### Test 1.4: Error - Tipo de Servicio Vacío

```dart
test('deberia retornar Left(ValidationFailure) cuando el tipo de servicio esta vacio',
  () async {
    // ARRANGE
    final invalidRequest = RequestEntity(
      idClient: 'Usuario1',
      idTypeService: "",  // ← Tipo de servicio vacío
      details: "Detalles validos",
      addres: "Direccion valida",
      title: "Titulo valido",
    );

    // ACT
    final result = await registerUseCase(invalidRequest);

    // ASSERT
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Debes seleccionar un tipo de servicio');
      },
      (_) => fail('Deberia retornar un error'),
    );

    verifyNever(mockRepository.registerRequest(invalidRequest));
  },
);
```

---

### Grupo 2: Consultar Solicitudes (3 tests)

#### Test 2.1: Obtener Todas las Solicitudes

```dart
test('deberia retornar Right(List<RequestEntity>) al consultar todas las solicitudes',
  () async {
    // ARRANGE: Crear lista de solicitudes de prueba
    final requestsList = [request, request2];

    when(mockRepository.allRequest())
        .thenAnswer((_) async => right(requestsList));

    // ACT: Ejecutar el caso de uso
    final result = await getAllRequestsUseCase();

    // ASSERT: Verificar el resultado
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
```

**¿Qué verifica?**
- ✅ Retorna una lista de solicitudes
- ✅ La lista tiene el número correcto de elementos
- ✅ Los datos de las solicitudes son correctos

**Conceptos**:
- `result.isRight()`: Verifica que es éxito
- `result.fold(onLeft, onRight)`: Ejecuta función según el resultado
- Verificación de propiedades individuales de los objetos

---

#### Test 2.2: Lista Vacía

```dart
test('deberia retornar Right(List vacia) cuando no hay solicitudes',
  () async {
    // ARRANGE: Configurar mock para retornar lista vacía
    when(mockRepository.allRequest())
        .thenAnswer((_) async => right([]));

    // ACT
    final result = await getAllRequestsUseCase();

    // ASSERT: Verificar que retorna lista vacía
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Deberia retornar una lista vacia'),
      (requests) {
        expect(requests, isA<List<RequestEntity>>());
        expect(requests.isEmpty, true);
      },
    );

    verify(mockRepository.allRequest()).called(1);
  },
);
```

**¿Qué verifica?**
- ✅ Maneja correctamente el caso de lista vacía
- ✅ No lanza excepciones con lista vacía

---

#### Test 2.3: Filtrar por Usuario

```dart
test('deberia filtrar solicitudes por usuario correctamente',
  () async {
    // ARRANGE: Crear solicitudes de diferentes usuarios
    final requestsList = [
      request,   // Usuario1
      request2,  // Usuario1
      RequestEntity(
        id: 'request456',
        idClient: 'Usuario2',  // ← Usuario diferente
        idTypeService: "Carpinteria",
        details: "Reparacion de puerta",
        addres: "Calle 789",
        title: "Reparacion",
      ),
    ];

    when(mockRepository.allRequest())
        .thenAnswer((_) async => right(requestsList));

    // ACT: Filtrar por Usuario1
    final result = await getAllRequestsUseCase.getByUserId('Usuario1');

    // ASSERT: Solo solicitudes del Usuario1
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Deberia retornar solicitudes filtradas'),
      (requests) {
        expect(requests.length, 2);
        expect(requests.every((r) => r.idClient == 'Usuario1'), true);
      },
    );

    verify(mockRepository.allRequest()).called(1);
  },
);
```

**¿Qué verifica?**
- ✅ El filtrado por usuario funciona correctamente
- ✅ Solo retorna solicitudes del usuario especificado
- ✅ No incluye solicitudes de otros usuarios

**Conceptos**:
- `requests.every(...)`: Verifica que TODOS los elementos cumplan una condición

---

### Grupo 3: Cancelar Solicitud (4 tests)

#### Test 3.1: Cancelación Exitosa

```dart
test('deberia retornar Right(unit) al cancelar una solicitud exitosamente',
  () async {
    // ARRANGE
    const requestId = 'request123';
    when(mockRepository.deleteRequest(requestId))
        .thenAnswer((_) async => right(unit));

    // ACT
    final result = await deletedRequestUseCase(requestId);

    // ASSERT
    expect(result, right(unit));
    verify(mockRepository.deleteRequest(requestId)).called(1);
  },
);
```

**¿Qué verifica?**
- ✅ La eliminación exitosa retorna `Right(unit)`
- ✅ Se llama al repositorio con el ID correcto

---

#### Test 3.2: Error - ID Vacío

```dart
test('deberia retornar Left(ValidationFailure) cuando el ID esta vacio',
  () async {
    // ARRANGE
    const emptyId = '';

    // ACT
    final result = await deletedRequestUseCase(emptyId);

    // ASSERT
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'ID de solicitud inválido');
      },
      (_) => fail('Deberia retornar un error'),
    );

    verifyNever(mockRepository.deleteRequest(emptyId));
  },
);
```

**¿Qué verifica?**
- ✅ Valida que el ID no esté vacío
- ✅ No intenta eliminar con ID inválido

---

#### Test 3.3: Error - ID con Solo Espacios

```dart
test('deberia retornar Left(ValidationFailure) cuando el ID solo tiene espacios',
  () async {
    // ARRANGE
    const invalidId = '   ';

    // ACT
    final result = await deletedRequestUseCase(invalidId);

    // ASSERT
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'ID de solicitud inválido');
      },
      (_) => fail('Deberia retornar un error'),
    );

    verifyNever(mockRepository.deleteRequest(invalidId));
  },
);
```

**¿Qué verifica?**
- ✅ Valida que el ID no sea solo espacios en blanco
- ✅ Usa `.trim()` para validar correctamente

---

#### Test 3.4: Error del Repositorio

```dart
test('deberia retornar Left(Failure) cuando falla la eliminacion en el repositorio',
  () async {
    // ARRANGE: Simular error de Firestore
    const requestId = 'request123';
    const errorMessage = 'Error al eliminar de Firestore';
    
    when(mockRepository.deleteRequest(requestId)).thenAnswer(
      (_) async => left(
        const UnexpectedFailure(message: errorMessage),
      ),
    );

    // ACT
    final result = await deletedRequestUseCase(requestId);

    // ASSERT: Verificar que propaga el error
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<UnexpectedFailure>());
        expect(failure.message, errorMessage);
      },
      (_) => fail('Deberia retornar un error'),
    );

    verify(mockRepository.deleteRequest(requestId)).called(1);
  },
);
```

**¿Qué verifica?**
- ✅ Propaga correctamente errores del repositorio
- ✅ El tipo de error se mantiene
- ✅ El mensaje de error es el correcto

---

## Conceptos Clave

### 1. Mocking (Simulación)

**¿Qué es un Mock?**
Un mock es un objeto falso que simula el comportamiento de un objeto real.

```dart
// Objeto real (no lo usamos en tests)
final realRepository = RequestImpl();

// Mock (lo usamos en tests)
final mockRepository = MockRequestRepository();
```

**¿Por qué usar mocks?**
- ❌ No queremos llamar a Firestore real en tests
- ❌ No queremos depender de internet
- ✅ Queremos tests rápidos y predecibles
- ✅ Queremos controlar el comportamiento

**Configurar comportamiento**:
```dart
// Simular éxito
when(mockRepository.allRequest())
    .thenAnswer((_) async => right([request1, request2]));

// Simular error
when(mockRepository.allRequest())
    .thenAnswer((_) async => left(NetworkFailure()));
```

---

### 2. Either (Programación Funcional)

`Either` es un tipo que representa un valor que puede ser de dos tipos: `Left` (error) o `Right` (éxito).

```dart
// Éxito
Either<Failure, Unit> success = right(unit);

// Error
Either<Failure, Unit> error = left(ValidationFailure(message: 'Error'));
```

**Verificar el tipo**:
```dart
result.isLeft()   // true si es error
result.isRight()  // true si es éxito
```

**Manejar ambos casos**:
```dart
result.fold(
  (failure) {
    // Manejar error
    print('Error: ${failure.message}');
  },
  (success) {
    // Manejar éxito
    print('Éxito!');
  },
);
```

---

### 3. Aserciones (Assertions)

Las aserciones verifican que algo sea verdadero.

```dart
// Verificar igualdad
expect(result, right(unit));

// Verificar tipo
expect(failure, isA<ValidationFailure>());

// Verificar booleano
expect(result.isLeft(), true);

// Verificar lista
expect(requests.length, 2);
expect(requests.isEmpty, false);

// Verificar condición
expect(requests.every((r) => r.idClient == 'Usuario1'), true);
```

---

### 4. Verificación de Llamadas

Verificar que los mocks fueron llamados correctamente.

```dart
// Verificar que se llamó 1 vez
verify(mockRepository.registerRequest(request)).called(1);

// Verificar que NUNCA se llamó
verifyNever(mockRepository.registerRequest(invalidRequest));

// Verificar que se llamó al menos 1 vez
verify(mockRepository.allRequest()).called(greaterThan(0));
```

---

### 5. Funciones Asíncronas

En Flutter, muchas operaciones son asíncronas (toman tiempo).

```dart
// Función asíncrona
test('mi test', () async {  // ← async
  final result = await useCase();  // ← await
  expect(result, right(unit));
});
```

**Reglas**:
- Si usas `await`, la función debe ser `async`
- Siempre espera (`await`) el resultado antes de hacer `expect`

---

## Ejecución de Tests

### Ejecutar Todos los Tests

```bash
flutter test
```

### Ejecutar Tests Específicos

```bash
# Un archivo específico
flutter test test/feature/request/request_test.dart

# Tests que coincidan con un patrón
flutter test --name "crear solicitud"
```

### Ejecutar con Cobertura

```bash
flutter test --coverage
```

Esto genera un reporte de qué porcentaje del código está cubierto por tests.

### Ver Resultados

```
00:01 +11: All tests passed!
```

- `+11`: 11 tests pasaron
- `-0`: 0 tests fallaron

---

## Mejores Prácticas

### 1. Nombres Descriptivos

```dart
// ❌ MAL
test('test 1', () {});

// ✅ BIEN
test('deberia retornar Right(unit) cuando la creacion sea exitosa', () {});
```

### 2. Un Concepto por Test

```dart
// ❌ MAL - Prueba múltiples cosas
test('crear y eliminar solicitud', () {
  // Crear
  // Eliminar
});

// ✅ BIEN - Un test por concepto
test('deberia crear solicitud', () {});
test('deberia eliminar solicitud', () {});
```

### 3. Tests Independientes

Cada test debe poder ejecutarse solo, sin depender de otros.

```dart
// ❌ MAL - Depende de estado compartido
var solicitudId;
test('crear', () { solicitudId = '123'; });
test('eliminar', () { delete(solicitudId); });

// ✅ BIEN - Cada test es independiente
test('crear', () {
  final id = '123';
  // ...
});
test('eliminar', () {
  final id = '123';
  // ...
});
```

### 4. Probar Casos Límite

```dart
// Casos normales
test('con datos válidos', () {});

// Casos límite
test('con string vacío', () {});
test('con solo espacios', () {});
test('con null', () {});
test('con lista vacía', () {});
```

### 5. Usar setUp y tearDown

```dart
setUp(() {
  // Se ejecuta ANTES de cada test
  mockRepository = MockRequestRepository();
});

tearDown(() {
  // Se ejecuta DESPUÉS de cada test
  // Limpiar recursos si es necesario
});
```

### 6. Comentarios Claros

```dart
test('mi test', () async {
  // ARRANGE: Preparar datos
  final request = RequestEntity(...);
  
  // ACT: Ejecutar función
  final result = await useCase(request);
  
  // ASSERT: Verificar resultado
  expect(result, right(unit));
});
```

---

## Cobertura de Tests

### Tests Implementados: 11

| Funcionalidad | Tests | Cobertura |
|--------------|-------|-----------|
| Crear Solicitud | 4 | ✅ Completa |
| Consultar Solicitudes | 3 | ✅ Completa |
| Cancelar Solicitud | 4 | ✅ Completa |

### Casos Cubiertos

**Casos de Éxito**:
- ✅ Crear solicitud válida
- ✅ Obtener todas las solicitudes
- ✅ Obtener lista vacía
- ✅ Filtrar por usuario
- ✅ Cancelar solicitud

**Casos de Error**:
- ✅ Título vacío
- ✅ Descripción vacía
- ✅ Tipo de servicio vacío
- ✅ ID vacío
- ✅ ID con espacios
- ✅ Error del repositorio

---

## Troubleshooting (Solución de Problemas)

### Error: "MissingDummyValueError"

```
MissingDummyValueError: Either<Failure, Unit>
```

**Solución**: Agregar `provideDummy` en `setUp`:
```dart
provideDummy<Either<Failure, Unit>>(right(unit));
```

---

### Error: "Expected to find ';'"

```dart
// ❌ MAL
expect(() async => await useCase(), right(unit));

// ✅ BIEN
final result = await useCase();
expect(result, right(unit));
```

---

### Error: Tests no se ejecutan

**Verificar**:
1. El archivo está en la carpeta `test/`
2. El archivo termina en `_test.dart`
3. Hay una función `main()`
4. Los tests están dentro de `test()` o `group()`

---

### Error: Mock no funciona

```dart
// ❌ MAL - Falta .thenAnswer()
when(mockRepository.allRequest());

// ✅ BIEN
when(mockRepository.allRequest())
    .thenAnswer((_) async => right([]));
```

---

## Comandos Útiles

```bash
# Generar mocks
dart run build_runner build --delete-conflicting-outputs

# Ejecutar todos los tests
flutter test

# Ejecutar un archivo específico
flutter test test/feature/request/request_test.dart

# Ejecutar con cobertura
flutter test --coverage

# Ver cobertura en HTML
genhtml coverage/lcov.info -o coverage/html
```

---

## Recursos Adicionales

### Documentación Oficial
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Mockito](https://pub.dev/packages/mockito)
- [fpdart](https://pub.dev/packages/fpdart)

### Conceptos Relacionados
- Clean Architecture
- Test-Driven Development (TDD)
- Programación Funcional
- Dependency Injection

---

## Conclusión

Los tests unitarios son una parte fundamental del desarrollo de software profesional. Estos 11 tests cubren completamente la funcionalidad del feature de requests, garantizando que:

1. ✅ Las validaciones funcionan correctamente
2. ✅ Los casos de éxito retornan los datos esperados
3. ✅ Los errores se manejan apropiadamente
4. ✅ El código es robusto y confiable

**Próximos pasos**:
- Agregar tests de integración
- Agregar tests de widgets
- Implementar tests para otros features
- Configurar CI/CD para ejecutar tests automáticamente

---

**Última actualización**: Abril 2026
**Autor**: Equipo ServiPro
**Tests totales**: 11 ✅
