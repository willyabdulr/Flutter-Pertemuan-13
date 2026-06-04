import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:latihan1/auth/auth_page.dart';
import 'package:latihan1/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
