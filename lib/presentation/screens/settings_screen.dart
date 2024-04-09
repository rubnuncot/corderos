import 'package:corderos_app/presentation/widgets/!widgets.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String name = "Ajustes";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: TablaTicket());
  }
}
