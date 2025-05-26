import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e.toString().contains("is not a subtype of type 'PigeonUserDetails?'")) {
        // Ignora esse erro específico
        print('Ignorando erro específico: $e');
        return null;
      } else {
        print('Erro ao fazer login: $e');
        rethrow;
      }
    }
  }

  // Register with email and password
Future<UserCredential?> registerWithEmailAndPassword(
  String email,
  String password, {
  String? username,
}) async {
  UserCredential? userCredential;

  try {
    userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    if (e.toString().contains("is not a subtype of type 'PigeonUserDetails?'")) {
      print('Ignorando erro específico: $e');
      // Continua sem userCredential
    } else {
      print('Erro ao registrar usuário: $e');
      // Opcional: rethrow ou continuar
    }
  }

  // Continua o código mesmo que userCredential seja nulo
  final user = userCredential?.user ?? _auth.currentUser;
  if (user != null) {
    final userRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        'uid': user.uid,
        'email': email,
        'username': username,
        'photoUrl': '',  
      });
    }
  } else {
    print('Nenhum usuário válido disponível para continuar.');
  }

  return userCredential;
}

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  // Update username
  Future<void> updateUsername(String newUsername) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'username': newUsername,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'photoUrl': photoUrl
      });
    }
  }
}
