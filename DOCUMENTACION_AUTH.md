# Documentación del Sistema de Autenticación - ServiPro

## Índice
1. [Arquitectura General](#arquitectura-general)
2. [Flujo de Autenticación](#flujo-de-autenticación)
3. [Estructura de Archivos](#estructura-de-archivos)
4. [Modelos de Datos](#modelos-de-datos)
5. [Casos de Uso](#casos-de-uso)
6. [Manejo de Errores](#manejo-de-errores)

---

## Arquitectura General

El sistema de autenticación sigue una arquitectura limpia (Clean Architecture) con las siguientes capas:

```
lib/features/auth/
├── data/
│   ├── models/          # Modelos de datos específicos de Firebase
│   └── repositories/    # Implementación de repositorios
├── domain/
│   ├── entities/        # Entidades del dominio
│   ├── repositories/    # Interfaces de repositorios
│   └── usecases/        # Casos de uso del negocio
└── presentation/
    ├── providers/       # Estado con Riverpod
    ├── screens/         # Pantallas de UI
    └── widgets/         # Componentes reutilizables
```

### Tecnologías Utilizadas
- **Firebase Auth**: Autenticación de usuarios
- **Cloud Firestore**: Almacenamiento de datos de usuarios
- **Riverpod**: Gestión de estado reactivo
- **Flutter**: Framework de UI

---

## Flujo de Autenticación

### 1. Flujo de Registro

#### A. Registro de Cliente

```
┌─────────────────┐
│  Onboarding     │
│  Screen         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Selección      │
│  de Rol         │ ──► Usuario selecciona "Cliente"
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Register       │
│  Screen         │ ──► Formulario de registro
│  (Cliente)      │     - Nombre completo
└────────┬────────┘     - Edad
         │              - Ciudad
         │              - Cédula
         │              - Teléfono
         │              - Email
         │              - Contraseña
         ▼
┌─────────────────┐
│  AuthNotifier   │
│  .registerCliente()
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthRepository │
│  Impl           │
└────────┬────────┘
         │
         ├──► 1. Firebase Auth: createUserWithEmailAndPassword()
         │
         ├──► 2. Crear objeto Cliente con UID
         │
         ├──► 3. Firestore: Guardar en collection('users').doc(uid)
         │
         └──► 4. Auto-login y obtener datos del usuario
                │
                ▼
         ┌─────────────────┐
         │  Client Home    │
         │  Screen         │
         └─────────────────┘
```

#### B. Registro de Trabajador

```
┌─────────────────┐
│  Selección      │
│  de Rol         │ ──► Usuario selecciona "Trabajador"
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Registro       │
│  Trabajador     │ ──► Formulario extendido
│  Screen         │     - Nombre completo
└────────┬────────┘     - Edad
         │              - Ciudad
         │              - Cédula
         │              - Celular
         │              - Email
         │              - Contraseña
         │              - Sobre mí (descripción)
         ▼
┌─────────────────┐
│  AuthNotifier   │
│  .registerTrabajador()
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthRepository │
│  Impl           │
└────────┬────────┘
         │
         ├──► 1. Firebase Auth: createUserWithEmailAndPassword()
         │
         ├──► 2. Crear objeto Trabajador con UID
         │
         ├──► 3. Firestore: Guardar en collection('users').doc(uid)
         │
         └──► 4. Auto-login y obtener datos del usuario
                │
                ▼
         ┌─────────────────┐
         │  Worker Home    │
         │  Screen         │
         └─────────────────┘
```

### 2. Flujo de Login

```
┌─────────────────┐
│  Login Screen   │
└────────┬────────┘
         │
         │ Usuario ingresa:
         │ - Email
         │ - Contraseña
         │
         ▼
┌─────────────────┐
│  LoginForm      │
│  ._login()      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthNotifier   │
│  .login()       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthRepository │
│  Impl           │
└────────┬────────┘
         │
         ├──► 1. Firebase Auth: signInWithEmailAndPassword()
         │
         ├──► 2. Obtener UID del usuario autenticado
         │
         ├──► 3. Firestore: Leer datos de collection('users').doc(uid)
         │
         └──► 4. AppUserFactory.fromMap() - Crear instancia según rol
                │
                ├──► Si rol == "cliente"
                │    └──► Cliente.fromMap()
                │         └──► Client Home Screen
                │
                └──► Si rol == "trabajador"
                     └──► Trabajador.fromMap()
                          └──► Worker Home Screen
```

### 3. Flujo de Logout

```
┌─────────────────┐
│  Home Screen    │
│  (Cliente o     │
│   Trabajador)   │
└────────┬────────┘
         │
         │ Usuario presiona botón logout
         │
         ▼
┌─────────────────┐
│  AuthNotifier   │
│  .logout()      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthRepository │
│  Impl           │
└────────┬────────┘
         │
         ├──► 1. Firebase Auth: signOut()
         │
         └──► 2. Limpiar estado (user = null)
                │
                ▼
         ┌─────────────────┐
         │  Login Screen   │
         └─────────────────┘
```

### 4. Flujo de Verificación de Sesión

```
┌─────────────────┐
│  App Inicia     │
│  (main.dart)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Firebase       │
│  .initializeApp()│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  ProviderScope  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthNotifier   │
│  .build()       │ ──► Se ejecuta automáticamente
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthRepository │
│  .getCurrentUser()
└────────┬────────┘
         │
         ├──► 1. Firebase Auth: currentUser
         │
         ├──► 2. Si user == null → return null
         │
         └──► 3. Si user != null
                │
                ├──► Firestore: Leer datos del usuario
                │
                └──► AppUserFactory.fromMap()
                     │
                     ├──► Usuario autenticado → Home Screen
                     │
                     └──► No autenticado → Onboarding/Login
```

---

## Estructura de Archivos

### Capa de Dominio (Domain Layer)

#### `lib/features/auth/domain/repositories/auth_repository.dart`
```dart
abstract class AuthRepository {
  Future<void> registerCliente({...});
  Future<void> registerTrabajador({...});
  Future<Usuario> login({...});
  Future<void> logout();
  Future<Usuario?> getCurrentUser();
}
```
**Propósito**: Define el contrato que debe cumplir cualquier implementación del repositorio.

#### `lib/features/auth/domain/usecases/login_use_case.dart`
```dart
class LoginUseCase {
  Future<Usuario> call(String email, String password);
}
```
**Propósito**: Encapsula la lógica de negocio del login.

### Capa de Datos (Data Layer)

#### `lib/features/auth/data/repositories/auth_repository_impl.dart`
**Propósito**: Implementación concreta del repositorio usando Firebase.

**Métodos principales**:
- `registerCliente()`: Crea usuario en Auth y guarda datos en Firestore
- `registerTrabajador()`: Similar pero con campos adicionales
- `login()`: Autentica y recupera datos del usuario
- `logout()`: Cierra sesión
- `getCurrentUser()`: Obtiene el usuario actual si existe

#### `lib/data/models/usuario.dart`
```dart
enum Rol { cliente, trabajador }

class Usuario {
  final String id;
  final String email;
  final String contrasena;
  final Rol rol;
}
```
**Propósito**: Clase base para todos los tipos de usuarios.

#### `lib/data/models/cliente.dart`
```dart
class Cliente extends Usuario {
  final String nombre;
  final String edad;
  final String ciudad;
  final String cedula;
  final String telefono;
  
  Map<String, dynamic> toMap();
  factory Cliente.fromMap(Map<String, dynamic> map);
}
```
**Propósito**: Modelo específico para clientes con serialización Firestore.

#### `lib/data/models/trabajador.dart`
```dart
class Trabajador extends Usuario {
  final String nombreCompleto;
  final int edad;
  final String ciudad;
  final String celular;
  final String cedula;
  final String sobreMi;
  
  Map<String, dynamic> toMap();
  factory Trabajador.fromMap(Map<String, dynamic> map);
}
```
**Propósito**: Modelo específico para trabajadores.

#### `lib/data/factories/app_user_factory.dart`
```dart
class AppUserFactory {
  static Usuario fromMap(Map<String, dynamic> map) {
    switch (map['rol']) {
      case 'cliente': return Cliente.fromMap(map);
      case 'trabajador': return Trabajador.fromMap(map);
      default: throw Exception('Rol no válido');
    }
  }
}
```
**Propósito**: Factory pattern para crear instancias correctas según el rol.

### Capa de Presentación (Presentation Layer)

#### `lib/features/auth/presentation/providers/auth_provider.dart`
```dart
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, Usuario?>(
  () => AuthNotifier(),
);
```
**Propósito**: Proveedores de Riverpod para inyección de dependencias.

#### `lib/features/auth/presentation/providers/auth_notifier.dart`
```dart
class AuthNotifier extends AsyncNotifier<Usuario?> {
  @override
  Future<Usuario?> build() async {
    return await repository.getCurrentUser();
  }
  
  Future<bool> login({...});
  Future<bool> registerCliente({...});
  Future<bool> registerTrabajador({...});
  Future<void> logout();
}
```
**Propósito**: Gestiona el estado de autenticación usando AsyncNotifier de Riverpod.

**Estados posibles**:
- `AsyncValue.loading()`: Operación en progreso
- `AsyncValue.data(Usuario)`: Usuario autenticado
- `AsyncValue.data(null)`: No hay usuario autenticado
- `AsyncValue.error(error)`: Error en la operación

#### Pantallas

**`lib/features/auth/presentation/screens/login_screen.dart`**
- Formulario de login
- Validación de campos
- Muestra errores
- Redirección según rol

**`lib/features/auth/presentation/screens/register_screen.dart`**
- Formulario de registro para clientes
- Validación completa
- Términos y condiciones
- Auto-login después del registro

**`lib/features/auth/presentation/screens/registro_trabajador_screen.dart`**
- Formulario extendido para trabajadores
- Campos adicionales (sobre mí)
- Validación de edad mínima
- Auto-login después del registro

**`lib/features/auth/presentation/screens/seleccion_rol_screen.dart`**
- Selección de rol (Cliente o Trabajador)
- Navegación al formulario correspondiente

---

## Modelos de Datos

### Estructura en Firestore

#### Colección: `users`

**Documento de Cliente**:
```json
{
  "id": "firebase_uid_123",
  "email": "cliente@ejemplo.com",
  "nombre": "Juan Pérez",
  "edad": "25",
  "ciudad": "Pasto, Nariño",
  "cedula": "1234567890",
  "telefono": "3001234567",
  "rol": "cliente"
}
```

**Documento de Trabajador**:
```json
{
  "id": "firebase_uid_456",
  "email": "trabajador@ejemplo.com",
  "nombreCompleto": "María García",
  "edad": 30,
  "ciudad": "Pasto, Nariño",
  "celular": "3009876543",
  "cedula": "9876543210",
  "sobreMi": "Experta en plomería con 5 años de experiencia...",
  "rol": "trabajador"
}
```

### Jerarquía de Clases

```
Usuario (abstract)
├── Cliente
│   ├── nombre: String
│   ├── edad: String
│   ├── ciudad: String
│   ├── cedula: String
│   └── telefono: String
│
└── Trabajador
    ├── nombreCompleto: String
    ├── edad: int
    ├── ciudad: String
    ├── celular: String
    ├── cedula: String
    └── sobreMi: String
```

---

## Casos de Uso

### 1. Usuario nuevo se registra como Cliente

**Entrada**:
- Nombre: "Juan Pérez"
- Edad: "25"
- Ciudad: "Pasto, Nariño"
- Cédula: "1234567890"
- Teléfono: "3001234567"
- Email: "juan@ejemplo.com"
- Contraseña: "password123"

**Proceso**:
1. Usuario completa formulario en `RegisterScreen`
2. Presiona "Crear cuenta"
3. `AuthNotifier.registerCliente()` se ejecuta
4. Firebase Auth crea usuario con email/password
5. Se obtiene el UID del usuario creado
6. Se crea objeto `Cliente` con todos los datos
7. Se guarda en Firestore: `users/{uid}`
8. Auto-login: se autentica automáticamente
9. Navegación a `ClientHomeScreen`

**Salida**: Usuario registrado, autenticado y en pantalla de inicio.

### 2. Usuario existente inicia sesión

**Entrada**:
- Email: "juan@ejemplo.com"
- Contraseña: "password123"

**Proceso**:
1. Usuario ingresa credenciales en `LoginScreen`
2. Presiona "Iniciar sesión"
3. `AuthNotifier.login()` se ejecuta
4. Firebase Auth valida credenciales
5. Se obtiene el UID del usuario
6. Se leen datos de Firestore: `users/{uid}`
7. `AppUserFactory` crea instancia según rol
8. Estado se actualiza con el usuario
9. Navegación según rol:
   - Cliente → `ClientHomeScreen`
   - Trabajador → `WorkerHomeScreen`

**Salida**: Usuario autenticado en pantalla correspondiente.

### 3. Usuario cierra sesión

**Entrada**: Usuario presiona botón de logout

**Proceso**:
1. `AuthNotifier.logout()` se ejecuta
2. Firebase Auth cierra sesión
3. Estado se limpia (user = null)
4. Navegación a `LoginScreen`

**Salida**: Usuario desautenticado.

---

## Manejo de Errores

### Errores de Firebase Auth

El sistema traduce los errores de Firebase a mensajes en español:

| Código de Error | Mensaje al Usuario |
|----------------|-------------------|
| `user-not-found` | "No existe una cuenta con ese correo" |
| `wrong-password` | "Correo o contraseña incorrectos" |
| `invalid-credential` | "Correo o contraseña incorrectos" |
| `too-many-requests` | "Demasiados intentos. Espera unos minutos" |
| `network-request-failed` | "Sin conexión a internet" |
| `email-already-in-use` | "Este correo ya está registrado" |
| `weak-password` | "La contraseña debe tener al menos 6 caracteres" |
| `invalid-email` | "Correo electrónico inválido" |
| Otros | "Ocurrió un error. Intenta de nuevo" |

### Validaciones en el Cliente

**RegisterScreen (Cliente)**:
- Nombre: No vacío
- Edad: Número válido, mayor de 18
- Cédula: No vacío
- Teléfono: No vacío
- Email: Formato válido (contiene @)
- Contraseña: Mínimo 6 caracteres
- Confirmar contraseña: Debe coincidir
- Términos: Debe aceptar

**RegistroTrabajadorScreen**:
- Nombre completo: No vacío
- Edad: Número válido, entre 18 y 99
- Cédula: 8-10 dígitos
- Celular: Exactamente 10 dígitos
- Email: Formato válido
- Contraseña: Mínimo 6 caracteres
- Confirmar contraseña: Debe coincidir
- Sobre mí: Opcional

### Manejo de Estados con Riverpod

```dart
// En los widgets
final authState = ref.watch(authNotifierProvider);

authState.when(
  data: (user) {
    if (user != null) {
      // Usuario autenticado
    } else {
      // No hay usuario
    }
  },
  loading: () {
    // Mostrar loading
  },
  error: (error, stack) {
    // Mostrar error
  },
);
```

---

## Seguridad

### Reglas de Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Solo el usuario puede leer sus propios datos
      allow read: if request.auth != null && request.auth.uid == userId;
      
      // Solo el usuario puede crear su propio documento
      allow create: if request.auth != null && request.auth.uid == userId;
      
      // Solo el usuario puede actualizar sus propios datos
      allow update: if request.auth != null && request.auth.uid == userId;
      
      // No se permite eliminar
      allow delete: if false;
    }
  }
}
```

### Buenas Prácticas Implementadas

1. **No se guarda la contraseña en Firestore**: Solo en Firebase Auth
2. **Validación en cliente y servidor**: Firebase valida en el backend
3. **Tokens automáticos**: Firebase maneja los tokens de sesión
4. **Separación de roles**: Cliente y Trabajador tienen datos diferentes
5. **Factory pattern**: Crea instancias correctas según el rol
6. **Manejo de errores**: Traduce errores técnicos a mensajes amigables

---

## Extensibilidad

### Agregar un nuevo tipo de usuario

1. Crear modelo en `lib/data/models/nuevo_tipo.dart`
2. Extender de `Usuario`
3. Implementar `toMap()` y `fromMap()`
4. Agregar caso en `AppUserFactory`
5. Agregar método en `AuthRepository`
6. Implementar en `AuthRepositoryImpl`
7. Agregar método en `AuthNotifier`
8. Crear pantalla de registro
9. Crear pantalla de inicio

### Agregar autenticación con Google/Facebook

1. Configurar en Firebase Console
2. Agregar dependencias en `pubspec.yaml`
3. Agregar métodos en `AuthRepository`
4. Implementar en `AuthRepositoryImpl`
5. Agregar botones en `LoginScreen`
6. Manejar el flujo en `AuthNotifier`

---

## Debugging

### Logs Implementados

El sistema incluye logs para debugging:

```dart
print('Guardando datos del cliente en Firestore: $userData');
print('Cliente registrado exitosamente con UID: $uid');
print('Error al registrar cliente: $e');
```

### Verificar en Firebase Console

1. **Firebase Auth**: Ver usuarios registrados
2. **Firestore**: Ver documentos en colección `users`
3. **Logs**: Ver errores en tiempo real

---

## Conclusión

Este sistema de autenticación proporciona:
- ✅ Registro diferenciado por roles
- ✅ Login unificado con redirección automática
- ✅ Persistencia de sesión
- ✅ Manejo robusto de errores
- ✅ Arquitectura limpia y escalable
- ✅ Seguridad con Firebase
- ✅ Estado reactivo con Riverpod

Para más información, consulta:
- `FIREBASE_SETUP.md` - Configuración de Firebase
- `SOLUCION_FIRESTORE.md` - Solución de problemas comunes
