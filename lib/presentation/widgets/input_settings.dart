import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../!helpers/!helpers.dart';
import '../../data/preferences/preferences.dart';
import '../../repository/!repository.dart';

class InputSettings extends StatefulWidget {
  final String label;
  final String? preferenceKey;
  final bool isPassword;
  final bool isNumeric;
  final bool isEditable;
  final String valueNonEditable;
  final bool animate;

  const InputSettings({
    super.key,
    required this.label,
    this.preferenceKey,
    this.isPassword = false,
    required this.isNumeric,
    this.isEditable = true,
    this.valueNonEditable = '',
    this.animate = true,
  });

  @override
  InputSettingsState createState() => InputSettingsState();
}

class InputSettingsState extends State<InputSettings> with TickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation, _scaleAnimation;
  late FocusNode _focusNode;
  late bool obscureText;
  late bool isEditable;
  late String valueNonEditable;
  late IconData iconData;
  bool editError = false;

  @override
  void initState() {
    super.initState();
    _initializeVariables();
    _initializeAnimations();
    getPreferenceValue();
  }

  void _initializeVariables() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    obscureText = widget.isPassword;
    iconData = Icons.visibility;
    isEditable = widget.isEditable;
    valueNonEditable = widget.valueNonEditable;
  }

  void _initializeAnimations() {
    if (widget.animate) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
      );
      _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
      );
      _animationController.forward(from: 0.0);
    } else {
      _opacityAnimation = const AlwaysStoppedAnimation(1.0); // Animación estática
      _scaleAnimation = const AlwaysStoppedAnimation(1.0); // Animación estática
    }
  }

  Future<void> getPreferenceValue() async {
    if (!widget.isEditable) {
      _controller.text = valueNonEditable;
    } else {
      dynamic value = await Preferences.getValue(widget.preferenceKey!);
      _controller.text = value.toString();
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      _animationController.dispose();
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();
    final themeBlocState = context.watch<ThemeBloc>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(appColors),
              _buildInputField(appColors, themeBlocState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(Map<String, dynamic>? appColors) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: appColors?['labelInputColor'],
        ),
      ),
    );
  }

  Widget _buildInputField(Map<String, dynamic>? appColors, ThemeBlocState themeBlocState) {
    return Container(
      decoration: _inputFieldDecoration(appColors, themeBlocState),
      child: TextFormField(
        enabled: isEditable,
        focusNode: _focusNode,
        controller: _controller,
        obscureText: obscureText,
        keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: appColors!['hintInputColor'],
        ),
        decoration: _inputDecoration(appColors),
        cursorColor: appColors['hintInputColor'],
        onFieldSubmitted: _onFieldSubmitted,
        onEditingComplete: _onEditingComplete,
        onTap: _onTap,
      ),
    );
  }

  BoxDecoration _inputFieldDecoration(Map<String, dynamic>? appColors, ThemeBlocState themeBlocState) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          blurStyle: themeBlocState.isDarkTheme ? BlurStyle.inner : BlurStyle.normal,
          color: appColors!['buttonShadowInput']!,
          spreadRadius: 1,
          blurRadius: 1,
          offset: themeBlocState.isDarkTheme ? const Offset(-1, -2) : const Offset(0, 3),
        ),
        if (themeBlocState.isDarkTheme)
          BoxShadow(
            color: appColors['secondShadowDarkMode']!,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(3, 1),
          )
      ],
    );
  }

  InputDecoration _inputDecoration(Map<String, dynamic>? appColors) {
    return InputDecoration(
      prefixIcon: widget.isPassword ? _buildPasswordIcon(appColors) : null,
      hintText: 'Introduzca ${widget.label}',
      hintStyle: TextStyle(color: appColors!['hintInputColor']),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  Widget _buildPasswordIcon(Map<String, dynamic>? appColors) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton(
        icon: Icon(iconData, color: appColors!['iconInputColor']),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
      iconData = obscureText ? Icons.visibility : Icons.visibility_off;
    });
  }

  void _onFieldSubmitted(String newValue) async {
    try {
      if (widget.preferenceKey != null) {
        await Preferences.setValue(
          widget.preferenceKey!,
          widget.preferenceKey == 'port' ? int.parse(newValue.isEmpty ? '0' : newValue) : newValue,
        );
      }
    } catch (e) {
      setState(() {
        editError = true;
      });
    }
  }

  void _onEditingComplete() {
    if (editError) {
      _showSnackBar('Error al actualizar ${widget.label}', Colors.red);
      _controller.text = '';
    } else {
      _showSnackBar('${widget.label} ha sido actualizado correctamente!', Colors.green);
      _focusNode.unfocus();
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _onTap() {
    setState(() {
      obscureText = widget.isPassword;
      iconData = Icons.visibility;
    });
  }
}
