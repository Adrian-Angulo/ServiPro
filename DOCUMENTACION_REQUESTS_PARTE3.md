# Documentación del Sistema de Solicitudes - Parte 3

## Pantallas y Widgets

### Pantallas Principales

#### 1. CreateRequestScreen

**Ubicación**: `lib/features/requests/presentation/screens/create_request_screen.dart`

**Propósito**: Permite al cliente crear una nueva solicitud de servicio.

**Componentes**:

```dart
class CreateRequestScreen extends ConsumerStatefulWidget {
  // Estado del formulario
  String? selectedCategory;              // Categoría seleccionada
  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController addressController;
  bool _isLoading = false;
}
```

**Categorías disponibles**:
```dart
final List<Map<String, dynamic>> categories = [
  {'icon': Icons.plumbing, 'label': 'Plomería'},
  {'icon': Icons.electrical_services, 'label': 'Electricidad'},
  {'icon': Icons.carpenter, 'label': 'Carpintería'},
  {'icon': Icons.cleaning_services, 'label': 'Limpieza'},
  {'icon': Icons.format_paint, 'label': 'Pintura'},
  {'icon': Icons.more_horiz, 'label': 'Otros'},
];
```

**Validación del formulario**:
```dart
bool get _isFormValid {
  return selectedCategory != null &&
      titleController.text.trim().isNotEmpty &&
      descriptionController.text.trim().isNotEmpty &&
      addressController.text.trim().isNotEmpty;
}
```

**Flujo de publicación**:
```dart
Future<void> _handlePublish() async {
  // 1. Validar formulario
  if (!_isFormValid) {
    _showErrorSnackBar('Por favor completa todos los campos');
    return;
  }

  // 2. Obtener usuario autenticado
  final authState = ref.read(authNotifierProvider);
  final userId = authState.when(
    data: (user) => user?.id,
    loading: () => null,
    error: (_, __) => null,
  );

  if (userId == null) {
    _showErrorSnackBar('Debes iniciar sesión para crear una solicitud');
    return;
  }

  setState(() => _isLoading = true);

  // 3. Crear entidad de solicitud
  final request = RequestEntity(
    idClient: userId,
    title: titleController.text.trim(),
    idTypeService: selectedCategory!,
    details: descriptionController.text.trim(),
    addres: addressController.text.trim(),
  );

  // 4. Registrar en Firestore
  final failure = await ref
      .read(requestNotifierProvider.notifier)
      .registerRequest(request: request);

  setState(() => _isLoading = false);

  if (!mounted) return;

  // 5. Mostrar resultado
  if (failure != null) {
    _showErrorSnackBar(failure.message);
  } else {
    _showSuccessSnackBar('Solicitud publicada exitosamente');
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.pop(context);
  }
}
```

**Diálogo de confirmación al cancelar**:
```dart
void _handleCancel() {
  if (selectedCategory != null ||
      titleController.text.isNotEmpty ||
      descriptionController.text.isNotEmpty ||
      addressController.text.isNotEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Descartar solicitud?'),
        content: Text('Se perderán todos los datos ingresados'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continuar editando'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Descartar'),
          ),
        ],
      ),
    );
  } else {
    Navigator.pop(context);
  }
}
```

**Diseño de la pantalla**:
```
┌─────────────────────────────────────────┐
│  ← Solicitar un Oficio                  │ ← AppBar
├─────────────────────────────────────────┤
│                                         │
│  ¿Qué necesitas?                        │
│                                         │
│  ┌─────┐ ┌─────┐ ┌─────┐               │
│  │ 🔧  │ │ ⚡  │ │ 🪚  │               │ ← Grid de categorías
│  │Plom.│ │Elec.│ │Carp.│               │
│  └─────┘ └─────┘ └─────┘               │
│                                         │
│  Detalles del trabajo                   │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ Título de la solicitud            │ │ ← Campo de título
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ Descripción breve                 │ │
│  │                                   │ │ ← Campo de descripción
│  │                                   │ │   (multilínea)
│  └───────────────────────────────────┘ │
│                                         │
│  Ubicación                              │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ 📍 Dirección                      │ │ ← Campo de dirección
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
│  [Cancelar]           [Publicar]       │ ← Botones fijos
└─────────────────────────────────────────┘
```

---

#### 2. MisSolicitudesScreen

**Ubicación**: `lib/features/requests/presentation/screens/mis_solicitudes_screen.dart`

**Propósito**: Muestra todas las solicitudes del usuario con filtros por estado.

