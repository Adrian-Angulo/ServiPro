# PARTE 5: ARQUITECTURA Y MEJORES PRÁCTICAS 🏗️

[← Parte 4: Fase 3](./ANALISIS_PARTE_4_FASE3.md) | [Índice](./ANALISIS_INDICE.md)

---

## 🎯 OBJETIVO

Documentar la arquitectura actual de ServiPro y establecer mejores prácticas para mantener la calidad del código a medida que la aplicación crece.

---

## 🏗️ CLEAN ARCHITECTURE EN SERVIPRO

### **Estructura Actual**

```
lib/
├── core/                    # Código compartido
│   ├── domain/
│   │   └── enums/          # Enums compartidos
│   ├── errors/             # Manejo de errores
│   ├── routes/             # Navegación
│   ├── theme/              # Tema y estilos
│   ├── utils/              # Utilidades
│   └── widgets/            # Widgets reutilizables
│
└── features/               # Features por módulo
    ├── auth/              # Autenticación y usuarios
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   ├── data/
    │   │   ├── models/
    │   │   ├── datasources/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── providers/
    │       ├── screens/
    │       └── widgets/
    │
    ├── requests/          # Solicitudes de servicio
    ├── application/       # Postulaciones
    ├── reviews/           # Calificaciones
    └── notifications/     # Notificaciones (a crear)
```

### **Capas de Clean Architecture**

#### **1. Domain Layer (Capa de Dominio)**
**Responsabilidad:** Lógica de negocio pura, independiente de frameworks

```dart
// Entities: Objetos de negocio puros
class RequestEntity {
  final String id;
  final String idClient;
  final String title;
  final ServiceStatus status;
  // Sin dependencias externas
}

// Repositories: Contratos (interfaces)
abstract class RequestRepository {
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request);
  Future<Either<Failure, List<RequestEntity>>> allRequest();
}

// UseCases: Casos de uso específicos
class GetAllRequestsUsecase {
  final RequestRepository repository;
  
  GetAllRequestsUsecase({required this.repository});
  
  Future<Either<Failure, List<RequestEntity>>> call() {
    return repository.allRequest();
  }
}
```

**Reglas:**
- ✅ Sin dependencias de Flutter
- ✅ Sin dependencias de Firebase
- ✅ Solo lógica de negocio
- ✅ Testeable al 100%

#### **2. Data Layer (Capa de Datos)**
**Responsabilidad:** Implementación de repositorios y acceso a datos

```dart
// Models: Extensión de entities con serialización
class RequestModel extends RequestEntity {
  RequestModel({...}) : super(...);
  
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'],
      idClient: map['idClient'],
      // ...
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idClient': idClient,
      // ...
    };
  }
}

// Repository Implementation
class RequestRepositoryImpl implements RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  Future<Either<Failure, List<RequestEntity>>> allRequest() async {
    try {
      final snapshot = await _firestore.collection('requests').get();
      final requests = snapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data()))
          .toList();
      return right(requests);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
```

**Reglas:**
- ✅ Implementa contratos del domain
- ✅ Maneja serialización/deserialización
- ✅ Maneja errores de red/base de datos
- ✅ Puede usar Firebase, HTTP, etc.

#### **3. Presentation Layer (Capa de Presentación)**
**Responsabilidad:** UI y state management

```dart
// Providers (Riverpod)
final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepositoryImpl();
});

final getAllRequestsUsecaseProvider = Provider<GetAllRequestsUsecase>((ref) {
  return GetAllRequestsUsecase(
    repository: ref.read(requestRepositoryProvider),
  );
});

final allRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final usecase = ref.read(getAllRequestsUsecaseProvider);
  final result = await usecase();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (requests) => requests,
  );
});

// Screens
class MisSolicitudesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(allRequestsProvider);
    
    return requestsAsync.when(
      data: (requests) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorView(message: error.toString()),
    );
  }
}
```

**Reglas:**
- ✅ Solo UI y state management
- ✅ Usa providers para acceder a UseCases
- ✅ No contiene lógica de negocio
- ✅ Widgets reutilizables

---

## 🎯 PRINCIPIOS SOLID APLICADOS

### **S - Single Responsibility Principle**
**"Una clase debe tener una sola razón para cambiar"**

✅ **Bien aplicado:**
```dart
// Cada widget tiene una responsabilidad única
class WorkerCard extends StatelessWidget {
  // Solo muestra información del trabajador
}

class WorkerStatsWidget extends StatelessWidget {
  // Solo muestra estadísticas
}

class WorkerContactBottomSheet extends StatelessWidget {
  // Solo maneja opciones de contacto
}
```

