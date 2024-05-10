import 'package:corderos_app/presentation/widgets/tickets_list.dart';
import 'package:flutter/material.dart';

class TicketSelectionScreen extends StatelessWidget {
  static const String name = "Tickets";
  const TicketSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TicketList(),
    );
  }
}
