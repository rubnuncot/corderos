import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../!helpers/!helpers.dart';
import '../../repository/!repository.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;

  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final appColors = AppColors(context: context).getColors();
    final themeBlocState = context.watch<ThemeBloc>().state;

    return ZoomTapAnimation(
      onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: !themeBlocState.isDarkTheme
                ? Border.all(color: appColors!['buttonBorderColor'], width: 3)
              : null,
            boxShadow: [
              if (!themeBlocState.isDarkTheme)
                BoxShadow(
                  color: appColors!['buttonShadowInput'],
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(2, 3),
                ),
              if (themeBlocState.isDarkTheme)
                BoxShadow(
                  color: appColors!['buttonShadowInput'],
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(-2, -1),
                ),

              if (!themeBlocState.isDarkTheme)
                BoxShadow(
                  color: appColors!['secondShadowDarkMode'],
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(-3, -2),
                )
              else

              BoxShadow(
                color: appColors!['secondShadowDarkMode'],
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 2),
              ),
            ]
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), // La curvatura del borde
              gradient: !themeBlocState.isDarkTheme ? LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  appColors['buttonBackgroundNeuGradientColor'], // Color de inicio del gradiente
                  appColors['buttonBackgroundNeuGradientSecondColor'], // Color de fin del gradiente
                ],
              ) : const LinearGradient(colors: [Colors.transparent, Colors.transparent]),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: appColors['buttonBackgroundNeuColor'],
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: appColors['buttonBackgroundColor'], fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        )
    );
  }
}
