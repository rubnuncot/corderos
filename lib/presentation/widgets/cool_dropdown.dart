import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final void Function(String)? onChanged;

  const CustomDropdown({
    required this.hint,
    required this.items,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  late String selectedValue;
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.hint;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.6),
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedValue,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
                RotationTransition(
                  turns: Tween<double>(begin: 0, end: 0.5).animate(_animationController),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedOpacity(
          opacity: _isExpanded ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: SizeTransition(
            sizeFactor: _animationController.drive(Tween(begin: 0, end: 1)),
            axisAlignment: -1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.6),
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: widget.items.map((item) {
                  return InkWell(
                    onTap: () => _handleSelection(item),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleDropdown() {
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _animationController.forward() : _animationController.reverse();
  }

  void _handleSelection(String item) {
    setState(() {
      selectedValue = item;
      _isExpanded = false;
    });
    _animationController.reverse();
    widget.onChanged?.call(item);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
