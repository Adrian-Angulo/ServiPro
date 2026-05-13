# PARTE 3: FASE 2 - MEJORAS DE UX ✨

[← Parte 2: Fase 1](./ANALISIS_PARTE_2_FASE1.md) | [Índice](./ANALISIS_INDICE.md) | [Siguiente: Fase 3 →](./ANALISIS_PARTE_4_FASE3.md)

---

## 🎯 OBJETIVO DE LA FASE 2

Implementar mejoras de experiencia de usuario que aumenten el engagement y faciliten la navegación en la aplicación.

**Tiempo Estimado:** 1-2 semanas  
**Impacto UX:** ⭐⭐⭐⭐

---

## 📋 TAREAS DE LA FASE 2

### ✅ TAREA 2.1: Sistema de Notificaciones In-App
**Prioridad:** 🔥 ALTO  
**Tiempo:** 5-7 días

### ✅ TAREA 2.2: Búsqueda y Filtros
**Prioridad:** 🔥 ALTO  
**Tiempo:** 3-4 días

### ✅ TAREA 2.3: Pantalla de Alertas Funcional
**Prioridad:** 📊 MEDIO  
**Tiempo:** 2-3 días

---

## 🔔 TAREA 2.1: SISTEMA DE NOTIFICACIONES IN-APP

### **Objetivo**
Implementar notificaciones in-app básicas sin Firebase Cloud Messaging (FCM) como primera fase.

### **Estructura de Archivos**

```
lib/features/notifications/
├── domain/
│   ├── entities/
│   │   └── notification_entity.dart
│   └── repositories/
│       └── notification_repository.dart
├── data/
│   ├── models/
│   │   └── notification_model.dart
│   └── repositories/
│       └── notification_repository_impl.dart
└── presentation/
    ├── providers/
    │   └── notification_providers.dart
    ├── screens/
    │   └── notifications_screen.dart
    └── widgets/
        └── notification_card.dart
```

### **Paso 1: Crear Entidad de Notificación**

**Archivo:** `lib/features/notifications/domain/entities/notification_entity.dart`

```dart
enum NotificationType {
  newRequest,        // Nueva solicitud disponible (Trabajador)
  newApplication,    // Nueva postulación (Cliente)
  applicationAccepted, // Postulación aceptada (Trabajador)
  serviceCompleted,  // Servicio completado (Cliente)
  newReview,         // Nueva review recibida
  serviceConfirmed,  // Servicio confirmado (Trabajador)
}

class NotificationEntity {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final String? relatedId; // ID de solicitud, postulación, etc.
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.relatedId,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
```

### **Paso 2: Crear Provider de Notificaciones**

**Archivo:** `lib/features/notifications/presentation/providers/notification_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/notifications/domain/entities/notification_entity.dart';
import 'package:servi_pro/features/notifications/data/repositories/notification_repository_impl.dart';

final notificationRepositoryProvider = Provider((ref) {
  return NotificationRepositoryImpl();
});

final userNotificationsProvider = StreamProvider.family<List<NotificationEntity>, String>((ref, userId) {
  final repository = ref.read(notificationRepositoryProvider);
  return repository.getUserNotificationsStream(userId);
});

final unreadCountProvider = Provider.family<int, String>((ref, userId) {
  final notifications = ref.watch(userNotificationsProvider(userId)).valueOrNull ?? [];
  return notifications.where((n) => !n.isRead).length;
});
```

### **Paso 3: Badge de Contador en BottomNavigationBar**

**Archivo:** `lib/features/auth/presentation/screens/worker/worker_shell.dart`

```dart
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
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
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
```

### **Paso 4: Crear Notificaciones Automáticamente**

Agregar en los lugares clave:

```dart
// Cuando un trabajador se postula
await notificationRepository.create(
  NotificationEntity(
    id: '',
    userId: request.idClient,
    type: NotificationType.newApplication,
    title: 'Nueva postulación',
    message: '$workerName se postuló a tu solicitud',
    relatedId: request.id,
  ),
);

// Cuando un cliente acepta postulación
await notificationRepository.create(
  NotificationEntity(
    id: '',
    userId: application.idworker,
    type: NotificationType.applicationAccepted,
    title: '¡Postulación aceptada!',
    message: 'Tu postulación fue aceptada',
    relatedId: application.idrequest,
  ),
);
```

### **Checklist**
- [ ] Entidad de notificación creada
- [ ] Repository implementado
- [ ] Provider configurado
- [ ] Badge de contador en tabs
- [ ] Notificaciones automáticas en eventos clave
- [ ] Pantalla de notificaciones funcional
- [ ] Marcar como leído
- [ ] Navegación desde notificación

