# PARTE 4: FASE 3 - OPTIMIZACIONES 🚀

[← Parte 3: Fase 2](./ANALISIS_PARTE_3_FASE2.md) | [Índice](./ANALISIS_INDICE.md) | [Siguiente: Arquitectura →](./ANALISIS_PARTE_5_ARQUITECTURA.md)

---

## 🎯 OBJETIVO DE LA FASE 3

Optimizar aspectos técnicos de la aplicación para mejorar mantenibilidad, performance y experiencia de usuario.

**Tiempo Estimado:** 1-2 semanas  
**Impacto:** ⭐⭐⭐

---

## 📋 TAREAS DE LA FASE 3

### ✅ TAREA 3.1: Refactorización de Navegación
**Prioridad:** 📊 MEDIO  
**Tiempo:** 2-3 días

### ✅ TAREA 3.2: Manejo de Errores Mejorado
**Prioridad:** 📊 MEDIO  
**Tiempo:** 2-3 días

### ✅ TAREA 3.3: Optimizaciones de Performance
**Prioridad:** 📊 MEDIO  
**Tiempo:** 2-3 días

### ✅ TAREA 3.4: Testing y Validación
**Prioridad:** 📝 BAJO  
**Tiempo:** 3-5 días

---

## 🧭 TAREA 3.1: REFACTORIZACIÓN DE NAVEGACIÓN

### **Objetivo**
Unificar la navegación usando go_router en toda la aplicación.

### **Problema Actual**
```dart
// Inconsistente: Mezcla de Navigator.push y go_router
Navigator.push(context, MaterialPageRoute(...)); // ❌
context.go('/worker'); // ✅
```

### **Solución: Rutas Nombradas con go_router**

**Archivo:** `lib/core/routes/app_router.dart`

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingNotifier).value;
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (onboardingState == false) return '/onboarding';
      if (auth.isLoading) return '/splash';
      if (auth.value == null) return '/login';
      if (auth.value!.rol == Rol.trabajador) return '/worker';
      if (auth.value!.rol == Rol.cliente) return '/cliente';
      return '/login';
    },
    routes: [
      // Rutas existentes...
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/worker', builder: (context, state) => WorkerShell()),
      GoRoute(path: '/cliente', builder: (context, state) => ClientShell()),
      
      // NUEVAS RUTAS
      GoRoute(
        path: '/worker-profile/:workerId',
        builder: (context, state) {
          final workerId = state.pathParameters['workerId']!;
          return WorkerPerfilSimpleView(workerId: workerId);
        },
      ),
      GoRoute(
        path: '/request-details/:requestId',
        builder: (context, state) {
          final requestId = state.pathParameters['requestId']!;
          return VerDetallesSolicitudScreen(requestId: requestId);
        },
      ),
      GoRoute(
        path: '/rate-service',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RateServiceScreen(
            workerId: extra['workerId'],
            workerName: extra['workerName'],
            requestId: extra['requestId'],
            applicationId: extra['applicationId'],
            clientId: extra['clientId'],
            clientName: extra['clientName'],
          );
        },
      ),
      GoRoute(
        path: '/create-request',
        builder: (context, state) => const CreateRequestScreen(),
      ),
    ],
  );
});
```

### **Uso en la Aplicación**

```dart
// Antes (❌)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WorkerPerfilSimpleView(workerId: worker.id),
  ),
);

// Después (✅)
context.push('/worker-profile/${worker.id}');
```

### **Checklist**
- [ ] Todas las rutas definidas en go_router
- [ ] Reemplazar Navigator.push por context.push
- [ ] Parámetros de ruta configurados
- [ ] Deep linking funcional
- [ ] Navegación consistente en toda la app

---

## ⚠️ TAREA 3.2: MANEJO DE ERRORES MEJORADO

### **Objetivo**
Implementar manejo de errores consistente y user-friendly en toda la aplicación.

### **Paso 1: Crear Widget de Error Reutilizable**

**Archivo:** `lib/core/widgets/error/error_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Algo salió mal',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### **Paso 2: Mensajes de Error Amigables**

**Archivo:** `lib/core/utils/error_messages.dart`

```dart
class ErrorMessages {
  static String getFirebaseErrorMessage(String error) {
    if (error.contains('network')) {
      return 'Sin conexión a internet. Verifica tu conexión y vuelve a intentar.';
    }
    if (error.contains('permission-denied')) {
      return 'No tienes permisos para realizar esta acción.';
    }
    if (error.contains('not-found')) {
      return 'El recurso solicitado no existe.';
    }
    if (error.contains('already-exists')) {
      return 'Este registro ya existe.';
    }
    return 'Ocurrió un error inesperado. Por favor intenta de nuevo.';
  }

  static String getAuthErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No existe una cuenta con ese correo electrónico.';
    }
    if (error.contains('wrong-password')) {
      return 'Contraseña incorrecta.';
    }
    if (error.contains('email-already-in-use')) {
      return 'Este correo ya está registrado.';
    }
    if (error.contains('weak-password')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (error.contains('invalid-email')) {
      return 'Correo electrónico inválido.';
    }
    if (error.contains('too-many-requests')) {
      return 'Demasiados intentos. Espera unos minutos.';
    }
    return 'Error de autenticación. Verifica tus credenciales.';
  }
}
```

