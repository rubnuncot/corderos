import 'package:flutter/material.dart';
import '../../data/preferences/preferences.dart';

class InputSettings extends StatefulWidget {
  final String label;
  final String preferenceKey;
  final bool isPassword;

  const InputSettings({super.key, required this.label, required this.preferenceKey, this.isPassword = false});

  @override
  State<InputSettings> createState() => _InputSettingsState();
}

class _InputSettingsState extends State<InputSettings> with TickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation, _scaleAnimation;
  late FocusNode _focusNode;
  late bool obscureText;
  late IconData iconData;
  bool editError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    _animationController.forward(from: 0.0);
    obscureText = widget.isPassword;
    iconData = Icons.visibility;
    getPreferenceValue();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  getPreferenceValue() async {
    dynamic value = await Preferences.getValue(widget.preferenceKey);
    _controller.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                child: Text(
                  widget.label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple[900]), // Granate/Rojo Oscuro
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: _controller,
                  obscureText: obscureText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: widget.isPassword ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: IconButton(
                            icon: Icon(iconData, color: Colors.deepPurple[900]),
                            color: Colors.deepPurple[900],
                            onPressed: () {
                              obscureText = !obscureText;
                              setState(() {
                                iconData = obscureText? Icons.visibility : Icons.visibility_off;
                              });
                          }
                        ),
                    ) : null,
                    hintText: 'Introduzca ${widget.label}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),

                  onChanged: (String value) async {
                    try {
                      await Preferences.setValue(widget.preferenceKey, value);
                    } catch (e) {
                      editError = true;
                    }
                  },

                  onEditingComplete: () {
                    if (editError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al actualizar ${widget.label}', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                      );
                      _controller.text = '';
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.label} ha sido actualizado correctamente!', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                      );
                      _focusNode.unfocus();
                    }
                  },
                  onTap: () {
                    obscureText = widget.isPassword;
                    setState(() {
                      iconData = Icons.visibility;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
