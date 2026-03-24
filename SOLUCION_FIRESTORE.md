# Solución al problema de registro en Firestore

## Problema identificado y corregido:

### 1. Error en el método toMap() de Cliente
El campo `rol` se estaba guardando como enum en lugar de string.

**Corregido:** Ahora usa `rol.name` para convertir el enum a string.

### 2. Logs de depuración agregados
Se agregaron logs en los métodos de registro para verificar:
- Los datos que se están guardando
- El UID del usuario creado
- Cualquier error que ocurra

## Pasos para verificar que funciona:

### 1. Configurar reglas de Firestore
En Firebase Console:
1. Ve a Firestore Database
2. Selecciona la pestaña "Reglas"
3. Copia y pega las reglas del archivo `firestore.rules`
4. Haz clic en "Publicar"

### 2. Verificar la consola de depuración
Cuando registres un usuario, deberías ver en la consola:
```
Guardando datos del cliente en Firestore: {id: xxx, nombre: xxx, email: xxx, ...}
Cliente registrado exitosamente con UID: xxx
```

### 3. Verificar en Firebase Console
1. Ve a Firestore Database
2. Busca la colección `users`
3. Deberías ver un documento con el UID del usuario
4. El documento debe contener todos los campos: id, nombre, email, edad, ciudad, cedula, telefono, rol

## Si el problema persiste:

### Verificar permisos de Firestore:
Las reglas actuales requieren que el usuario esté autenticado. Si quieres permitir escritura durante el registro (antes de que el token se actualice), usa temporalmente:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Verificar la conexión a Firebase:
Asegúrate de que:
1. `flutterfire configure` se ejecutó correctamente
2. El archivo `firebase_options.dart` tiene las credenciales correctas
3. Firebase está inicializado en `main.dart`

### Verificar en tiempo real:
Abre Firebase Console → Firestore Database y observa en tiempo real mientras registras un usuario.

## Cambios realizados:

1. ✅ `lib/data/models/cliente.dart` - Corregido `toMap()` para usar `rol.name`
2. ✅ `lib/features/auth/data/repositories/auth_repository_impl.dart` - Agregados logs y try-catch
3. ✅ `firestore.rules` - Creadas reglas de seguridad recomendadas
