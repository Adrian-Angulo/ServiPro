# 💬 PROMPTS LISTOS PARA COPIAR Y PEGAR EN KIRO

> **Copia estos prompts directamente en Kiro para implementar las soluciones**

---

## 🎯 FASE 1: FUNCIONALIDADES CRÍTICAS

### **TAREA 1.1: Perfil Completo del Trabajador**

#### **Prompt 1.1.1: Crear WorkerStatsSummaryWidget**

```
Crea el widget WorkerStatsSummaryWidget en:
lib/features/auth/presentation/widgets/worker_profile_own/worker_stats_summary_widget.dart

Basándote en ClientAvatarWidget (#File: lib/features/auth/presentation/widgets/client_profile/client_avatar_widget.dart)

El widget debe:
1. Recibir parámetros: completedJobs (int), rating (double), totalReviews (int)
2. Mostrar 3 columnas con estadísticas en una Row
3. Cada columna: icono + valor grande + etiqueta pequeña
4. Fondo: Container con AppColors.primary.withOpacity(0.1)
5. BorderRadius: AppSpacing.radiusLg
6. Padding: AppSpacing.lg
7. Usar GoogleFonts.nunito para tipografía
8. Const constructor

Iconos a usar:
- Trabajos completados: Icons.check_circle_outline
- Rating promedio: Icons.star_rate_rounded
- Reseñas recibidas: Icons.rate_review_outlined

Estructura interna:
- Widget privado _StatItem para cada estadística
- _StatItem recibe: icon, value (String), label (String)
- Cada _StatItem muestra: Icon + SizedBox + Text(value) + SizedBox + Text(label)

Sigue exactamente el patrón de ClientAvatarWidget.
```

---

#### **Prompt 1.1.2: Refactorizar ProfileWorker**

```
Refactoriza ProfileWorker en:
lib/features/auth/presentation/screens/worker/profile_worker.dart

Cambios principales:
1. Cambiar de ConsumerWidget a ConsumerStatefulWidget
2. Agregar estado _isLoggingOut (bool) para manejar estado del botón logout
3. Agregar método _handleLogout() que:
   - Establece _isLoggingOut = true
   - Llama ref.read(authNotifierProvider.notifier).logout()
   - Establece _isLoggingOut = false en finally

Estructura de la pantalla (en orden):
1. Scaffold con AppBar (título: "Mi Perfil", centerTitle: true)
2. SafeArea + SingleChildScrollView + Column
3. Avatar: ClientAvatarWidget(nombre: trabajador.nombreCompleto)
4. Nombre: Text grande y centrado
5. Email: Text gris y centrado
6. Estadísticas: WorkerStatsSummaryWidget (completedJobs: 0, rating: avgRating, totalReviews: reviews.length)
7. Sección "Información Personal": WorkerSectionTitle
8. Campos de info:
   - ClientInfoField(icon: Icons.person_outline, label: 'Nombre completo', value: trabajador.nombreCompleto)
   - ClientInfoField(icon: Icons.email_outlined, label: 'Correo electrónico', value: trabajador.email)
   - ClientInfoField(icon: Icons.phone_outlined, label: 'Teléfono', value: trabajador.celular)
   - ClientInfoField(icon: Icons.location_on_outlined, label: 'Ciudad', value: trabajador.ciudad)
9. Sección "Sobre mí": WorkerSectionTitle
10. Container con trabajador.sobreMi (color: Colors.grey[50], borderRadius: AppSpacing.radiusMd)
11. Botón logout: ClientLogoutButton(onPressed: _handleLogout, isLoading: _isLoggingOut)

Manejo de estados:
- authState.when(data: (...), loading: (...), error: (...))
- Verificar que user es Trabajador
- Cargar reviews con ref.watch(workerReviewsProvider(trabajador.id))

Reutiliza estos widgets:
- ClientAvatarWidget (#File: lib/features/auth/presentation/widgets/client_profile/client_avatar_widget.dart)
- ClientInfoField (#File: lib/features/auth/presentation/widgets/client_profile/client_info_field.dart)
- ClientLogoutButton (#File: lib/features/auth/presentation/widgets/client_profile/client_logout_button.dart)
- WorkerSectionTitle (#File: lib/features/auth/presentation/widgets/worker_profile/worker_section_title.dart)
- WorkerStatsSummaryWidget (que acabamos de crear)

Sigue el patrón exacto de PerfilCliente (#File: lib/features/auth/presentation/screens/client/perfil_cliente.dart)

Imports necesarios:
- Trabajador model
- workerReviewsProvider
- AppColors, AppSpacing
```