❌ **Mal aplicado:**
```dart
class WorkerProfileView extends StatelessWidget {
  // 700 líneas con todo mezclado
  // Avatar + Stats + Reviews + Contact + Edit
}
```

### **O - Open/Closed Principle**
**"Abierto para extensión, cerrado para modificación"**

✅ **Bien aplicado:**
```dart
// Widget base reutilizable
class ClientInfoField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEditPressed;
  
  // Puede extenderse sin modificar
}

// Uso en diferentes contextos
ClientInfoField(icon: Icons.person, label: 'Nombre', ...);
ClientInfoField(icon: Icons.email, label: 'Email', ...);
```

### **L - Liskov Substitution Principle**
**"Los subtipos deben ser sustituibles por sus tipos base"**

✅ **Bien aplicado:**
```dart
abstract class Usuario {
  final String id;
  final String email;
  final Rol rol;
}

class Cliente extends Usuario {
  // Puede usarse donde se espera Usuario
}

class Trabajador extends Usuario {
  // Puede usarse donde se espera Usuario
}
```

### **I - Interface Segregation Principle**
**"Los clientes no deben depender de interfaces que no usan"**

✅ **Bien aplicado:**
```dart
// Repositorios específicos por feature
abstract class RequestRepository {
  Future<Either<Failure, Unit>> registerRequest(...);
  Future<Either<Failure, List<RequestEntity>>> allRequest();
}

abstract class ReviewRepository {
  Future<Either<Failure, Unit>> addReview(...);
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByWorker(...);
}

// No un mega-repositorio con todo
```

### **D - Dependency Inversion Principle**
**"Depender de abstracciones, no de concreciones"**

✅ **Bien aplicado:**
```dart
// UseCase depende de abstracción
class GetAllWorkersUsecase {
  final AuthRepository repository; // ← Abstracción
  
  GetAllWorkersUsecase({required this.repository});
}

// Provider inyecta implementación concreta
final getAllWorkersUsecaseProvider = Provider((ref) {
  return GetAllWorkersUsecase(
    repository: ref.read(authRepositoryProvider), // ← Implementación
  );
});
```

---

## 📋 MEJORES PRÁCTICAS

### **1. Naming Conventions**

```dart
// Clases: PascalCase
class WorkerCard extends StatelessWidget {}

// Variables y funciones: camelCase
final allWorkersProvider = FutureProvider(...);
void _handleLogout() {}

// Constantes: camelCase con const
const double kDefaultPadding = 16.0;

// Archivos: snake_case
worker_card.dart
auth_repository.dart
get_all_workers_usecase.dart

// Providers: descriptivos con sufijo
final authNotifierProvider = AsyncNotifierProvider(...);
final allWorkersProvider = FutureProvider(...);
final workerByIdProvider = FutureProvider.family(...);
```

### **2. Organización de Imports**

```dart
// 1. Dart core
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages externos
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// 4. Imports del proyecto (core)
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';

// 5. Imports del proyecto (features)
import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
```

### **3. Manejo de Estados con Riverpod**

```dart
// ✅ Usar .when() para AsyncValue
requestsAsync.when(
  data: (requests) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorView(...),
);

// ✅ Usar .family para providers parametrizados
final workerByIdProvider = FutureProvider.family<Trabajador?, String>((ref, workerId) async {
  // ...
});

// ✅ Usar .autoDispose para providers temporales
final tempDataProvider = FutureProvider.autoDispose<Data>((ref) async {
  // Se limpia automáticamente cuando no se usa
});

// ✅ Usar ref.refresh() para recargar datos
ref.refresh(allWorkersProvider);
```

### **4. Widgets Reutilizables**

```dart
// ✅ Crear widgets pequeños y reutilizables
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.titleLarge);
  }
}

// ✅ Usar const constructors cuando sea posible
const SectionTitle(title: 'Información Personal');

// ✅ Extraer widgets privados para organización
class _StatItem extends StatelessWidget {
  // Widget interno usado solo en este archivo
}
```

### **5. Manejo de Errores**

