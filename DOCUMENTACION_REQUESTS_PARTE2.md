# Documentación del Sistema de Solicitudes - Parte 2

## Continuación de Estructura de Archivos

### Capa de Datos (Data Layer) - Continuación

#### `lib/features/requests/data/repository/request_impl.dart`

**Propósito**: Implementación concreta del repositorio usando Firebase Firestore.

```dart
class RequestImpl implements RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RequestImpl();

  @override
  Future<Either<Failure, List<RequestEntity>>> allRequest() async {
    try {
      // 1. Obtener todos los documentos de la colección 'requests'
      final snapshot = await _firestore.collection('requests').get();
      
      // 2. Convertir cada documento a RequestModel
      final requests = snapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      // 3. Retornar éxito con la lista
      return right(requests);
    } on SocketException {
      // Sin conexión a internet
      return left(const NetworkFailure());
    } on FirebaseException catch (e) {
      // Error de Firebase
      return left(
        FirebaseFailure(
          message: 'Error de Firebase: ${e.message ?? "Error desconocido"}',
          code: e.code,
        ),
      );
    } catch (e) {
      // Cualquier otro error
      return left(
        UnexpectedFailure(
          message: 'Error al obtener solicitudes: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request) async {
    try {
      // 1. Convertir entidad a modelo
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

      // 2. Guardar en Firestore
      await _firestore.collection('requests').add(requestModel.toMap());

      // 3. Retornar éxito
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
      // Eliminar documento de Firestore
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
}
```

**Manejo de errores**:
- `SocketException`: Sin conexión a internet
- `FirebaseException`: Errores de Firestore (permisos, etc.)
- `catch (e)`: Cualquier otro error inesperado

---

### Capa de Presentación (Presentation Layer)

#### `lib/features/requests/presentation/providers/request_notifier.dart`

**Propósito**: Gestiona el estado de las solicitudes usando Riverpod.

```dart
class RequestNotifier extends AsyncNotifier<List<RequestEntity>> {
  @override
  FutureOr<List<RequestEntity>> build() async {
    // Se ejecuta automáticamente al montar el provider
    final useCase = ref.read(getAllRequestsUseCaseProvider);
    final result = await useCase.call();

    return result.fold(
      (failure) => throw failure,  // Lanzar error para AsyncValue.error
      (requests) => requests,       // Retornar lista para AsyncValue.data
    );
  }

  // Registrar nueva solicitud
  Future<Failure?> registerRequest({required RequestEntity request}) async {
    final register = ref.read(registerRequestUseCaseProvider);

    state = const AsyncValue.loading();

    final result = await register.call(request);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) async {
        await _reloadRequests();
        return null;
      },
    );
  }

  // Eliminar solicitud
  Future<Failure?> deleteRequest({required String id}) async {
    final delete = ref.read(deleteRequestUseCaseProvider);

    state = const AsyncValue.loading();

    final result = await delete.call(id);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) async {
        await _reloadRequests();
        return null;
      },
    );
  }

  // Recargar lista de solicitudes
  Future<void> _reloadRequests() async {
    final useCase = ref.read(getAllRequestsUseCaseProvider);
    final result = await useCase.call();

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (requests) => AsyncValue.data(requests),
    );
  }

  // Refrescar manualmente (pull to refresh)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _reloadRequests();
  }
}
```

**¿Qué es AsyncNotifier?**
Es un notificador de Riverpod que maneja estados asíncronos:
- `AsyncValue.loading()`: Cargando
- `AsyncValue.data(T)`: Datos cargados
- `AsyncValue.error(error)`: Error

**Providers**:
```dart
// Provider del repositorio
final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => RequestImpl(),
);

// Provider de casos de uso
final getAllRequestsUseCaseProvider = Provider<GetAllRequestsUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return GetAllRequestsUseCase(repo);
});

final registerRequestUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return RegisterUseCase(repo);
});

final deleteRequestUseCaseProvider = Provider<DeletedRequestUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return DeletedRequestUseCase(repository: repo);
});

// Provider principal del notificador
final requestNotifierProvider =
    AsyncNotifierProvider<RequestNotifier, List<RequestEntity>>(
      RequestNotifier.new,
    );
```

---

#### `lib/features/requests/presentation/providers/request_filter_provider.dart`