---

### **TAREA 1.2: Ciclo de Vida de Solicitudes**

#### **Prompt 1.2.1: Actualizar ServiceStatus enum**

```
Actualiza el enum ServiceStatus en:
lib/core/utils/enums.dart

Cambio:
Agrega nuevo estado 'awaitingConfirmation' entre 'inProgress' y 'completed'

Resultado final:
enum ServiceStatus { pending, inProgress, awaitingConfirmation, completed, cancelled }
```

---

#### **Prompt 1.2.2: Agregar métodos a RequestRepository**

```
Agrega 2 métodos al abstract class RequestRepository en:
lib/features/requests/domain/repository/request_repository.dart

Métodos a agregar:

1. markAsCompleted({required String requestId, required String workerId})
   - Retorna: Future<Either<Failure, Unit>>
   - Descripción: Marca una solicitud como completada por el trabajador

2. confirmCompletion({required String requestId, required String clientId})
   - Retorna: Future<Either<Failure, Unit>>
   - Descripción: Cliente confirma que el servicio fue completado

Sigue el patrón de deleteRequest que ya existe en el archivo.
```

---

#### **Prompt 1.2.3: Implementar métodos en RequestRepositoryImpl**

```
Implementa los 2 métodos en RequestRepositoryImpl en:
lib/features/requests/data/repository/request_repository_impl.dart

Implementación de markAsCompleted:
- Usa: await _firestore.collection('requests').doc(requestId).update({...})
- Actualiza estos campos:
  - 'status': ServiceStatus.awaitingConfirmation.name
  - 'completedByWorker': true
  - 'completedAt': DateTime.now().toIso8601String()
- Try-catch: Si error, retorna left(Failure(message: e.toString()))
- Si éxito: retorna right(unit)

Implementación de confirmCompletion:
- Usa: await _firestore.collection('requests').doc(requestId).update({...})
- Actualiza estos campos:
  - 'status': ServiceStatus.completed.name
  - 'confirmedByClient': true
  - 'confirmedAt': DateTime.now().toIso8601String()
- Try-catch: Si error, retorna left(Failure(message: e.toString()))
- Si éxito: retorna right(unit)

Sigue exactamente el patrón de deleteRequest que ya existe.
```

---

#### **Prompt 1.2.4: Crear MarkRequestCompletedUsecase**

```
Crea MarkRequestCompletedUsecase en:
lib/features/requests/domain/usecases/mark_request_completed_usecase.dart

Estructura:
- Clase: MarkRequestCompletedUsecase
- Constructor: final RequestRepository repository
- Método: Future<Either<Failure, Unit>> call({required String requestId, required String workerId})
- Implementación: return repository.markAsCompleted(requestId: requestId, workerId: workerId)

Sigue exactamente el patrón de GetAllRequestsUsecase (#File: lib/features/requests/domain/usecases/get_all_requests_usecase.dart)
```

---

#### **Prompt 1.2.5: Crear ConfirmRequestCompletionUsecase**

```
Crea ConfirmRequestCompletionUsecase en:
lib/features/requests/domain/usecases/confirm_request_completion_usecase.dart

Estructura:
- Clase: ConfirmRequestCompletionUsecase
- Constructor: final RequestRepository repository
- Método: Future<Either<Failure, Unit>> call({required String requestId, required String clientId})
- Implementación: return repository.confirmCompletion(requestId: requestId, clientId: clientId)

Sigue exactamente el patrón de GetAllRequestsUsecase (#File: lib/features/requests/domain/usecases/get_all_requests_usecase.dart)
```

