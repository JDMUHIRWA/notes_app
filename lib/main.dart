import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'provider/auth_provider.dart';
import 'provider/note_provider.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/notes/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => NoteProvider(),
        ), // ✅ <-- Add this!
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const RootWidget(),
      ),
    );
  }
}

class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (authProvider.user != null) {
      return const NotesScreen();
    } else {
      return const LoginScreen();
    }
  }
}
