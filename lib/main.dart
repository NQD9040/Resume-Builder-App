import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/screens/home_screen.dart';
import 'package:flutter_quill/flutter_quill.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
