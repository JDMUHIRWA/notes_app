// Main entry point of the Notes App
// This file contains the app initialization and root widget setup

// Import Flutter Material package for UI components
import 'package:flutter/material.dart';
// Import Firebase Core for Firebase initialization
import 'package:firebase_core/firebase_core.dart';
// Import Provider package for state management
import 'package:provider/provider.dart';

// Import custom providers for state management
import 'provider/auth_provider.dart';
import 'provider/note_provider.dart';
// Import screen widgets
import 'presentation/auth/login_screen.dart';
import 'presentation/notes/notes_screen.dart';

/// Main entry point of the application
///
/// This function:
/// - Ensures Flutter widgets are initialized
/// - Initializes Firebase services
/// - Runs the main app widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter widgets are initialized
  await Firebase.initializeApp(); // Initialize Firebase services
  runApp(const MyApp()); // Run the main app widget
}

/// Root widget of the application
///
/// This widget sets up:
/// - Provider pattern for state management
/// - Material app configuration
/// - Theme settings
/// - Initial navigation logic
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Set up providers for dependency injection and state management
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ), // Authentication state management
        ChangeNotifierProvider(
          create: (_) => NoteProvider(), // Notes state management
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hide debug banner
        title: 'Notes App',
        theme: ThemeData(primarySwatch: Colors.indigo), // App theme
        home: const RootWidget(), // Initial screen
      ),
    );
  }
}

/// Root navigation widget that determines which screen to show
///
/// This widget:
/// - Listens to authentication state changes
/// - Shows loading indicator during authentication check
/// - Navigates to appropriate screen based on authentication status
class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to authentication state changes
    final authProvider = Provider.of<AuthProvider>(context);

    // Show loading indicator while checking authentication state
    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Navigate to notes screen if user is authenticated
    else if (authProvider.user != null) {
      return const NotesScreen();
    }
    // Navigate to login screen if user is not authenticated
    else {
      return const LoginScreen();
    }
  }
}
