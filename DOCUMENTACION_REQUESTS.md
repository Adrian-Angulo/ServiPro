# Documentación del Sistema de Solicitudes (Requests) - ServiPro

## Índice
1. [Arquitectura General](#arquitectura-general)
2. [Flujo de Solicitudes](#flujo-de-solicitudes)
3. [Estructura de Archivos](#estructura-de-archivos)
4. [Modelos de Datos](#modelos-de-datos)
5. [Casos de Uso](#casos-de-uso)
6. [Manejo de Errores](#manejo-de-errores)
7. [Pantallas y Widgets](#pantallas-y-widgets)

---

## Arquitectura General

El sistema de solicitudes (requests) permite a los clientes crear, consultar y cancelar solicitudes de servicios. Sigue una arquitectura limpia (Clean Architecture) con las siguientes capas:

```
lib/features/requests/
├── data/
│   ├── models/              # Modelos de datos para Firestore
│   │   ├── request_model.dart
│   │   ├── application_model.dart
│   │   └── type_services.dart
│   └── repository/          # Implementación de repositorios
│       ├── request_impl.dart
│       └── type_services_repository_impl.dart
├── domain/
│   ├── entities/            # Entidades del dominio
│   │   └── request_entity.dart
│   ├── repository/          # Interfaces de repositorios
│   │   ├── request_repository.dart
│   │   └── type_services_repository.dart
│   └── useCase/             # Casos de uso del negocio
│       ├── register_use_case.dart
│       ├── get_all_requests_use_case.dart
│       └── deleted_request_use_case.dart
└── presentation/
    ├── providers/           # Estado con Riverpod
    │   ├── request_notifier.dart
    │   ├── request_filter_provider.dart
    │   └── map_notifier.dart
    ├── screens/             # Pantallas de UI
    │   ├── create_request_screen.dart
    │   ├── mis_solicitudes_screen.dart
    │   └── ver_detalles_solicitud_screen.dart
    └── widgets/             # Componentes reutilizables
        ├── request_card.dart
        ├── request_filter_chip.dart
        ├── empty_requests_widget.dart
        └── [otros widgets...]
```

### Tecnologías Utilizadas
- **Firebase Firestore**: Base de datos NoSQL para almacenar solicitudes
- **Riverpod**: Gestión de estado reactivo
- **fpdart**: Programación funcional (Either para manejo de errores)
- **Flutter**: Framework de UI

### Principios de Clean Architecture

**¿Qué es Clean Architecture?**
Es un patrón de diseño que separa el código en capas independientes:

1. **Domain (Dominio)**: Lógica de negocio pura, sin dependencias externas
2. **Data (Datos)**: Implementación de acceso a datos (Firestore, APIs, etc.)
3. **Presentation (Presentación)**: UI y gestión de estado

**Ventajas**:
- ✅ Código testeable (puedes probar sin Firebase)
- ✅ Fácil de mantener y extender
- ✅ Independiente de frameworks externos
- ✅ Reutilizable

---

## Flujo de Solicitudes

### 1. Flujo de Creación de Solicitud

```
┌─────────────────────────┐
│  Cliente en Home        │
│  Screen                 │
└────────┬────────────────┘
         │
         │ Presiona "Solicitar Servicio"
         │
         ▼
┌─────────────────────────┐
│  CreateRequestScreen    │
│                         │
│  1. Selecciona categoría│
│     (Plomería,          │
│      Electricidad, etc.)│
│                         │
│  2. Ingresa título      │
│                         │
│  3. Describe problema   │
│                         │
│  4. Ingresa dirección   │
└────────┬────────────────┘
         │
         │ Presiona "Publicar"
         │
         ▼
┌─────────────────────────┐
│  RequestNotifier        │
│  .registerRequest()     │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  RegisterUseCase        │
│  .call()                │
└────────┬────────────────┘
         │
         ├──► Validar título (no vacío)
         ├──► Validar descripción (no vacía)
         ├──► Validar tipo de servicio (seleccionado)
         │
         ▼
┌─────────────────────────┐
│  RequestRepository      │
│  Impl                   │
└────────┬────────────────┘
         │
         ├──► 1. Convertir RequestEntity a RequestModel
         │
         ├──► 2. Firestore: collection('requests').add()
         │
         └──► 3. Retornar Right(unit) si éxito
                │
                ▼
         ┌─────────────────────────┐
         │  SnackBar: "Solicitud   │
         │  publicada exitosamente"│
         └─────────────────────────┘
                │
                ▼
         ┌─────────────────────────┐
         │  Navegar de vuelta      │
         │  a Home                 │
         └─────────────────────────┘
```

**Datos guardados en Firestore**:
```json
{
  "idClient": "uid_del_usuario",
  "title": "Reparación de grifo",
  "idTypeService": "Plomería",
  "details": "Tengo una fuga en el grifo de la cocina...",
  "addres": "Calle 24 #17-21, Barrio Chapal",
  "status": "pending",
  "dateCreated": "2026-04-08T10:30:00.000Z",
  "dateFinish": null
}
```

---

### 2. Flujo de Consulta de Solicitudes

```
┌─────────────────────────┐
│  Cliente navega a       │
│  "Mis Solicitudes"      │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  MisSolicitudesScreen   │
│  (se monta)             │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  RequestNotifier        │
│  .build()               │ ← Se ejecuta automáticamente
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  GetAllRequestsUseCase  │
│  .call()                │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  RequestRepository      │
│  Impl                   │
└────────┬────────────────┘
         │
         ├──► 1. Firestore: collection('requests').get()
         │
         ├──► 2. Convertir docs a List<RequestModel>
         │
         └──► 3. Retornar Right(List<RequestEntity>)
                │
                ▼
         ┌─────────────────────────┐
         │  Filtrar por usuario    │
         │  (idClient == userId)   │
         └────────┬────────────────┘
                  │
                  ▼
         ┌─────────────────────────┐
         │  Aplicar filtro de      │
         │  estado seleccionado    │
         │  (Todos, Pendiente,     │
         │   En progreso, etc.)    │
         └────────┬────────────────┘
                  │
                  ▼
         ┌─────────────────────────┐
         │  Ordenar por fecha      │
         │  (más recientes primero)│
         └────────┬────────────────┘
                  │
                  ▼
         ┌─────────────────────────┐
         │  Mostrar lista de       │
         │  RequestCards           │
         └─────────────────────────┘
```

**Estados posibles**:
- `AsyncValue.loading()`: Cargando solicitudes
- `AsyncValue.data(List<RequestEntity>)`: Solicitudes cargadas
- `AsyncValue.error(error)`: Error al cargar

---

### 3. Flujo de Cancelación de Solicitud

```
┌─────────────────────────┐
│  Usuario en             │
│  MisSolicitudesScreen   │
└────────┬────────────────┘
         │
         │ Presiona "Cancelar Solicitud"
         │ en un RequestCard
         │
         ▼
┌─────────────────────────┐
│  Mostrar AlertDialog    │
│  "¿Cancelar solicitud?" │
└────────┬────────────────┘
         │
         │ Usuario confirma
         │
         ▼
┌─────────────────────────┐
│  RequestNotifier        │
│  .deleteRequest()       │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  DeletedRequestUseCase  │
│  .call(requestId)       │
└────────┬────────────────┘
         │
         ├──► Validar ID (no vacío)
         │
         ▼
┌─────────────────────────┐
│  RequestRepository      │
│  Impl                   │
└────────┬────────────────┘
         │
         ├──► 1. Firestore: collection('requests').doc(id).delete()
         │
         └──► 2. Retornar Right(unit) si éxito
                │
                ▼
         ┌─────────────────────────┐
         │  Recargar lista de      │
         │  solicitudes            │
         └────────┬────────────────┘
                  │
                  ▼
         ┌─────────────────────────┐
         │  SnackBar: "Solicitud   │
         │  cancelada"             │
         └─────────────────────────┘
```

---

### 4. Flujo de Filtrado de Solicitudes

```
┌─────────────────────────┐
│  Usuario selecciona     │
│  filtro (ej: Pendiente) │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  requestFilterProvider  │
│  .state = Pendiente     │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  Widget se reconstruye  │
│  (Riverpod detecta      │
│   cambio de estado)     │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  _filterRequests()      │
│                         │
│  1. Filtrar por usuario │
│  2. Filtrar por estado  │
│  3. Ordenar por fecha   │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  Mostrar solo           │
│  solicitudes pendientes │
└─────────────────────────┘
```

---

## Estructura de Archivos

### Capa de Dominio (Domain Layer)

#### `lib/features/requests/domain/entities/request_entity.dart`

**Propósito**: Representa una solicitud en el dominio de la aplicación.

```dart
class RequestEntity {
  String? id;                    // ID de Firestore (null al crear)
  final String idClient;         // ID del usuario que crea la solicitud
  final String title;            // Título de la solicitud
  final String idTypeService;    // Tipo de servicio (Plomería, etc.)
  final String details;          // Descripción detallada
  final String addres;           // Dirección donde se necesita el servicio
  String status;                 // Estado: pending, in_progress, completed, cancelled
  DateTime dateCreated;          // Fecha de creación
  DateTime? dateFinish;          // Fecha de finalización (null si no ha terminado)
}
```

**Estados posibles**:
- `pending`: Solicitud creada, esperando trabajadores
- `in_progress`: Un trabajador está trabajando en ella
- `completed`: Trabajo terminado
- `cancelled`: Solicitud cancelada por el cliente

---

#### `lib/features/requests/domain/repository/request_repository.dart`

**Propósito**: Define el contrato (interfaz) que debe cumplir cualquier implementación del repositorio.

```dart
abstract class RequestRepository {
  // Crear una nueva solicitud
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request);
  
  // Obtener todas las solicitudes
  Future<Either<Failure, List<RequestEntity>>> allRequest();
  
  // Eliminar una solicitud
  Future<Either<Failure, Unit>> deleteRequest(String id);
}
```

**¿Qué es `Either`?**
`Either<Failure, Success>` es un tipo que puede contener:
- `Left(Failure)`: Un error
- `Right(Success)`: Un resultado exitoso

**¿Qué es `Unit`?**
`Unit` es como `void`, pero para programación funcional. Representa "operación exitosa sin valor de retorno".

---

#### `lib/features/requests/domain/useCase/register_use_case.dart`

**Propósito**: Encapsula la lógica de negocio para crear una solicitud.

```dart
class RegisterUseCase {
  final RequestRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, Unit>> call(RequestEntity request) async {
    // Validaciones de negocio
    if (request.title.trim().isEmpty) {
      return left(ValidationFailure(message: 'El título es requerido'));
    }

    if (request.details.trim().isEmpty) {
      return left(ValidationFailure(message: 'La descripción es requerida'));
    }

    if (request.idTypeService.trim().isEmpty) {
      return left(ValidationFailure(
        message: 'Debes seleccionar un tipo de servicio',
      ));
    }

    // Si pasa las validaciones, llamar al repositorio
    return await _repository.registerRequest(request);
  }
}
```

**¿Por qué validar aquí?**
- Las validaciones de negocio van en los casos de uso
- El repositorio solo se encarga de guardar/leer datos
- Esto hace el código más testeable y mantenible

---

#### `lib/features/requests/domain/useCase/get_all_requests_use_case.dart`

**Propósito**: Obtener todas las solicitudes, con opción de filtrar por usuario.

```dart
class GetAllRequestsUseCase {
  final RequestRepository repository;

  GetAllRequestsUseCase(this.repository);

  // Obtener todas las solicitudes
  Future<Either<Failure, List<RequestEntity>>> call() async {
    return await repository.allRequest();
  }

  // Filtrar por usuario específico
  Future<Either<Failure, List<RequestEntity>>> getByUserId(
    String userId,
  ) async {
    final result = await repository.allRequest();

    return result.map((requests) {
      return requests.where((r) => r.idClient == userId).toList();
    });
  }
}
```

**¿Qué hace `.map()`?**
Transforma el contenido de `Right` sin afectar `Left`. Si hay error, lo propaga automáticamente.

---

#### `lib/features/requests/domain/useCase/deleted_request_use_case.dart`

**Propósito**: Eliminar una solicitud con validación del ID.

```dart
class DeletedRequestUseCase {
  final RequestRepository repository;

  DeletedRequestUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(String requestId) async {
    // Validar que el ID no esté vacío
    if (requestId.trim().isEmpty) {
      return left(ValidationFailure(message: 'ID de solicitud inválido'));
    }

    return await repository.deleteRequest(requestId);
  }
}
```

---

### Capa de Datos (Data Layer)

#### `lib/features/requests/data/models/request_model.dart`

**Propósito**: Modelo de datos que extiende `RequestEntity` y agrega métodos para serialización (convertir a/desde Firestore).

```dart
class RequestModel extends RequestEntity {
  RequestModel({
    super.id,
    required super.idClient,
    required super.idTypeService,
    required super.details,
    required super.addres,
    required super.title,
    super.status,
    super.dateCreated,
    super.dateFinish,
  });

  // Crear desde Map (datos de Firestore)
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'],
      idClient: map['idClient'],
      title: map['title'],
      idTypeService: map['idTypeService'],
      details: map['details'],
      addres: map['addres'],
      status: map['status'],
      dateCreated: map['dateCreated'] != null
          ? DateTime.parse(map['dateCreated'])
          : DateTime.now(),
      dateFinish: map['dateFinish'] != null
          ? DateTime.parse(map['dateFinish'])
          : null,
    );
  }

  // Convertir a Map (para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'idClient': idClient,
      'title': title,
      'idTypeService': idTypeService,
      'details': details,
      'addres': addres,
      'status': status,
      'dateCreated': dateCreated.toIso8601String(),
      'dateFinish': dateFinish?.toIso8601String(),
    };
  }

  // Crear copia con cambios
  RequestModel copyWith({
    String? id,
    String? idClient,
    String? title,
    String? idTypeService,
    String? details,
    String? addres,
    String? status,
    DateTime? dateCreated,
    DateTime? dateFinish,
  }) {
    return RequestModel(
      id: id ?? this.id,
      idClient: idClient ?? this.idClient,
      title: title ?? this.title,
      idTypeService: idTypeService ?? this.idTypeService,
      details: details ?? this.details,
      addres: addres ?? this.addres,
      status: status ?? this.status,
      dateCreated: dateCreated ?? this.dateCreated,
      dateFinish: dateFinish ?? this.dateFinish,
    );
  }
}
```

**¿Por qué separar Entity y Model?**
- `Entity`: Lógica de negocio pura, sin dependencias
- `Model`: Detalles de implementación (Firestore, JSON, etc.)
- Esto permite cambiar la base de datos sin afectar la lógica de negocio

---

Continúa en la siguiente parte...
