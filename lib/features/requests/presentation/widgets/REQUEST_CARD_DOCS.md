# RequestCard Widget

Widget reutilizable para mostrar solicitudes de servicio con un diseño moderno y consistente.

## 📍 Ubicación
```
lib/features/requests/presentation/widgets/request_card.dart
```

## 🎯 Propósito
Componente visual puro (sin lógica de negocio) que representa una tarjeta de solicitud de servicio con estado, título, descripción y acción de cancelación.

## 📦 Parámetros

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| `status` | `String` | ✅ | Estado de la solicitud (ej: "Pendiente", "En progreso", "Completado", "Cancelado") |
| `title` | `String` | ✅ | Título de la solicitud |
| `description` | `String` | ✅ | Descripción detallada (máximo 3 líneas con ellipsis) |
| `time` | `String` | ✅ | Tiempo transcurrido (ej: "Hace 4 horas") |
| `onCancel` | `VoidCallback?` | ❌ | Callback opcional para el botón de cancelar |

## 🎨 Características Visuales

### Estructura
- **Card** con elevación sutil y bordes redondeados
- **Barra vertical izquierda** que indica el estado con color
- **Layout en columna** con espaciado consistente

### Colores por Estado
- **Pendiente**: Azul oscuro (#1E3A5F)
- **En progreso**: Naranja (AppColors.accent)
- **Completado**: Verde (AppColors.primary)
- **Cancelado**: Gris (AppColors.grey500)

### Iconos por Estado
- **Pendiente**: `Icons.schedule`
- **En progreso**: `Icons.build`
- **Completado**: `Icons.check_circle`
- **Cancelado**: `Icons.cancel`

### Secciones
1. **Header**: Estado (icono + texto) y tiempo
2. **Título**: Texto destacado en negrita
3. **Descripción**: Texto secundario con máximo 3 líneas
4. **Botón**: "Cancelar Solicitud" (solo si `onCancel` no es null)

## 💻 Uso Básico

```dart
RequestCard(
  status: 'Pendiente',
  title: 'Mantenimiento preventivo calefón',
  description: 'Limpieza general y revisión de válvulas para calefón a gas. Se requiere para el fin de...',
  time: 'Hace 4 horas',
  onCancel: () {
    // Lógica para cancelar la solicitud
    print('Cancelar solicitud');
  },
)
```

## 📋 Ejemplos de Uso

### Con botón de cancelar
```dart
RequestCard(
  status: 'Pendiente',
  title: 'Reparación de grifo',
  description: 'Tengo una fuga en el grifo de la cocina',
  time: 'Hace 2 horas',
  onCancel: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Cancelar solicitud?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Cancelar solicitud
              Navigator.pop(context);
            },
            child: Text('Sí'),
          ),
        ],
      ),
    );
  },
)
```

### Sin botón (solicitud completada)
```dart
const RequestCard(
  status: 'Completado',
  title: 'Instalación de lámpara',
  description: 'Instalación de lámpara LED en el techo del comedor',
  time: 'Hace 1 semana',
  // onCancel no se proporciona
)
```

### En una lista
```dart
ListView.separated(
  itemCount: requests.length,
  separatorBuilder: (context, index) => const SizedBox(height: 16),
  itemBuilder: (context, index) {
    final request = requests[index];
    return RequestCard(
      status: request.status,
      title: request.title,
      description: request.description,
      time: _formatTime(request.dateCreated),
      onCancel: request.status == 'Pendiente'
          ? () => _cancelRequest(request.id)
          : null,
    );
  },
)
```

## 🎯 Buenas Prácticas

### ✅ Hacer
- Usar el widget en listas con `ListView.separated`
- Proporcionar `onCancel` solo para solicitudes cancelables
- Usar textos descriptivos y concisos
- Formatear el tiempo de manera legible (ej: "Hace 2 horas")

### ❌ Evitar
- No incluir lógica de negocio en el widget
- No hacer el texto de descripción muy largo (se truncará)
- No usar colores personalizados, el widget los maneja automáticamente

## 🔧 Personalización

Si necesitas personalizar el widget, puedes:

1. **Agregar más estados**: Modificar `_getStatusColor()` y `_getStatusIcon()`
2. **Cambiar colores**: Ajustar los valores en `_getStatusColor()`
3. **Modificar el botón**: Cambiar el texto o estilo del `ElevatedButton`

## 📱 Responsive

El widget es responsive por defecto:
- Usa `Expanded` para adaptarse al ancho disponible
- El texto se trunca automáticamente con ellipsis
- El botón se alinea correctamente en diferentes tamaños

## 🎨 Tema

El widget usa:
- `AppColors` para colores consistentes
- `AppTypography` para tipografía
- `AppSpacing` para espaciado

## 🧪 Testing

Para testear el widget:

```dart
testWidgets('RequestCard displays correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: RequestCard(
          status: 'Pendiente',
          title: 'Test Title',
          description: 'Test Description',
          time: 'Hace 1 hora',
          onCancel: () {},
        ),
      ),
    ),
  );

  expect(find.text('PENDIENTE'), findsOneWidget);
  expect(find.text('Test Title'), findsOneWidget);
  expect(find.text('Test Description'), findsOneWidget);
  expect(find.text('Hace 1 hora'), findsOneWidget);
  expect(find.text('Cancelar Solicitud'), findsOneWidget);
});
```

## 📸 Preview

El widget se ve así:

```
┌─────────────────────────────────────────┐
│ ┃ 📅 PENDIENTE        Hace 4 horas      │
│ ┃                                        │
│ ┃ Mantenimiento preventivo calefón      │
│ ┃                                        │
│ ┃ Limpieza general y revisión de        │
│ ┃ válvulas para calefón a gas. Se...    │
│ ┃                                        │
│ ┃              [Cancelar Solicitud]     │
└─────────────────────────────────────────┘
```

## 🔗 Archivos Relacionados

- `lib/core/theme/app_colors.dart` - Colores del tema
- `lib/core/theme/app_typography.dart` - Tipografía
- `lib/core/theme/app_spacing.dart` - Espaciado
- `lib/features/requests/presentation/widgets/request_card_example.dart` - Ejemplos de uso

## 📝 Notas

- El widget es **stateless** y completamente reutilizable
- No contiene lógica de negocio, solo presentación
- Los callbacks se manejan desde el padre
- El color y el icono se determinan automáticamente según el estado
