import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../!helpers/!helpers.dart';
import '../../repository/!repository.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size.width * 0.11;
    final themeBloc = context.read<ThemeBloc>();
    final themeBlocState = context.watch<ThemeBloc>().state;
    final appColors = AppColors(context: context).getColors();

    return ZoomTapAnimation(
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.5),
            color: appColors?['themeButtonColor'],
            boxShadow: [
              BoxShadow(
                color: appColors?['buttonShadowInput'],
                spreadRadius: 1,
                blurRadius: 1,
                offset: themeBlocState.isDarkTheme ? const Offset(-2, -1) : const Offset(0, 3),
              ),
              if(themeBlocState.isDarkTheme)
                BoxShadow(
                  color: appColors?['secondShadowDarkMode'],
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: themeBlocState.isDarkTheme ? const Offset(1, 1) : const Offset(0, 3),
                )
            ],
          ),
          child: themeBlocState.isDarkTheme
              ? const Icon(FontAwesomeIcons.solidMoon, color: Colors.deepPurple)
              : const Icon(FontAwesomeIcons.solidSun, color: Colors.deepOrangeAccent),
        ),
      onTap: () {
        themeBloc.changeTheme();
      }
    );
  }
}