---

#### **Prompt 1.2.6: Agregar providers**

```
Agrega 2 providers en auth_provider.dart (#File: lib/features/auth/presentation/providers/auth_provider.dart):

Provider 1:
final markRequestCompletedProvider = Provider<MarkRequestCompletedUsecase>((ref) {
  return MarkRequestCompletedUsecase(repository: ref.read(requestRepositoryProvider));
});

Provider 2:
final confirmRequestCompletionProvider = Provider<ConfirmRequestCompletionUsecase>((ref) {
  return ConfirmRequestCompletionUsecase(repository: ref.read(requestRepositoryProvider));
});

Imports necesarios:
- import 'package:servi_pro/features/requests/domain/usecases/mark_request_completed_usecase.dart';
- import 'package:servi_pro/features/requests/domain/usecases/confirm_request_completion_usecase.dart';

Sigue el patrón de getAllWorkersUsecaseProvider que ya existe.
```

---

#### **Prompt 1.2.7: Agregar botones a ApplicationCard**

```
En ApplicationCard (#File: lib/features/application/presentation/widgets/cards/application_card.dart):

Agrega 2 botones en la sección de acciones (después del botón existente):

BOTÓN 1: "Marcar como completado" (solo para trabajador, cuando state == aceptado)
- Icono: Icons.check_circle
- Texto: 'Marcar como completado'
- Color: Colors.green
- onPressed:
  1. Muestra AlertDialog:
     - Título: 'Marcar como completado'
     - Contenido: '¿Has finalizado este servicio? El cliente deberá confirmar.'
     - Botones: Cancelar, Confirmar
  2. Si confirma:
     - Llama: ref.read(markRequestCompletedProvider).call(requestId: application.idrequest, workerId: application.idworker)
     - Si éxito: SnackBar 'Servicio marcado como completado' + ref.refresh(workerApplicationsProvider)
     - Si error: SnackBar con error

BOTÓN 2: "Confirmar finalización" (solo para cliente, cuando request.status == awaitingConfirmation)
- Icono: Icons.verified
- Texto: 'Confirmar finalización'
- Color: Colors.blue
- onPressed:
  1. Muestra AlertDialog:
     - Título: 'Confirmar finalización'
     - Contenido: '¿El servicio fue completado satisfactoriamente?'
     - Botones: Cancelar, Confirmar
  2. Si confirma:
     - Llama: ref.read(confirmRequestCompletionProvider).call(requestId: application.idrequest, clientId: clientId)
     - Si éxito: SnackBar 'Servicio confirmado' + Navega a RateServiceScreen
     - Si error: SnackBar con error

Sigue el patrón del botón de eliminar que ya existe en el archivo.
```

---

### **TAREA 1.3: Sistema de Calificaciones**

#### **Prompt 1.3.1: Actualizar ReviewEntity**

```
Actualiza ReviewEntity en:
lib/features/reviews/domain/entities/review_entity.dart

Cambios:
1. Agrega campo: final String requestId (ID de la solicitud calificada)
2. Agrega campo: final String applicationId (ID de la postulación)
3. Agrega campo: final bool isVerified (si es verificada, default true)

Actualiza constructor:
- Agrega parámetros: required this.requestId, required this.applicationId, this.isVerified = true
- Mantén el resto igual

Resultado: ReviewEntity tendrá 8 campos en total
```

---

#### **Prompt 1.3.2: Crear RateServiceScreen**

