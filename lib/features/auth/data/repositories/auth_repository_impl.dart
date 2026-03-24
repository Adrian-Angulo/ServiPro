import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servi_pro/data/factories/app_user_factory.dart';
import 'package:servi_pro/data/models/cliente.dart';
import 'package:servi_pro/data/models/usuario.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Registro----------------------------------------
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

    await _firestore.collection('users').doc(uid).set(user.toMap());
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
}
