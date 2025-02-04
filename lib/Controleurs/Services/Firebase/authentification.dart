import 'package:firebase_auth/firebase_auth.dart';

class Authentification {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentuser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Méthode pour se connecter avec E-mail et Mot de Passe
  Future<void> loginWithEmailAndPassword(
    String email,
    String passeword,
  ) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: passeword);
  }

  // Méthode pour se déconnecter
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Méthode pour créer un compte utilisateur
  Future<void> createUserWithEmailAndPassword(
      String email, String passeword) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: passeword);
  }
}
