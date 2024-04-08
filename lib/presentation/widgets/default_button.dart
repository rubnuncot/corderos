import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final void Function()? onPressed;
  const DefaultButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'Default Button',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