**Estructura**:
```dart
class MisSolicitudesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestNotifierProvider);
    final selectedFilter = ref.watch(requestFilterProvider);
    final userId = ref.watch(authNotifierProvider).value?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Solicitudes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.push(...),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros horizontales
          _buildFilters(requestsAsync, userId),
          
          // Lista de solicitudes
          Expanded(
            child: _buildRequestsList(requestsAsync, selectedFilter, userId),
          ),
        ],
      ),
    );
  }
}
```

**Filtros**:
```dart
Widget _buildFilters(AsyncValue<List<RequestEntity>> requestsAsync, String? userId) {
  return requestsAsync.when(
    data: (requests) {
      final counts = _countByStatus(requests, userId);

      return Container(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: RequestFilterType.values.length,
          itemBuilder: (context, index) {
            final filter = RequestFilterType.values[index];
            return RequestFilterChip(
              label: filter.label,
              isSelected: selectedFilter == filter,
              count: counts[filter],
              onTap: () {
                ref.read(requestFilterProvider.notifier).state = filter;
              },
            );
          },
        ),
      );
    },
    loading: () => SizedBox(height: 60),
    error: (_, __) => SizedBox(height: 60),
  );
}
```

**Lista de solicitudes**:
```dart
Widget _buildRequestsList(
  AsyncValue<List<RequestEntity>> requestsAsync,
  RequestFilterType selectedFilter,
  String? userId,
) {
  return requestsAsync.when(
    data: (requests) {
      if (userId == null) {
        return Center(child: Text('Debes iniciar sesión'));
      }

      final filteredRequests = _filterRequests(requests, selectedFilter, userId);

      if (filteredRequests.isEmpty) {
        return EmptyRequestsWidget(
          filterType: selectedFilter.label,
          onCreateRequest: () => Navigator.push(...),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(requestNotifierProvider.notifier).refresh();
        },
        child: ListView.separated(
          itemCount: filteredRequests.length,
          itemBuilder: (context, index) {
            final request = filteredRequests[index];
            final uiStatus = _mapStatusToUI(request.status);

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerDetallesSolicitudScreen(
                    request: request,
                  ),
                ),
              ),
              child: RequestCard(
                status: uiStatus,
                title: request.title,
                description: request.details,
                time: _formatTime(request.dateCreated),
                onPress: uiStatus == 'Pendiente'
                    ? () => _cancelRequest(context, ref, request.id!)
                    : null,
              ),
            );
          },
        ),
      );
    },
    loading: () => Center(child: CircularProgressIndicator()),
    error: (error, stack) => _buildErrorWidget(error),
  );
}
```

**Cancelar solicitud**:
```dart
Future<void> _cancelRequest(
  BuildContext context,
  WidgetRef ref,
  String requestId,
) async {
  // 1. Mostrar diálogo de confirmación
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('¿Cancelar solicitud?'),
      content: Text(
        'Esta acción no se puede deshacer. La solicitud será eliminada permanentemente.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Sí, cancelar'),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  // 2. Eliminar de Firestore
  final failure = await ref
      .read(requestNotifierProvider.notifier)
      .deleteRequest(id: requestId);

  if (!context.mounted) return;

  // 3. Mostrar resultado
  if (failure != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.message),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud cancelada'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
```

**Diseño de la pantalla**:
```
┌─────────────────────────────────────────┐
│  Mis Solicitudes                    [+] │ ← AppBar
├─────────────────────────────────────────┤
│ [Todos 5] [Pendiente 2] [En progreso 1]│ ← Filtros con badges
├─────────────────────────────────────────┤
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ 📅 PENDIENTE      Hace 2 horas    │ │
│  │                                   │ │
│  │ Reparación de grifo               │ │ ← RequestCard
│  │                                   │ │
│  │ Tengo una fuga en el grifo...     │ │
│  │                                   │ │
│  │              [Cancelar Solicitud] │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ 🔧 EN PROGRESO    Hace 1 día      │ │
│  │                                   │ │
│  │ Instalación de lámpara            │ │
│  │                                   │ │
│  │ Instalación de lámpara LED...     │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

---

#### 3. VerDetallesSolicitudScreen

**Ubicación**: `lib/features/requests/presentation/screens/ver_detalles_solicitud_screen.dart`

**Propósito**: Muestra los detalles completos de una solicitud.

**Estructura**:
```dart
class VerDetallesSolicitudScreen extends ConsumerWidget {
  final RequestEntity request;

