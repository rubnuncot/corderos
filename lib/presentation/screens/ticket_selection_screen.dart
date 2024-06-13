import 'package:flutter/material.dart';

import '../!presentation.dart';
import '../../!helpers/!helpers.dart';

class TicketSelectionScreen extends StatefulWidget {
  static const String name = "Tickets";

  const TicketSelectionScreen({super.key});

  @override
  TicketSelectionScreenState createState() => TicketSelectionScreenState();
}

class TicketSelectionScreenState extends State<TicketSelectionScreen> {
  int _selectedScreen = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeomorphicButton(
              onPressed: () => _selectScreen(0),
              text: 'Tickets',
              isSelected: _selectedScreen == 0,
            ),
            NeomorphicButton(
              onPressed: () => _selectScreen(1),
              text: 'Enviados',
              isSelected: _selectedScreen == 1,
            ),
          ],
        ),
        Expanded(
          child: _selectedScreen == 0 ? const TicketsList() : const TicketListClient(),
        ),
      ],
    );
  }
}

class NeomorphicButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool isSelected;

  const NeomorphicButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();
    final size = MediaQuery.of(context).size.width * 0.3;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? appColors!['labelInputColor'] : appColors!['themeButtonColor'],
          boxShadow: [
            BoxShadow(
              color: isSelected ? appColors['buttonShadowInput'] : appColors['buttonShadowInput'],
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: appColors['secondShadowDarkMode'],
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? appColors['textButtonColor'] : appColors['labelInputColor'],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Screen2Content extends StatelessWidget {
  const Screen2Content({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Contenido de la Pantalla 2'),
    );
  }
}
