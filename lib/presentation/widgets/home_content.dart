import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:corderos_app/repository/blocs/!blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../!presentation.dart';
import '../../repository/!repository.dart';
import 'new_drop_down.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  HomeBloc? homeBloc;
  OpenPanelBloc? openPanel;
  DropDownBloc? dropDownBloc;
  NavigatorBloc? navigatorBloc;
  dynamic navigatorState = '';

  StreamSubscription? _subscription;

  final labelStyle = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  bool loading = false;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    openPanel = context.read<OpenPanelBloc>();
    dropDownBloc = context.read<DropDownBloc>();
    navigatorBloc = context.read<NavigatorBloc>();

    _subscription = homeBloc!.stream.listen((event) {
      if (event is HomeSuccess) {
        setState(() {
          loading = false;
        });
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Proceso terminado...",
            contentType: ContentType.success,
            message: event.message,
          ),
        );
      } else if(event is HomeError) {
        setState(() {
          loading = false;
        });
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "¡Error!",
            contentType: ContentType.failure,
            message: event.message,
          ),
        );
      } else {
        setState(() {
          loading = true;
        });
      }
    });
  }


  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!loading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    // Usa SingleChildScrollView aquí
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Conductor', style: labelStyle),
                        const SizedBox(height: 8),
                        const NewDropDown(mapKey: 'driver'),
                        const SizedBox(height: 20),
                        Text('Matrícula', style: labelStyle),
                        const SizedBox(height: 8),
                        const NewDropDown(mapKey: 'vehicle_registration'),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Cargar',
                          onPressed: () async {
                            navigatorState = context.watch<NavigatorBloc>().state;
                            navigatorBloc!.push(
                                const BurdenScreen(),
                                1,
                                BurdenScreen.name,
                                navigatorState.index,
                                navigatorState.name,
                                navigatorState.screen);
                          },
                          textColor: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Descargar',
                          onPressed: () {
                            openPanel!.openPanel();
                          },
                          textColor: Colors.indigoAccent,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Enviar',
                                onPressed: () async {
                                  homeBloc!.add(SendFiles());
                                },
                                textColor: Colors.orangeAccent,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: CustomButton(
                                text: 'Recibir',
                                onPressed: () async {
                                  homeBloc!.add(GetFtpData(dropDownBloc: dropDownBloc!));
                                },
                                textColor: Colors.lightGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Panel(size: MediaQuery.of(context).size)
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //TODO: ACTUALIZAR DATOS.
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
