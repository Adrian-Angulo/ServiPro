# PARTE 2: FASE 1 - FUNCIONALIDADES CRÍTICAS 🎯

[← Parte 1: Problemas](./ANALISIS_PARTE_1_PROBLEMAS.md) | [Índice](./ANALISIS_INDICE.md) | [Siguiente: Fase 2 →](./ANALISIS_PARTE_3_FASE2.md)

---

## 🎯 OBJETIVO DE LA FASE 1

Implementar las **3 funcionalidades críticas** que completan el flujo de trabajo básico de la aplicación y mejoran significativamente la experiencia de usuario.

**Tiempo Estimado:** 2-3 semanas  
**Impacto UX:** ⭐⭐⭐⭐⭐

---

## 📋 TAREAS DE LA FASE 1

### ✅ TAREA 1.1: Perfil Completo del Trabajador
**Prioridad:** ⚠️ CRÍTICO  
**Tiempo:** 3-4 días  
**Archivos:** 5 nuevos, 1 modificado

### ✅ TAREA 1.2: Ciclo de Vida Completo de Solicitudes
**Prioridad:** ⚠️ CRÍTICO  
**Tiempo:** 5-7 días  
**Archivos:** 8 nuevos, 4 modificados

### ✅ TAREA 1.3: Sistema de Calificaciones Vinculado
**Prioridad:** ⚠️ CRÍTICO  
**Tiempo:** 2-3 días  
**Archivos:** 3 modificados

---

## 🔧 TAREA 1.1: PERFIL COMPLETO DEL TRABAJADOR

### **Objetivo**
Crear una pantalla de perfil funcional para trabajadores, similar a la del cliente, que muestre información personal, estadísticas y permita edición.

### **Estructura de Archivos a Crear**

```
lib/features/auth/presentation/
├── widgets/
│   └── worker_profile_own/
│       ├── worker_own_avatar_widget.dart
│       ├── worker_stats_summary_widget.dart
│       ├── worker_info_edit_section.dart
│       └── worker_logout_button.dart
└── screens/
    └── worker/
        └── profile_worker.dart (REFACTORIZAR)
```

### **Paso 1: Crear Widget de Estadísticas**

**Archivo:** `lib/features/auth/presentation/widgets/worker_profile_own/worker_stats_summary_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';

/// Widget que muestra un resumen de estadísticas del trabajador
class WorkerStatsSummaryWidget extends StatelessWidget {
  final int completedJobs;
  final double rating;
  final int totalReviews;

  const WorkerStatsSummaryWidget({
    super.key,
    required this.completedJobs,
    required this.rating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.check_circle_outline,
            value: completedJobs.toString(),
            label: 'Trabajos\nCompletados',
          ),
          _StatItem(
            icon: Icons.star_rate_rounded,
            value: rating.toStringAsFixed(1),
            label: 'Calificación\nPromedio',
          ),
          _StatItem(
            icon: Icons.rate_review_outlined,
            value: totalReviews.toString(),
            label: 'Reseñas\nRecibidas',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 32),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
```

### **Paso 2: Refactorizar ProfileWorker**