```dart
// ✅ Usar Either de fpdart para errores
Future<Either<Failure, Unit>> registerRequest(RequestEntity request) async {
  try {
    await _firestore.collection('requests').add(request.toMap());
    return right(unit);
  } catch (e) {
    return left(Failure(message: e.toString()));
  }
}

// ✅ Mensajes de error amigables
String getErrorMessage(String error) {
  if (error.contains('network')) {
    return 'Sin conexión a internet';
  }
  return 'Ocurrió un error inesperado';
}

// ✅ Widget de error reutilizable
ErrorView(
  message: ErrorMessages.getFirebaseErrorMessage(error.toString()),
  onRetry: () => ref.refresh(someProvider),
);
```

### **6. Performance**

```dart
// ✅ Usar const constructors
const SizedBox(height: 16);
const Icon(Icons.star);

// ✅ Evitar rebuilds innecesarios
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Solo escucha lo necesario
    final user = ref.watch(authNotifierProvider).value;
    // No: final state = ref.watch(entireAppStateProvider);
  }
}

// ✅ Usar ListView.builder para listas largas
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
);

// ✅ Implementar paginación
// Ver PARTE 4, TAREA 3.3
```

---

## 🎨 GUÍA DE ESTILO UI/UX

### **Espaciado Consistente**

```dart
// Usar constantes de AppSpacing
const SizedBox(height: AppSpacing.sm);   // 8
const SizedBox(height: AppSpacing.md);   // 16
const SizedBox(height: AppSpacing.lg);   // 24
const SizedBox(height: AppSpacing.xl);   // 32

// Padding de pantallas
padding: const EdgeInsets.all(AppSpacing.screenHorizontal);
```

### **Colores Consistentes**

```dart
// Usar constantes de AppColors
backgroundColor: AppColors.background;
color: AppColors.primary;
color: AppColors.accent;
```

### **Tipografía Consistente**

```dart
// Usar AppTypography
Text('Título', style: AppTypography.headlineLarge);
Text('Subtítulo', style: AppTypography.titleMedium);
Text('Cuerpo', style: AppTypography.bodyLarge);

// O Google Fonts con configuración consistente
Text(
  'Texto',
  style: GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  ),
);
```

### **Feedback Visual**

```dart
// ✅ Mostrar loading states
if (isLoading) CircularProgressIndicator();

// ✅ Mostrar estados vacíos
if (items.isEmpty) EmptyStateWidget();

// ✅ Mostrar confirmaciones
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Operación exitosa')),
);

// ✅ Pedir confirmación para acciones destructivas
showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('¿Estás seguro?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
      ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Confirmar')),
    ],
  ),
);
```

---

## 📚 RECURSOS RECOMENDADOS

### **Documentación**
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [SOLID Principles](https://www.digitalocean.com/community/conceptual_articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)

### **Packages Recomendados**
```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.0
  
  # Functional Programming
  fpdart: ^1.1.0
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  
  # UI
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.0
  
  # Navigation
  go_router: ^13.0.0
  
  # Utils
  intl: ^0.18.0
  
dev_dependencies:
  # Testing
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  
  # Linting
  flutter_lints: ^3.0.0
```

---

## ✅ CHECKLIST FINAL

### Arquitectura
- [ ] Clean Architecture implementada
- [ ] Separación clara de capas
- [ ] Principios SOLID aplicados
- [ ] Código testeable

### Código
- [ ] Naming conventions consistentes
- [ ] Imports organizados
- [ ] Widgets reutilizables
- [ ] Manejo de errores robusto

### UI/UX
- [ ] Espaciado consistente
- [ ] Colores del tema
- [ ] Tipografía uniforme
- [ ] Feedback visual

### Performance
- [ ] Const constructors
- [ ] ListView.builder
- [ ] Caché de imágenes
- [ ] Paginación implementada

### Testing
- [ ] Tests unitarios
- [ ] Tests de widgets
- [ ] Tests de integración
- [ ] Cobertura >60%

---

## 🎓 CONCLUSIÓN

ServiPro tiene una base sólida con Clean Architecture y buenas prácticas. Las mejoras propuestas en este análisis completarán las funcionalidades críticas y elevarán la calidad de la aplicación a nivel profesional.

**Próximos pasos:**
1. Implementar Fase 1 (Funcionalidades Críticas)
2. Implementar Fase 2 (Mejoras de UX)
3. Implementar Fase 3 (Optimizaciones)
4. Mantener las mejores prácticas documentadas aquí

---

[← Parte 4: Fase 3](./ANALISIS_PARTE_4_FASE3.md) | [Volver al Índice](./ANALISIS_INDICE.md)