**Propósito**: Gestiona el filtro seleccionado en la pantalla de solicitudes.

```dart
// Enum con los tipos de filtro
enum RequestFilterType {
  todos('Todos'),
  pendiente('Pendiente'),
  enProgreso('En progreso'),
  completado('Completado'),
  cancelado('Cancelado');

  final String label;
  const RequestFilterType(this.label);
}

// Provider del filtro seleccionado
final requestFilterProvider = StateProvider<RequestFilterType>(
  (ref) => RequestFilterType.todos,
);
```

**¿Qué es StateProvider?**
Es un provider simple para valores que pueden cambiar. Similar a `useState` en React.

**Uso**:
```dart
// Leer el filtro actual
final filter = ref.watch(requestFilterProvider);

// Cambiar el filtro
ref.read(requestFilterProvider.notifier).state = RequestFilterType.pendiente;
```

---

## Modelos de Datos

### Estructura en Firestore

#### Colección: `requests`

**Documento de Solicitud**:
```json
{
  "id": "auto_generated_id",
  "idClient": "uid_del_cliente",
  "title": "Reparación de grifo",
  "idTypeService": "Plomería",
  "details": "Tengo una fuga en el grifo de la cocina que necesita reparación urgente. El agua gotea constantemente.",
  "addres": "Calle 24 #17-21, Barrio Chapal, Pasto",
  "status": "pending",
  "dateCreated": "2026-04-08T10:30:00.000Z",
  "dateFinish": null
}
```

**Campos**:
- `id`: ID único generado por Firestore
- `idClient`: ID del usuario que creó la solicitud
- `title`: Título corto de la solicitud
- `idTypeService`: Categoría del servicio
- `details`: Descripción detallada del problema
- `addres`: Dirección donde se necesita el servicio
- `status`: Estado actual (pending, in_progress, completed, cancelled)
- `dateCreated`: Fecha y hora de creación (ISO 8601)
- `dateFinish`: Fecha y hora de finalización (null si no ha terminado)

---

### Estados de una Solicitud

```
┌──────────┐
│ PENDING  │ ← Estado inicial al crear
└────┬─────┘
     │
     │ Trabajador acepta
     │
     ▼
┌──────────────┐
│ IN_PROGRESS  │
└────┬─────────┘
     │
     ├──► Trabajo completado
     │    │
     │    ▼
     │  ┌───────────┐
     │  │ COMPLETED │
     │  └───────────┘
     │
     └──► Cliente cancela
          │
          ▼
        ┌───────────┐
        │ CANCELLED │
        └───────────┘
```

**Transiciones permitidas**:
- `pending` → `in_progress`: Trabajador acepta
- `pending` → `cancelled`: Cliente cancela
- `in_progress` → `completed`: Trabajo terminado
- `in_progress` → `cancelled`: Cliente cancela (con penalización)

---

## Manejo de Errores

### Tipos de Errores (Failures)

#### `lib/core/errors/failures.dart`

```dart
// Clase base abstracta
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => message;
}

// Error de red (sin internet)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Sin conexión a internet. Verifica tu red e intenta de nuevo.',
    super.code = 'network_error',
  });
}

// Error de validación
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'validation_error',
  });
}

// Error de Firebase
class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.message,
    super.code = 'firebase_error',
  });
}

// Error inesperado
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Ocurrió un error inesperado. Intenta de nuevo.',
    super.code = 'unexpected_error',
  });
}
```

### Manejo en la UI

```dart
// En los widgets
final requestsAsync = ref.watch(requestNotifierProvider);

requestsAsync.when(
  data: (requests) {
    // Mostrar lista de solicitudes
    return ListView.builder(...);
  },
  loading: () {
    // Mostrar indicador de carga
    return CircularProgressIndicator();
  },
  error: (error, stack) {
    // Mostrar mensaje de error
    return Text('Error: ${error.toString()}');
  },
);
```

### Mostrar Errores con SnackBar

```dart
if (failure != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(failure.message)),
        ],
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
```

---

## Validaciones

### Validaciones en el Caso de Uso

**RegisterUseCase**:
```dart
// Título no vacío
if (request.title.trim().isEmpty) {
  return left(ValidationFailure(message: 'El título es requerido'));
}

// Descripción no vacía
if (request.details.trim().isEmpty) {
  return left(ValidationFailure(message: 'La descripción es requerida'));
}

// Tipo de servicio seleccionado
if (request.idTypeService.trim().isEmpty) {
  return left(ValidationFailure(
    message: 'Debes seleccionar un tipo de servicio',
  ));
}
```

