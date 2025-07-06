import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  bool isLoading = true;

  AuthProvider() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      user = firebaseUser;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!context.mounted) return; // Ensure context is still valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign-up successful'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
    }
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) return; // Ensure context is still valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
    }
  }

  void logout() async {
    await _auth.signOut();
  }

  void _handleAuthError(FirebaseAuthException e, BuildContext context) {
    String message;

    switch (e.code) {
      case 'invalid-email':
        message = 'Invalid email address';
        break;
      case 'weak-password':
        message = 'Password should be at least 6 characters';
        break;
      case 'email-already-in-use':
        message = 'This email is already registered';
        break;
      case 'user-not-found':
        message = 'User not found';
        break;
      case 'wrong-password':
        message = 'Incorrect password';
        break;
      default:
        message = 'Authentication error: ${e.message}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
