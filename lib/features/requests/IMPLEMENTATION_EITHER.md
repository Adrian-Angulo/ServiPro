# Implementación de Either con fpdart

## ✅ Implementación Completada

Se ha implementado el manejo de errores usando `Either<Failure, Success>` con la librería `fpdart` siguiendo Clean Architecture.

---

## 📦 Dependencia Agregada

```yaml
dependencies:
  fpdart: ^1.1.0
```

---

## 🏗️ Estructura Implementada

### 1. Core Layer - Failures

**`lib/core/errors/failures.dart`**

Clases de error tipadas:
- `Failure` - Clase base abstracta
- `NetworkFailure` - Sin conexión a internet
- `ServerFailure` - Error del servidor
- `ValidationFailure` - Datos inválidos
- `UnexpectedFailure` - Errores inesperados
- `FirebaseFailure` - Errores específicos de Firebase

```dart
abstract class Failure {
  final String message;
  final String? code;
  const Failure({required this.message, this.code});
}
```

---

### 2. Domain Layer

**Repository Interface** (`request_repository.dart`)
```dart
abstract class RequestRepository {
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request);
  Future<Either<Failure, List<RequestEntity>>> allRequest();
  Future<Either<Failure, Unit>> deleteRequest(String id);
}
```

**Use Cases**
- `RegisterUseCase` - Valida y registra solicitudes
- `DeletedRequestUseCase` - Elimina solicitudes

Ambos retornan `Either<Failure, Unit>` para operaciones sin datos de retorno.

---

### 3. Data Layer

**`request_impl.dart`**

Implementa el repositorio con manejo de errores:

```dart
@override
Future<Either<Failure, Unit>> registerRequest(RequestEntity request) async {
  try {
    // Lógica de guardado
    await _firestore.collection('requests').add(requestModel.toMap());
    return right(unit); // Éxito
  } on SocketException {
    return left(const NetworkFailure()); // Error de red
  } on FirebaseException catch (e) {
    return left(FirebaseFailure(message: e.message)); // Error Firebase
  } catch (e) {
    return left(UnexpectedFailure(message: e.toString())); // Error inesperado
  }
}
```

---

### 4. Presentation Layer

**`request_notifier.dart`**

Provider que maneja estados con `Either`:

```dart
Future<Failure?> registerRequest({required RequestEntity request}) async {
  final result = await register.call(request);
  
  return result.fold(
    (failure) {
      state = AsyncValue.error(failure, StackTrace.current);
      return failure; // Retorna el error
    },
    (_) async {
      // Recargar lista
      return null; // Sin error
    },
  );
}
```

**`create_request_screen.dart`**

UI que consume el provider:

```dart
final failure = await ref
    .read(requestNotifierProvider.notifier)
    .registerRequest(request: request);

if (failure != null) {
  _showErrorSnackBar(failure.message); // Mostrar error
} else {
  _showSuccessSnackBar('Solicitud publicada'); // Éxito
  Navigator.pop(context);
}
```

---

## 🔄 Flujo de Datos

```
UI (CreateRequestScreen)
  ↓ Llama a registerRequest
Provider (RequestNotifier)
  ↓ Ejecuta UseCase
UseCase (RegisterUseCase)
  ↓ Valida y llama Repository
Repository (RequestImpl)
  ↓ Intenta guardar en Firestore
  ↓
  ├─ Éxito → Right(unit)
  └─ Error → Left(Failure)
  ↓
UseCase recibe Either
  ↓
Provider recibe Either y actualiza estado
  ↓
UI recibe Failure? y muestra feedback
```

---

## 🎯 Ventajas de Esta Implementación

1. **Errores Tipados**: Cada tipo de error tiene su clase
2. **Sin Excepciones**: No se lanzan excepciones, se retornan errores
3. **Composable**: Se puede encadenar operaciones con `flatMap`, `map`, etc.
4. **Testeable**: Fácil de mockear y testear
5. **Explícito**: El tipo de retorno indica que puede fallar
6. **Type-Safe**: El compilador fuerza el manejo de errores

---

## 📝 Uso de Unit

`Unit` es un tipo que representa "sin valor" en programación funcional.

```dart
// En lugar de Future<void>
Future<Either<Failure, Unit>> registerRequest(...)

// Retornar éxito sin datos
return right(unit);
```

Es equivalente a `void` pero permite ser usado en contextos genéricos.

---

## 🧪 Ejemplo de Uso

```dart
// En el UI
final failure = await ref
    .read(requestNotifierProvider.notifier)
    .registerRequest(request: myRequest);

if (failure != null) {
  // Manejar error específico
  if (failure is NetworkFailure) {
    print('Sin internet');
  } else if (failure is ValidationFailure) {
    print('Datos inválidos: ${failure.message}');
  }
} else {
  print('¡Éxito!');
}
```

---

## 🔍 Validaciones Implementadas

**En RegisterUseCase:**
- Título no vacío
- Descripción no vacía
- Tipo de servicio seleccionado

**En CreateRequestScreen:**
- Todos los campos completos
- Usuario autenticado

---

## 🚀 Próximos Pasos (Opcionales)

1. Agregar coordenadas del mapa a RequestEntity
2. Implementar caché local con Either
3. Agregar más validaciones (longitud mínima, etc.)
4. Implementar retry logic para errores de red
5. Agregar logging de errores
6. Implementar analytics de errores

---

## 📊 Estado Actual

✅ Either implementado en toda la arquitectura
✅ Failures tipados creados
✅ Repository con manejo de errores
✅ Use Cases con validaciones
✅ Provider con Either
✅ UI conectada con feedback de errores
✅ Registro funcional con Firebase
✅ Obtención de usuario autenticado
✅ Loading states implementados

---

## 🎨 UI Features

- Loading overlay durante el registro
- SnackBars de error con mensajes específicos
- SnackBars de éxito
- Validación de formulario
- Deshabilitación de controles durante loading
- Diálogo de confirmación al cancelar

---

## 🔐 Seguridad

- Se obtiene el ID del usuario autenticado
- Se validan todos los campos antes de enviar
- Se manejan errores de Firebase
- Se detectan problemas de red

---

La implementación está completa y lista para usar. El formulario ahora guarda correctamente en Firestore con manejo robusto de errores.
