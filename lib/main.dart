import 'package:flutter/material.dart';

void main() {
  runApp(const CreativeStepperApp());
}

class CreativeStepperApp extends StatelessWidget {
  const CreativeStepperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE0E7FF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const Scaffold(),
    );
  }
}
