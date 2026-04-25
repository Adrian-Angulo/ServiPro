import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servi_pro/core/utils/app_user_factory.dart';
import 'package:servi_pro/features/auth/data/models/cliente.dart';
import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Registro Cliente----------------------------------------
  @override
  Future<void> registerCliente({
    required String id,
    required String email,
    required String password,
    required String nombre,
    required String edad,
    required String telefono,
    required String cedula,
    required Rol rol,
    required String ciudad,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      final user = Cliente(
        id: uid,
        email: email,
        nombre: nombre,
        rol: Rol.cliente,
        edad: edad,
        ciudad: ciudad,
        contrasena: '',
        cedula: cedula,
        telefono: telefono,
      );

      final userData = user.toMap();
      print('Guardando datos del cliente en Firestore: $userData');

      await _firestore.collection('users').doc(uid).set(userData);

      print('Cliente registrado exitosamente con UID: $uid');
    } catch (e) {
      print('Error al registrar cliente: $e');
      rethrow;
    }
  }

  //Registro Trabajador----------------------------------------
  @override
  Future<void> registerTrabajador({
    required String email,
    required String password,
    required String nombreCompleto,
    required int edad,
    required String ciudad,
    required String celular,
    required String cedula,
    required String sobreMi,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      final user = Trabajador(
        id: uid,
        email: email,
        contrasena: '',
        nombreCompleto: nombreCompleto,
        edad: edad,
        ciudad: ciudad,
        celular: celular,
        cedula: cedula,
        sobreMi: sobreMi,
        rol: Rol.trabajador,
      );

      final userData = user.toMap();
      print('Guardando datos del trabajador en Firestore: $userData');

      await _firestore.collection('users').doc(uid).set(userData);

      print('Trabajador registrado exitosamente con UID: $uid');
    } catch (e) {
      print('Error al registrar trabajador: $e');
      rethrow;
    }
  }

  //Login------------------------------------------------

  @override
  Future<Usuario> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final doc = await _firestore.collection('users').doc(uid).get();

    return AppUserFactory.fromMap(doc.data()!);
  }

  //Cerrar sesion -------------------------------------------

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //Obtener usuario actual----------------------------------

  @override
  Future<Usuario?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    return AppUserFactory.fromMap(doc.data()!);
  }

  //Recuperar contraseña------------------------------------

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  //Obtener trabajador por ID-------------------------------

  @override
  Future<Usuario?> getWorkerById({required String id}) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return AppUserFactory.fromMap(doc.data()!);
  }
}