**DeletedRequestUseCase**:
```dart
// ID válido
if (requestId.trim().isEmpty) {
  return left(ValidationFailure(message: 'ID de solicitud inválido'));
}
```

### Validaciones en la UI

**CreateRequestScreen**:
```dart
bool get _isFormValid {
  return selectedCategory != null &&
      titleController.text.trim().isNotEmpty &&
      descriptionController.text.trim().isNotEmpty &&
      addressController.text.trim().isNotEmpty;
}

// Habilitar botón solo si el formulario es válido
ElevatedButton(
  onPressed: _isFormValid ? _handlePublish : null,
  child: Text('Publicar'),
)
```

---

## Funciones Auxiliares

### Mapeo de Estados

```dart
String _mapStatusToUI(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Pendiente';
    case 'in_progress':
      return 'En progreso';
    case 'completed':
      return 'Completado';
    case 'cancelled':
      return 'Cancelado';
    default:
      return 'Pendiente';
  }
}
```

**¿Por qué mapear?**
- Base de datos usa inglés: `pending`, `in_progress`
- UI muestra español: `Pendiente`, `En progreso`
- Separación de responsabilidades

---

### Formateo de Tiempo Relativo

```dart
String _formatTime(DateTime dateCreated) {
  final now = DateTime.now();
  final difference = now.difference(dateCreated);

  if (difference.inSeconds < 60) return 'Hace un momento';
  
  if (difference.inMinutes < 60) {
    return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"}';
  }
  
  if (difference.inHours < 24) {
    return 'Hace ${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"}';
  }
  
  if (difference.inDays < 7) {
    return 'Hace ${difference.inDays} ${difference.inDays == 1 ? "día" : "días"}';
  }
  
  if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return 'Hace $weeks ${weeks == 1 ? "semana" : "semanas"}';
  }
  
  final months = (difference.inDays / 30).floor();
  return 'Hace $months ${months == 1 ? "mes" : "meses"}';
}
```

**Ejemplos**:
- Hace 30 segundos → "Hace un momento"
- Hace 5 minutos → "Hace 5 minutos"
- Hace 2 horas → "Hace 2 horas"
- Hace 3 días → "Hace 3 días"
- Hace 2 semanas → "Hace 2 semanas"
- Hace 1 mes → "Hace 1 mes"

---

### Filtrado de Solicitudes

```dart
List<RequestEntity> _filterRequests(
  List<RequestEntity> requests,
  RequestFilterType filter,
  String userId,
) {
  // 1. Filtrar por usuario autenticado
  var filtered = requests.where((r) => r.idClient == userId).toList();

  // 2. Filtrar por estado seleccionado
  if (filter != RequestFilterType.todos) {
    filtered = filtered.where((r) {
      final uiStatus = _mapStatusToUI(r.status);
      return uiStatus == filter.label;
    }).toList();
  }

  // 3. Ordenar por fecha (más recientes primero)
  filtered.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

  return filtered;
}
```

**Pasos**:
1. Mostrar solo solicitudes del usuario actual
2. Aplicar filtro de estado (si no es "Todos")
3. Ordenar por fecha descendente

---

### Conteo por Estado

```dart
Map<RequestFilterType, int> _countByStatus(
  List<RequestEntity> requests,
  String userId,
) {
  final userRequests = requests.where((r) => r.idClient == userId).toList();

  return {
    RequestFilterType.todos: userRequests.length,
    RequestFilterType.pendiente: userRequests
        .where((r) => _mapStatusToUI(r.status) == 'Pendiente')
        .length,
    RequestFilterType.enProgreso: userRequests
        .where((r) => _mapStatusToUI(r.status) == 'En progreso')
        .length,
    RequestFilterType.completado: userRequests
        .where((r) => _mapStatusToUI(r.status) == 'Completado')
        .length,
    RequestFilterType.cancelado: userRequests
        .where((r) => _mapStatusToUI(r.status) == 'Cancelado')
        .length,
  };
}
```

**Uso**: Mostrar badges con el número de solicitudes en cada filtro.

---

Continúa en la Parte 3...
