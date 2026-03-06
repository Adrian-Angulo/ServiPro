# Configuración de Firebase para ServiPro

## Pasos para completar la configuración:

### 1. Configurar Firebase CLI
Ejecuta el siguiente comando en tu terminal para configurar Firebase:

```bash
flutterfire configure
```

Este comando te guiará a través de:
- Seleccionar o crear un proyecto de Firebase
- Seleccionar las plataformas (Android, iOS, Web, etc.)
- Generar automáticamente el archivo `lib/firebase_options.dart`

### 2. Habilitar Authentication en Firebase Console
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a "Authentication" en el menú lateral
4. Haz clic en "Get Started"
5. Habilita "Email/Password" como método de inicio de sesión

### 3. (Opcional) Configurar Firestore
Si necesitas usar Firestore:
1. Ve a "Firestore Database" en Firebase Console
2. Haz clic en "Create database"
3. Selecciona el modo (producción o prueba)
4. Elige la ubicación del servidor

### 4. Ejecutar la aplicación
Una vez completados los pasos anteriores:

```bash
flutter pub get
flutter run
```

## Archivos configurados:
- ✅ `pubspec.yaml` - Dependencias de Firebase agregadas
- ✅ `lib/main.dart` - Inicialización de Firebase
- ✅ `lib/data/repositories/impl/auth_respository_impl.dart` - Implementación de autenticación
- ⏳ `lib/firebase_options.dart` - Se generará con `flutterfire configure`

## Notas importantes:
- El archivo `firebase_options.dart` se generará automáticamente
- No necesitas editar manualmente los archivos de configuración de Android/iOS
- FlutterFire CLI maneja toda la configuración de plataforma