  const VerDetallesSolicitudScreen({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiStatus = _mapStatusToUI(request.status);
    final isPending = uiStatus == 'Pendiente';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Solicitud'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header con título, estado y tiempo
                  DetailHeaderWidget(
                    title: request.title,
                    status: uiStatus,
                    timeAgo: _formatTimeAgo(request.dateCreated),
                    date: request.dateCreated,
                  ),

                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Ubicación
                        DetailLocationWidget(
                          address: request.addres,
                          distance: '2.5 km',
                        ),

                        SizedBox(height: 24),

                        // Descripción
                        DetailDescriptionWidget(
                          description: request.details,
                        ),

                        SizedBox(height: 24),

                        // Postulaciones (placeholder)
                        Text('Postulaciones'),
                        Text('Aún no hay postulaciones para esta solicitud'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botón fijo inferior (solo para pendientes)
          if (isPending)
            Container(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _cancelRequest(context, ref),
                child: Text('Cancelar Solicitud'),
              ),
            ),
        ],
      ),
    );
  }
}
```

**Diseño de la pantalla**:
```
┌─────────────────────────────────────────┐
│  ← Detalles de Solicitud                │ ← AppBar
├─────────────────────────────────────────┤
│  ┌───────────────────────────────────┐ │
│  │ 📅 PENDIENTE      Hace 2 horas    │ │
│  │                                   │ │
│  │ Reparación de grifo               │ │ ← DetailHeaderWidget
│  │                                   │ │
│  │ Creado: 08/04/2026 10:30 AM      │ │
│  └───────────────────────────────────┘ │
│                                         │
│  📍 Ubicación                           │
│  Calle 24 #17-21, Barrio Chapal        │ ← DetailLocationWidget
│  🚗 2.5 km de distancia                │
│                                         │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│  📝 Descripción                         │
│  Tengo una fuga en el grifo de la      │ ← DetailDescriptionWidget
│  cocina que necesita reparación        │
│  urgente. El agua gotea constantemente.│
│                                         │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                         │
│  👥 Postulaciones                       │
│  Aún no hay postulaciones para esta    │
│  solicitud                              │
│                                         │
└─────────────────────────────────────────┘
│  [Cancelar Solicitud]                  │ ← Botón fijo
└─────────────────────────────────────────┘
```

---

### Widgets Reutilizables

#### 1. RequestCard

**Ubicación**: `lib/features/requests/presentation/widgets/request_card.dart`

**Propósito**: Tarjeta que muestra un resumen de una solicitud.

```dart
class RequestCard extends ConsumerWidget {
  final String status;
  final String title;
  final String description;
  final String time;
  final VoidCallback? onPress;