---

## 🔍 TAREA 2.2: BÚSQUEDA Y FILTROS

### **Objetivo**
Agregar búsqueda y filtros en las pantallas principales para mejorar la navegabilidad.

### **Paso 1: Búsqueda en TrabajadoresScreen**

**Archivo:** `lib/features/auth/presentation/screens/client/trabajadores_screen.dart`

```dart
class TrabajadoresScreen extends ConsumerStatefulWidget {
  const TrabajadoresScreen({super.key});

  @override
  ConsumerState<TrabajadoresScreen> createState() => _TrabajadoresScreenState();
}

class _TrabajadoresScreenState extends ConsumerState<TrabajadoresScreen> {
  String _searchQuery = '';
  String _selectedCity = 'Todas';

  @override
  Widget build(BuildContext context) {
    final workersAsync = ref.watch(allWorkersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajadores'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              
              // Filtro por ciudad
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Todas',
                      isSelected: _selectedCity == 'Todas',
                      onTap: () => setState(() => _selectedCity = 'Todas'),
                    ),
                    _FilterChip(
                      label: 'Pasto',
                      isSelected: _selectedCity == 'Pasto',
                      onTap: () => setState(() => _selectedCity = 'Pasto'),
                    ),
                    _FilterChip(
                      label: 'Cali',
                      isSelected: _selectedCity == 'Cali',
                      onTap: () => setState(() => _selectedCity = 'Cali'),
                    ),
                    // Agregar más ciudades...
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
      body: workersAsync.when(
        data: (workers) {
          // Filtrar trabajadores
          var filteredWorkers = workers.where((w) {
            final matchesSearch = w.nombreCompleto
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
            final matchesCity = _selectedCity == 'Todas' || 
                w.ciudad == _selectedCity;
            return matchesSearch && matchesCity;
          }).toList();

          if (filteredWorkers.isEmpty) {
            return const Center(
              child: Text('No se encontraron trabajadores'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: filteredWorkers.length,
            itemBuilder: (context, index) {
              return WorkerCard(
                trabajador: filteredWorkers[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkerPerfilSimpleView(
                        workerId: filteredWorkers[index].id,
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => 
                const SizedBox(height: AppSpacing.sm),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected ? AppColors.primary : Colors.grey[200],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
```

### **Paso 2: Filtros en InicioWorker**

Similar implementación pero filtrando por tipo de servicio.

### **Checklist**
- [ ] Barra de búsqueda en TrabajadoresScreen
- [ ] Filtros por ciudad
- [ ] Filtros por tipo de servicio en InicioWorker
- [ ] Ordenamiento (rating, fecha, etc.)
- [ ] Búsqueda en tiempo real
- [ ] UI responsive

---

## 📱 TAREA 2.3: PANTALLA DE ALERTAS FUNCIONAL

### **Objetivo**
Reemplazar el placeholder con una pantalla funcional de notificaciones.

**Archivo:** `lib/features/notifications/presentation/screens/notifications_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/notifications/presentation/providers/notification_providers.dart';
import 'package:servi_pro/features/notifications/presentation/widgets/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    final notificationsAsync = ref.watch(userNotificationsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          TextButton(
            onPressed: () {
              // Marcar todas como leídas
            },
            child: const Text('Marcar todas como leídas'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No tienes notificaciones',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationCard(
                notification: notifications[index],
              );
            },
            separatorBuilder: (context, index) => 
                const SizedBox(height: AppSpacing.sm),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

### **Actualizar WorkerShell**

```dart
final pages = [
  InicioWorker(),
  PostulacionesScreen(),
  const NotificationsScreen(), // ← REEMPLAZAR
  const ProfileWorker(),
];
```

### **Checklist**
- [ ] Pantalla de notificaciones creada
- [ ] Lista de notificaciones funcional
- [ ] Marcar como leído
- [ ] Marcar todas como leídas
- [ ] Navegación desde notificación
- [ ] Estado vacío
- [ ] Integrado en WorkerShell

---

## 📊 RESUMEN DE LA FASE 2

### Impacto
- ✅ Notificaciones in-app funcionales
- ✅ Búsqueda y filtros implementados
- ✅ Pantalla de alertas completa
- ✅ Mejor engagement de usuarios
- ✅ Navegación más intuitiva

### Tiempo Total
**10-14 días** de desarrollo

---

[← Parte 2: Fase 1](./ANALISIS_PARTE_2_FASE1.md) | [Índice](./ANALISIS_INDICE.md) | [Siguiente: Fase 3 - Optimizaciones →](./ANALISIS_PARTE_4_FASE3.md)
