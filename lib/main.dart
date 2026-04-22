import 'package:flutter/material.dart';

void main() {
  runApp(const ReViewApp());
}

class ReViewApp extends StatelessWidget {
  const ReViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re:view',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const Scaffold(),
    );
  }
}