**Archivo:** `lib/features/auth/presentation/screens/worker/profile_worker.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_avatar_widget.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_info_field.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_logout_button.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_section_title.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile_own/worker_stats_summary_widget.dart';
import 'package:servi_pro/features/reviews/presentation/providers/review_providers.dart';

class ProfileWorker extends ConsumerStatefulWidget {
  const ProfileWorker({super.key});

  @override
  ConsumerState<ProfileWorker> createState() => _ProfileWorkerState();
}

class _ProfileWorkerState extends ConsumerState<ProfileWorker> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      await ref.read(authNotifierProvider.notifier).logout();
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  void _showEditDialog(String field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar $field - Funcionalidad próximamente'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user == null || user is! Trabajador) {
          return const Center(
            child: Text('No se pudo cargar la información del perfil'),
          );
        }

        final trabajador = user;
        final reviewsAsync = ref.watch(workerReviewsProvider(trabajador.id));

        return Scaffold(
          backgroundColor: AppColors.backgroundSoft,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundSoft,
            elevation: 0,
            title: const Text('Mi Perfil'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  ClientAvatarWidget(
                    nombre: trabajador.nombreCompleto,
                    onCameraPressed: () => _showEditDialog('foto'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Nombre
                  Text(
                    trabajador.nombreCompleto,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Email
                  Text(
                    trabajador.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Estadísticas
                  reviewsAsync.when(
                    data: (reviews) {
                      final avgRating = reviews.isEmpty
                          ? 0.0
                          : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                              reviews.length;
                      
                      return WorkerStatsSummaryWidget(
                        completedJobs: 0, // TODO: Implementar contador real
                        rating: avgRating,
                        totalReviews: reviews.length,
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => WorkerStatsSummaryWidget(
                      completedJobs: 0,
                      rating: 0.0,
                      totalReviews: 0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Información Personal
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WorkerSectionTitle(title: 'Información Personal'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  ClientInfoField(
                    icon: Icons.person_outline,
                    label: 'Nombre completo',
                    value: trabajador.nombreCompleto,
                    onEditPressed: () => _showEditDialog('nombre'),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  ClientInfoField(
                    icon: Icons.email_outlined,
                    label: 'Correo electrónico',
                    value: trabajador.email,
                    onEditPressed: () => _showEditDialog('correo'),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  ClientInfoField(
                    icon: Icons.phone_outlined,
                    label: 'Teléfono',
                    value: trabajador.celular,
                    onEditPressed: () => _showEditDialog('teléfono'),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  ClientInfoField(
                    icon: Icons.location_on_outlined,
                    label: 'Ciudad',
                    value: trabajador.ciudad,
                    onEditPressed: () => _showEditDialog('ciudad'),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Sobre mí
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WorkerSectionTitle(title: 'Sobre mí'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Text(
                      trabajador.sobreMi,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Botón de cerrar sesión
                  ClientLogoutButton(
                    onPressed: _handleLogout,
                    isLoading: _isLoggingOut,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

### **Checklist de Verificación**

- [ ] Widget de estadísticas creado
- [ ] ProfileWorker refactorizado
- [ ] Muestra avatar con iniciales
- [ ] Muestra información personal
- [ ] Muestra estadísticas (trabajos, rating, reviews)
- [ ] Muestra "Sobre mí"
- [ ] Botón de logout funcional
- [ ] Maneja estados de carga y error
- [ ] Compilación sin errores

---

## 🔄 TAREA 1.2: CICLO DE VIDA COMPLETO DE SOLICITUDES

### **Objetivo**
Completar el flujo de trabajo de solicitudes desde la creación hasta la finalización con confirmación y calificación.

### **Nuevos Estados Requeridos**

**Archivo:** `lib/core/utils/enums.dart`

```dart
enum ServiceStatus {
  pending,           // Solicitud creada, esperando postulaciones
  inProgress,        // Trabajador asignado, servicio en curso
  awaitingConfirmation, // Trabajador marcó como completado
  completed,         // Cliente confirmó finalización
  cancelled,         // Cancelado por alguna de las partes
  disputed          // En disputa (opcional para futuro)
}
```

### **Paso 1: Agregar Métodos al Repository**

**Archivo:** `lib/features/requests/domain/repository/request_repository.dart`

```dart
abstract class RequestRepository {
  // Métodos existentes...
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request);
  Future<Either<Failure, List<RequestEntity>>> allRequest();
  Future<Either<Failure, Unit>> deleteRequest(String id);
  Future<Either<Failure, RequestEntity>> getRequestById(String id);
  
  // NUEVOS MÉTODOS
  Future<Either<Failure, Unit>> markAsCompleted({
    required String requestId,
    required String workerId,
  });
  
  Future<Either<Failure, Unit>> confirmCompletion({
    required String requestId,
    required String clientId,
  });
  
  Future<Either<Failure, Unit>> cancelRequest({
    required String requestId,
    required String reason,
  });
}
```

### **Paso 2: Implementar en Repository**

**Archivo:** `lib/features/requests/data/repository/request_repository_impl.dart`

```dart
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
  } catch (e) {
    return left(Failure(message: e.toString()));
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
  } catch (e) {
    return left(Failure(message: e.toString()));
  }
}
```

### **Paso 3: Crear UseCases**

**Archivo:** `lib/features/requests/domain/usecases/mark_request_completed_usecase.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class MarkRequestCompletedUsecase {
  final RequestRepository repository;

  MarkRequestCompletedUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required String requestId,
    required String workerId,
  }) {
    return repository.markAsCompleted(
      requestId: requestId,
      workerId: workerId,
    );
  }
}
```

### **Paso 4: Crear Botón de Completar en ApplicationCard**

**Archivo:** `lib/features/application/presentation/widgets/cards/application_card.dart`

Agregar botón cuando el estado es `inProgress`:

```dart
if (application.state == ApplicationStatus.aceptado) {
  ElevatedButton.icon(
    onPressed: () async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Marcar como completado'),
          content: const Text(
            '¿Has finalizado este servicio? El cliente deberá confirmar la finalización.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );

      if (confirmed == true && context.mounted) {
        // Llamar al usecase
        final result = await ref.read(markRequestCompletedProvider).call(
          requestId: application.idrequest,
          workerId: application.idworker,
        );
        
        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${failure.message}')),
            );
          },
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Servicio marcado como completado')),
            );
            ref.refresh(workerApplicationsProvider);
          },
        );
      }
    },
    icon: const Icon(Icons.check_circle),
    label: const Text('Marcar como completado'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
    ),
  ),
}
```

### **Checklist de Verificación**

- [ ] Nuevos estados agregados al enum
- [ ] Métodos agregados al repository
- [ ] UseCases creados
- [ ] Botón "Marcar como completado" en ApplicationCard
- [ ] Botón "Confirmar finalización" en vista del cliente
- [ ] Actualización de estados en Firebase
- [ ] Notificaciones al cambiar estado
- [ ] Pruebas de flujo completo

---

## ⭐ TAREA 1.3: SISTEMA DE CALIFICACIONES VINCULADO

### **Objetivo**
Vincular el sistema de reviews con servicios completados y solicitar calificación automáticamente.

### **Paso 1: Actualizar ReviewEntity**

**Archivo:** `lib/features/reviews/domain/entities/review_entity.dart`

```dart
class ReviewEntity {
  String? id;
  final String workerId;
  final String clientId;
  final String clientName;
  final String requestId;      // ← NUEVO
  final String applicationId;  // ← NUEVO
  final double rating;
  final String comment;
  final bool isVerified;       // ← NUEVO
  final DateTime createdAt;