  const RequestCard({
    required this.status,
    required this.title,
    required this.description,
    required this.time,
    this.onPress,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Color(0xFF1E3A5F);
      case 'en progreso':
        return AppColors.accent;
      case 'completado':
        return AppColors.primary;
      case 'cancelado':
        return AppColors.grey500;
      default:
        return Color(0xFF1E3A5F);
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Icons.schedule;
      case 'en progreso':
        return Icons.build;
      case 'completado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor();

    return Card(
      elevation: 6,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Barra vertical de color según estado
            Container(
              width: 6,
              decoration: BoxDecoration(color: statusColor),
            ),

            // Contenido
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Estado y tiempo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(_getStatusIcon(), color: statusColor),
                            SizedBox(width: 8),
                            Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(time, style: TextStyle(color: Colors.grey)),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Título
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8),

                    // Descripción
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[700]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 16),

                    // Botón (si existe)
                    if (onPress != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: onPress,
                          child: Text('Cancelar Solicitud'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

#### 2. RequestFilterChip

**Ubicación**: `lib/features/requests/presentation/widgets/request_filter_chip.dart`

**Propósito**: Chip seleccionable para filtrar solicitudes.

```dart
class RequestFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const RequestFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundSoft,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (count != null) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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

---

#### 3. EmptyRequestsWidget

**Ubicación**: `lib/features/requests/presentation/widgets/empty_requests_widget.dart`

**Propósito**: Muestra un mensaje cuando no hay solicitudes.

```dart
class EmptyRequestsWidget extends StatelessWidget {
  final String filterType;
  final VoidCallback? onCreateRequest;

  const EmptyRequestsWidget({
    required this.filterType,
    this.onCreateRequest,
  });

  String _getMessage() {
    switch (filterType.toLowerCase()) {
      case 'pendiente':
        return 'No tienes solicitudes pendientes';
      case 'en progreso':
        return 'No tienes solicitudes en progreso';
      case 'completado':
        return 'No tienes solicitudes completadas';
      case 'cancelado':
        return 'No tienes solicitudes canceladas';
      default:
        return 'No tienes solicitudes aún';
    }
  }

  String _getSubMessage() {
    if (filterType.toLowerCase() == 'todos') {
      return 'Crea tu primera solicitud de servicio';
    }
    return 'Cambia el filtro para ver otras solicitudes';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primaryOverlay10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                filterType.toLowerCase() == 'todos'
                    ? Icons.inbox_outlined
                    : Icons.filter_list_off,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24),
            Text(
              _getMessage(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              _getSubMessage(),
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (filterType.toLowerCase() == 'todos' &&
                onCreateRequest != null) ...[
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onCreateRequest,
                icon: Icon(Icons.add),
                label: Text('Crear Solicitud'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## Casos de Uso Completos

### Caso 1: Cliente Crea una Solicitud

**Escenario**: Un cliente necesita reparar un grifo que gotea.

**Pasos**:
1. Cliente abre la app y navega a "Solicitar Servicio"
2. Selecciona categoría "Plomería"
3. Ingresa título: "Reparación de grifo"
4. Describe el problema: "Tengo una fuga en el grifo de la cocina..."
5. Ingresa dirección: "Calle 24 #17-21, Barrio Chapal"
6. Presiona "Publicar"
7. Sistema valida los datos
8. Sistema guarda en Firestore con estado "pending"
9. Sistema muestra mensaje de éxito
10. Cliente regresa a la pantalla anterior

**Resultado**: Solicitud creada y visible en "Mis Solicitudes".

---

### Caso 2: Cliente Consulta sus Solicitudes

**Escenario**: Un cliente quiere ver el estado de sus solicitudes.

**Pasos**:
1. Cliente navega a "Mis Solicitudes"
2. Sistema carga todas las solicitudes de Firestore
3. Sistema filtra solo las del cliente actual
4. Sistema muestra lista ordenada por fecha
5. Cliente ve 3 solicitudes: 2 pendientes, 1 en progreso
6. Cliente selecciona filtro "Pendiente"
7. Sistema muestra solo las 2 solicitudes pendientes

**Resultado**: Cliente ve sus solicitudes filtradas correctamente.

---

### Caso 3: Cliente Cancela una Solicitud

**Escenario**: Un cliente ya no necesita un servicio y quiere cancelar.

**Pasos**:
1. Cliente está en "Mis Solicitudes"
2. Ve una solicitud pendiente
3. Presiona "Cancelar Solicitud"
4. Sistema muestra diálogo de confirmación
5. Cliente confirma la cancelación
6. Sistema elimina la solicitud de Firestore
7. Sistema recarga la lista de solicitudes
8. Sistema muestra mensaje "Solicitud cancelada"

**Resultado**: Solicitud eliminada y ya no aparece en la lista.

---

### Caso 4: Cliente Ve Detalles de una Solicitud

**Escenario**: Un cliente quiere ver más información sobre una solicitud.

**Pasos**:
1. Cliente está en "Mis Solicitudes"
2. Toca una solicitud en la lista
3. Sistema navega a pantalla de detalles
4. Sistema muestra:
   - Título y estado
   - Fecha de creación
   - Dirección completa
   - Descripción completa
   - Postulaciones (si hay)
5. Cliente puede cancelar desde aquí si está pendiente

**Resultado**: Cliente ve toda la información de la solicitud.

---

## Mejores Prácticas Implementadas

### 1. Clean Architecture
- ✅ Separación en capas (Domain, Data, Presentation)
- ✅ Dependencias apuntan hacia adentro
- ✅ Lógica de negocio independiente de frameworks

### 2. Manejo de Errores con Either
- ✅ Errores tipados (Failure)
- ✅ No se lanzan excepciones
- ✅ Manejo explícito de casos de error

### 3. Gestión de Estado con Riverpod
- ✅ Estado reactivo
- ✅ Reconstrucción automática de widgets
- ✅ Inyección de dependencias

### 4. Validaciones
- ✅ Validaciones en casos de uso
- ✅ Validaciones en UI
- ✅ Mensajes de error claros

### 5. UX
- ✅ Loading states
- ✅ Error states
- ✅ Empty states
- ✅ Pull to refresh
- ✅ Confirmaciones antes de acciones destructivas

---

## Conclusión

El sistema de solicitudes proporciona:
- ✅ Creación de solicitudes con validación
- ✅ Consulta con filtros por estado
- ✅ Cancelación con confirmación
- ✅ Vista detallada de solicitudes
- ✅ Manejo robusto de errores
- ✅ Arquitectura limpia y escalable
- ✅ Estado reactivo con Riverpod
- ✅ UI moderna y responsiva

**Archivos relacionados**:
- `DOCUMENTACION_REQUESTS.md` - Parte 1
- `DOCUMENTACION_REQUESTS_PARTE2.md` - Parte 2
- `DOCUMENTACION_TESTS_REQUESTS.md` - Tests unitarios
- `FIREBASE_SETUP.md` - Configuración de Firebase

---

**Última actualización**: Abril 2026
**Autor**: Equipo ServiPro
