import 'package:corderos_app/presentation/!presentation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String name = "Inicio";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeContent();
  }
}
