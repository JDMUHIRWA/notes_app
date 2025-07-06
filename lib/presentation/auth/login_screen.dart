// Login screen widget for user authentication
// This file contains the UI and logic for user login functionality

// Import Flutter Material package for UI components
import 'package:flutter/material.dart';
// Import Provider package for state management
import 'package:provider/provider.dart';
// Import the authentication provider for login operations
import '../../provider/auth_provider.dart';
// Import signup screen for navigation
import 'signup_screen.dart';

/// Login screen widget that provides user authentication interface
///
/// This widget allows users to:
/// - Enter email and password credentials
/// - Submit login form
/// - Navigate to signup screen if they don't have an account
/// - View validation messages and error feedback
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// State class for LoginScreen widget
///
/// Manages:
/// - Form input controllers for email and password
/// - Form validation logic
/// - Login submission process
/// - Navigation to signup screen
class _LoginScreenState extends State<LoginScreen> {
  /// Controller for email text field
  final _emailController = TextEditingController();

  /// Controller for password text field
  final _passwordController = TextEditingController();

  /// Handles the login process
  ///
  /// This method:
  /// - Validates that both email and password fields are filled
  /// - Shows error message if validation fails
  /// - Calls the AuthProvider login method if validation passes
  void _login() {
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

    // Call the AuthProvider login method
    Provider.of<AuthProvider>(
      context,
      listen: false,
    ).login(email, password, context);
  }

  /// Builds the login screen UI
  ///
  /// Creates a form with:
  /// - Email input field
  /// - Password input field (obscured)
  /// - Login button
  /// - Link to signup screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
            // Login button
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            // Navigation link to signup screen
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