```
Crea RateServiceScreen en:
lib/features/reviews/presentation/screens/rate_service_screen.dart

Estructura:
- ConsumerStatefulWidget
- Constructor recibe: workerId, workerName, requestId, applicationId, clientId, clientName (todos String)
- Estado: _rating (double, default 5.0), _commentController (TextEditingController), _isSubmitting (bool)

Pantalla:
1. Scaffold con AppBar (título: 'Calificar Servicio', centerTitle: true)
2. SingleChildScrollView + Column
3. Título: '¿Cómo fue tu experiencia con [workerName]?'
4. Rating stars: Row con 5 IconButton (Icons.star / Icons.star_border)
   - Tamaño: 48
   - Color: Colors.amber
   - onPressed: actualiza _rating
5. Texto dinámico según rating:
   - 5.0: '¡Excelente!'
   - 4.0-4.9: 'Muy bueno'
   - 3.0-3.9: 'Bueno'
   - 2.0-2.9: 'Regular'
   - <2.0: 'Necesita mejorar'
6. TextField para comentario:
   - maxLines: 5
   - hintText: 'Cuéntanos sobre tu experiencia...'
   - border: OutlineInputBorder
7. Botón "Enviar Calificación":
   - Ancho completo (SizedBox width: double.infinity)
   - Altura: 56
   - Si _isSubmitting: muestra CircularProgressIndicator
   - onPressed: _submitReview()

Método _submitReview():
1. Valida que comentario no esté vacío
2. Crea ReviewEntity con todos los datos
3. Llama ref.read(addReviewProvider).call(review)
4. Si éxito: Navigator.pop(context, true) + SnackBar '¡Gracias por tu calificación!'
5. Si error: SnackBar con error

Imports necesarios:
- addReviewProvider
- ReviewEntity
- AppColors, AppSpacing
```

---

## 🎯 FASE 2: MEJORAS DE UX

### **TAREA 2.1: Sistema de Notificaciones In-App**

#### **Prompt 2.1.1: Crear NotificationEntity**

```
Crea NotificationEntity en:
lib/features/notifications/domain/entities/notification_entity.dart

Estructura:
- Enum NotificationType con valores: newRequest, newApplication, applicationAccepted, serviceCompleted, newReview, serviceConfirmed
- Clase NotificationEntity con campos:
  - id (String)
  - userId (String)
  - type (NotificationType)
  - title (String)
  - message (String)
  - relatedId (String?, nullable)
  - isRead (bool, default false)
  - createdAt (DateTime, default DateTime.now())

Sigue el patrón de ReviewEntity (#File: lib/features/reviews/domain/entities/review_entity.dart)
```

---

#### **Prompt 2.1.2: Crear NotificationRepository**

```
Crea abstract class NotificationRepository en:
lib/features/notifications/domain/repositories/notification_repository.dart

Métodos:
1. Future<Either<Failure, Unit>> create(NotificationEntity notification)
2. Stream<List<NotificationEntity>> getUserNotificationsStream(String userId)
3. Future<Either<Failure, Unit>> markAsRead(String notificationId)
4. Future<Either<Failure, Unit>> markAllAsRead(String userId)

Sigue el patrón de ReviewRepository (#File: lib/features/reviews/domain/repositories/review_repository.dart)
```

---

#### **Prompt 2.1.3: Crear NotificationRepositoryImpl**

```
Crea NotificationRepositoryImpl en:
lib/features/notifications/data/repositories/notification_repository_impl.dart

Implementa los 4 métodos:

create():
- Usa _firestore.collection('notifications').add(notification.toMap())
- Retorna right(unit) si éxito, left(Failure(...)) si error

getUserNotificationsStream():
- Usa _firestore.collection('notifications').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).snapshots()
- Mapea a List<NotificationEntity>
- Retorna Stream

markAsRead():
- Usa _firestore.collection('notifications').doc(notificationId).update({'isRead': true})
- Retorna right(unit) si éxito, left(Failure(...)) si error

markAllAsRead():
- Usa _firestore.collection('notifications').where('userId', isEqualTo: userId).get()
- Actualiza cada documento con {'isRead': true}
- Retorna right(unit) si éxito, left(Failure(...)) si error

Sigue el patrón de ReviewRepositoryImpl (#File: lib/features/reviews/data/repositories/review_repository_impl.dart)
```

