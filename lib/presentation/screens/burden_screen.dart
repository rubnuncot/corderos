import 'package:corderos_app/presentation/widgets/!widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BurdenScreen extends StatelessWidget {
  static const String name = "Carga";

  const BurdenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TableTicket(),
    );
  }
}
