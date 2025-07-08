// Signup screen widget for new user registration
// This file contains the UI and logic for user registration functionality

// Import Flutter Material package for UI components
import 'package:flutter/material.dart';
// Import Provider package for state management
import 'package:provider/provider.dart';
// Import the authentication provider for signup operations
import '../../provider/auth_provider.dart';

/// Signup screen widget that provides user registration interface
///
/// This widget allows users to:
/// - Enter email and password credentials for new account
/// - Submit registration form
/// - Navigate back to login screen if they already have an account
/// - View validation messages and error feedback
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

/// State class for SignupScreen widget
///
/// Manages:
/// - Form input controllers for email and password
/// - Form validation logic
/// - Signup submission process
/// - Navigation back to login screen
class _SignupScreenState extends State<SignupScreen> {
  /// Controller for email text field
  final _emailController = TextEditingController();

  /// Controller for password text field
  final _passwordController = TextEditingController();

  /// Handles the signup process
  ///
  /// This method:
  /// - Validates that both email and password fields are filled
  /// - Shows error message if validation fails
  /// - Calls the AuthProvider signUp method if validation passes
  /// - Navigates back to login screen after successful signup (user will be auto-logged in)
  void _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate that both fields are filled
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call the AuthProvider signUp method
    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).signUp(email, password, context);

    // If signup was successful, navigate back to login
    // Firebase Auth will automatically sign in the user, and RootWidget will handle navigation
    if (success && mounted) {
      Navigator.pop(context); // Go back to login screen
    }
  }

  /// Builds the signup screen UI
  ///
  /// Creates a form with:
  /// - Email input field
  /// - Password input field (obscured)
  /// - Sign up button
  /// - Link back to login screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            // Password input field with obscured text
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, // Hide password text
            ),
            const SizedBox(height: 20),
            // Sign up button
            ElevatedButton(onPressed: _signup, child: const Text('Sign Up')),
            // Navigation link back to login screen
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login screen
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
