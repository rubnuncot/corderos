import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../!presentation.dart';
import '../../repository/!repository.dart';

class Layout extends StatelessWidget {
  final Widget content;
  final String text;

  const Layout({
    super.key,
    @required required this.content,
    @required required this.text,
  });

  @override
  Widget build(BuildContext context) {
      final Map<int, Widget> screens = {
      0: const HomeScreen(),
      1: const BurdenScreen(),
      2: const TicketSelectionScreen(),
      3: const SettingsScreen(),
      4: const ReportScreen(),
    };

    final Map<int, String> names = {
      0: HomeScreen.name,
      1: BurdenScreen.name,
      2: TicketSelectionScreen.name,
      3: SettingsScreen.name,
      4: ReportScreen.name,
    };

    final navigator = context.read<NavigatorBloc>();
    final reportBloc = context.read<ReportBloc>();
    final navigatorState = context.watch<NavigatorBloc>().state;
    final appThemes = AppColors(context: context).getColors();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            text,
            style: TextStyle(color: appThemes?['appBarTitle']),
          ),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              navigator.goBack();
            },
          ),
          centerTitle: true,
          backgroundColor: appThemes?['appBarBackground'],
          actions: const [ThemeButton()],
        ),
        body: content,
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: navigatorState.index,
          backgroundColor: appThemes?['buttonNavigationBackground'],
          selectedItemColor: appThemes?['selectedItemColor'],
          unselectedItemColor: appThemes?['unselectedItemColor'],
          onTap: (index) async {
            if(names[index] == ReportScreen.name){
              await reportBloc.getDatabaseValues();
            }
            navigator.push(
                screens[index]!,
                index,
                names[index]!,
                navigatorState.index,
                navigatorState.lastName,
                navigatorState.screen);
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.houseUser),
              title: const Text('Inicio'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.truck),
              title: const Text('Carga'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.ticket),
              title: const Text('Tickets'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.gear),
              title: const Text('Ajustes'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.flagCheckered),
              title: const Text('Informe'),
            ),
          ],
        ));
  }
}
