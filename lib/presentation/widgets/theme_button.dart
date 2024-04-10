import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../repository/!repository.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size.width * 0.11;
    final themeBloc = context.read<ThemeBloc>();
    final themeBlocState = context.watch<ThemeBloc>().state;

    return ZoomTapAnimation(
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 3),
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