  ReviewEntity({
    this.id,
    required this.workerId,
    required this.clientId,
    required this.clientName,
    required this.requestId,
    required this.applicationId,
    required this.rating,
    required this.comment,
    this.isVerified = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
```

### **Paso 2: Pantalla de Calificación Post-Servicio**

**Archivo:** `lib/features/reviews/presentation/screens/rate_service_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';
import 'package:servi_pro/features/reviews/presentation/providers/review_providers.dart';

class RateServiceScreen extends ConsumerStatefulWidget {
  final String workerId;
  final String workerName;
  final String requestId;
  final String applicationId;
  final String clientId;
  final String clientName;

  const RateServiceScreen({
    super.key,
    required this.workerId,
    required this.workerName,
    required this.requestId,
    required this.applicationId,
    required this.clientId,
    required this.clientName,
  });

  @override
  ConsumerState<RateServiceScreen> createState() => _RateServiceScreenState();
}

class _RateServiceScreenState extends ConsumerState<RateServiceScreen> {
  double _rating = 5.0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe un comentario')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final review = ReviewEntity(
      workerId: widget.workerId,
      clientId: widget.clientId,
      clientName: widget.clientName,
      requestId: widget.requestId,
      applicationId: widget.applicationId,
      rating: _rating,
      comment: _commentController.text.trim(),
      isVerified: true,
    );

    final result = await ref.read(addReviewProvider).call(review);

    if (mounted) {
      setState(() => _isSubmitting = false);

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${failure.message}')),
          );
        },
        (_) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Gracias por tu calificación!')),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificar Servicio'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Cómo fue tu experiencia con ${widget.workerName}?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Rating Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1.0),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 48,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.sm),

            Text(
              _rating == 5.0
                  ? '¡Excelente!'
                  : _rating >= 4.0
                      ? 'Muy bueno'
                      : _rating >= 3.0
                          ? 'Bueno'
                          : _rating >= 2.0
                              ? 'Regular'
                              : 'Necesita mejorar',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Comment TextField
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Cuéntanos sobre tu experiencia...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Submit Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Enviar Calificación',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
```

### **Checklist de Verificación**

- [ ] ReviewEntity actualizado con requestId y applicationId
- [ ] Pantalla de calificación creada
- [ ] Validación de servicio completado antes de permitir review
- [ ] Navegación automática a pantalla de calificación
- [ ] Reviews marcadas como verificadas
- [ ] Actualización de rating promedio del trabajador
- [ ] Pruebas de flujo completo

---

## 📊 RESUMEN DE LA FASE 1

### Archivos Creados (16 nuevos)
1. `worker_stats_summary_widget.dart`
2. `mark_request_completed_usecase.dart`
3. `confirm_request_completion_usecase.dart`
4. `rate_service_screen.dart`
5. Y más...

### Archivos Modificados (8)
1. `profile_worker.dart`
2. `request_repository.dart`
3. `request_repository_impl.dart`
4. `review_entity.dart`
5. `enums.dart`
6. `application_card.dart`
7. Y más...

### Impacto
- ✅ Perfil del trabajador completo y funcional
- ✅ Ciclo de vida de solicitudes completo
- ✅ Sistema de calificaciones confiable
- ✅ Experiencia de usuario significativamente mejorada

---

[← Parte 1: Problemas](./ANALISIS_PARTE_1_PROBLEMAS.md) | [Índice](./ANALISIS_INDICE.md) | [Siguiente: Fase 2 - Mejoras UX →](./ANALISIS_PARTE_3_FASE2.md)
