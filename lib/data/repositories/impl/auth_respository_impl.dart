import 'package:firebase_auth/firebase_auth.dart';
import '../abstracts/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