---

#### **Prompt 2.1.4: Crear NotificationProviders**

```
Crea notification_providers.dart en:
lib/features/notifications/presentation/providers/notification_providers.dart

Providers:
1. notificationRepositoryProvider: Provider que retorna NotificationRepositoryImpl()

2. userNotificationsProvider: StreamProvider.family<List<NotificationEntity>, String>
   - Parámetro: userId (String)
   - Retorna: repository.getUserNotificationsStream(userId)

3. unreadCountProvider: Provider.family<int, String>
   - Parámetro: userId (String)
   - Calcula: notifications.where((n) => !n.isRead).length

Sigue el patrón de review_providers.dart (#File: lib/features/reviews/presentation/providers/review_providers.dart)
```

---

#### **Prompt 2.1.5: Agregar badge a WorkerShell**

```
En WorkerShell (#File: lib/features/auth/presentation/screens/worker/worker_shell.dart):

Reemplaza el BottomNavigationBarItem de "Alertas" (índice 2) con:

BottomNavigationBarItem(
  icon: Stack(
    children: [
      const Icon(Icons.notifications_active_outlined),
      Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(authNotifierProvider).value;
          if (user == null) return const SizedBox();
          
          final unreadCount = ref.watch(unreadCountProvider(user.id));
          
          if (unreadCount == 0) return const SizedBox();
          
          return Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    ],
  ),
  activeIcon: const Icon(Icons.notifications_active_sharp),
  label: 'Alertas',
),

Imports necesarios:
- import 'package:flutter_riverpod/flutter_riverpod.dart';
- import 'package:servi_pro/features/notifications/presentation/providers/notification_providers.dart';
```

---

### **TAREA 2.2: Búsqueda y Filtros**

#### **Prompt 2.2.1: Agregar búsqueda a TrabajadoresScreen**

```
Refactoriza TrabajadoresScreen en:
lib/features/auth/presentation/screens/client/trabajadores_screen.dart

Cambios:
1. Cambiar de ConsumerWidget a ConsumerStatefulWidget
2. Agregar estado: _searchQuery (String, default '')
3. Agregar estado: _selectedCity (String, default 'Todas')

Agregar AppBar con bottom:
- PreferredSize con altura 120
- Column con 2 elementos:
  1. TextField para búsqueda:
     - hintText: 'Buscar por nombre...'
     - prefixIcon: Icons.search
     - onChanged: actualiza _searchQuery
     - border: OutlineInputBorder
  2. SingleChildScrollView horizontal con Row de FilterChip:
     - Ciudades: 'Todas', 'Pasto', 'Cali', 'Bogotá', 'Medellín'
     - onTap: actualiza _selectedCity
     - isSelected: _selectedCity == label

Filtrar trabajadores:
- matchesSearch: nombreCompleto.toLowerCase().contains(_searchQuery.toLowerCase())
- matchesCity: _selectedCity == 'Todas' || ciudad == _selectedCity
- Mostrar solo si ambas condiciones son true

Si lista vacía: mostrar Center con texto 'No se encontraron trabajadores'

Sigue el patrón de InicioWorker (#File: lib/features/requests/presentation/screens/worker/inicio_worker.dart)
```

---

## 📋 CÓMO USAR ESTOS PROMPTS

1. **Copia el prompt completo** (desde ``` hasta ```)
2. **Pégalo en Kiro**
3. **Espera a que Kiro termine**
4. **Verifica compilación** (sin errores)
5. **Prueba la funcionalidad**
6. **Marca como completado** en el checklist

---

## ⚡ TIPS PARA AHORRAR CRÉDITOS

- ✅ Usa prompts específicos (no genéricos)
- ✅ Referencia archivos existentes con #File
- ✅ Divide en pasos pequeños
- ✅ Verifica compilación después de cada cambio
- ✅ Reutiliza código existente

---

**Siguiente:** Copia el Prompt 1.1.1 y pégalo en Kiro para empezar

