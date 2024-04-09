import 'package:flutter/material.dart';

import '../widgets/search_panel.dart';

class SettingsScreen extends StatelessWidget {
  static const String name = "Ajustes";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SearchPanel());
  }
}