### **Uso en la Aplicación**

```dart
// Antes (❌)
error: (error, stack) => Center(child: Text('Error: $error')),

// Después (✅)
error: (error, stack) => ErrorView(
  message: ErrorMessages.getFirebaseErrorMessage(error.toString()),
  onRetry: () => ref.refresh(someProvider),
),
```

### **Checklist**
- [ ] Widget ErrorView creado
- [ ] Mensajes de error amigables
- [ ] Botón de reintentar
- [ ] Logging de errores
- [ ] Reemplazar todos los Text('Error: $error')

---

## ⚡ TAREA 3.3: OPTIMIZACIONES DE PERFORMANCE

### **Objetivo**
Mejorar el rendimiento de la aplicación mediante optimizaciones clave.

### **Optimización 1: Caché de Imágenes**

```dart
// Usar cached_network_image para avatares
dependencies:
  cached_network_image: ^3.3.0

// Implementación
CachedNetworkImage(
  imageUrl: worker.photoUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.person),
)
```

### **Optimización 2: Paginación en Listas**

```dart
// Implementar paginación en listas largas
class PaginatedWorkersList extends ConsumerStatefulWidget {
  @override
  ConsumerState<PaginatedWorkersList> createState() => _PaginatedWorkersListState();
}

class _PaginatedWorkersListState extends ConsumerState<PaginatedWorkersList> {
  final _scrollController = ScrollController();
  int _page = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() => _page++);
    // Cargar más datos
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: workers.length + 1,
      itemBuilder: (context, index) {
        if (index == workers.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return WorkerCard(trabajador: workers[index]);
      },
    );
  }
}
```

### **Optimización 3: Debounce en Búsqueda**

```dart
import 'dart:async';

class _TrabajadoresScreenState extends ConsumerState<TrabajadoresScreen> {
  Timer? _debounce;
  String _searchQuery = '';

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchQuery = query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
```

### **Checklist**
- [ ] Caché de imágenes implementado
- [ ] Paginación en listas largas
- [ ] Debounce en búsqueda
- [ ] Lazy loading de datos
- [ ] Optimización de queries a Firebase

---

## 🧪 TAREA 3.4: TESTING Y VALIDACIÓN

### **Objetivo**
Agregar tests básicos para funcionalidades críticas.

### **Estructura de Tests**

```
test/
├── unit/
│   ├── usecases/
│   │   ├── get_all_workers_usecase_test.dart
│   │   └── mark_request_completed_usecase_test.dart
│   └── providers/
│       └── auth_provider_test.dart
├── widget/
│   ├── worker_card_test.dart
│   └── client_info_field_test.dart
└── integration/
    └── login_flow_test.dart
```

### **Ejemplo de Test Unitario**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:servi_pro/features/auth/domain/usecases/get_all_workers_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetAllWorkersUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetAllWorkersUsecase(repository: mockRepository);
  });

  test('should return list of workers from repository', () async {
    // Arrange
    final workers = [
      Trabajador(id: '1', nombreCompleto: 'Test Worker', ...),
    ];
    when(() => mockRepository.getAllWorkers()).thenAnswer((_) async => workers);

    // Act
    final result = await usecase();

    // Assert
    expect(result, workers);
    verify(() => mockRepository.getAllWorkers()).called(1);
  });
}
```

### **Checklist**
- [ ] Tests unitarios para UseCases
- [ ] Tests de widgets críticos
- [ ] Test de integración para login
- [ ] Cobertura mínima del 60%
- [ ] CI/CD configurado

---

## 📊 RESUMEN DE LA FASE 3

### Mejoras Implementadas
- ✅ Navegación unificada con go_router
- ✅ Manejo de errores consistente
- ✅ Optimizaciones de performance
- ✅ Tests básicos implementados

### Impacto
- 🚀 Mejor mantenibilidad del código
- 🚀 Experiencia de usuario más fluida
- 🚀 Menos bugs en producción
- 🚀 Código más testeable

### Tiempo Total
**9-14 días** de desarrollo

---

[← Parte 3: Fase 2](./ANALISIS_PARTE_3_FASE2.md) | [Índice](./ANALISIS_INDICE.md) | [Siguiente: Arquitectura y Mejores Prácticas →](./ANALISIS_PARTE_5_ARQUITECTURA.md)
