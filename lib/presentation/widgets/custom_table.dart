import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final bool isOpen;
  final List items;
  final int? selected;
  final void Function()? onTap;

  const CustomTable({
    super.key,
    required this.isOpen,
    required this.items,
    this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    int? selectedIndex = selected;

    return Flexible(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isOpen ? MediaQuery.of(context).size.height : 0,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item ${items[index]}'),
              selected: selectedIndex == index,
              onTap: onTap
            );
          },
        ),
      ),
    );
  }
}
