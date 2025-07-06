// Authentication provider using Firebase Auth and Flutter's Provider pattern
// This file handles all authentication-related operations and state management

// Import Firebase Authentication package for user authentication
import 'package:firebase_auth/firebase_auth.dart';
// Import Flutter Material package for UI components and context
import 'package:flutter/material.dart';

/// Provider class that manages authentication state and operations
///
/// This class extends ChangeNotifier to provide reactive state management
/// for authentication-related data and operations including:
/// - User sign up and login
/// - User logout
/// - Authentication state monitoring
/// - Error handling for authentication operations
///
/// The provider listens to Firebase Auth state changes and notifies
/// dependent widgets when authentication state changes.
class AuthProvider extends ChangeNotifier {
  /// Private instance of FirebaseAuth for handling authentication operations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current authenticated user, null if not authenticated
  User? user;

  /// Loading state indicator for authentication operations
  bool isLoading = true;

  /// Constructor that sets up authentication state listener
  ///
  /// Automatically listens to Firebase Auth state changes and updates
  /// the user property and loading state accordingly
  AuthProvider() {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((User? firebaseUser) {
      user = firebaseUser;
      isLoading = false;
      notifyListeners(); // Notify all listening widgets about state changes
    });
  }

  /// Creates a new user account with email and password
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// [context] - BuildContext for showing snackbar messages
  ///
  /// Shows success message on successful registration
  /// Shows error message if registration fails
  Future<void> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Attempt to create user account with Firebase Auth
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!context.mounted) return; // Ensure context is still valid
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign-up successful'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      _handleAuthError(e, context);
    }
  }

  /// Signs in existing user with email and password
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// [context] - BuildContext for showing snackbar messages
  ///
  /// Shows success message on successful login
  /// Shows error message if login fails
  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Attempt to sign in user with Firebase Auth
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) return; // Ensure context is still valid
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      _handleAuthError(e, context);
    }
  }

  /// Signs out the current user
  ///
  /// This method signs out the user from Firebase Auth
  /// The auth state listener will automatically update the user property to null
  void logout() async {
    await _auth.signOut();
  }

  /// Private method to handle Firebase authentication errors
  ///
  /// [e] - The FirebaseAuthException that occurred
  /// [context] - BuildContext for showing snackbar messages
  ///
  /// This method converts Firebase error codes to user-friendly messages
  /// and displays them using a SnackBar with red background
  void _handleAuthError(FirebaseAuthException e, BuildContext context) {
    String message;

    // Map Firebase error codes to user-friendly messages
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

    // Display error message to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
