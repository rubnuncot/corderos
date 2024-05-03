import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/widgets/new_drop_down.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  static const String name = "Inicio";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = context.read<HomeBloc>();
    HomeBlocState homeBlocState = context.watch<HomeBloc>().state;
    DropDownBloc dropDownBloc = context.read<DropDownBloc>();
    final openPanel = context.read<OpenPanelBloc>();
    const labelStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

    if (homeBlocState.state == 0
        || homeBlocState.state == 200
        || homeBlocState.state == 500
    ) {
      return Scaffold(
        body: Stack(
          children: [
            if(homeBlocState.state == 220)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if(homeBlocState.state == 0
                || homeBlocState.state == 200
                || homeBlocState.state == 500)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      // Usa SingleChildScrollView aquí
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Conductor', style: labelStyle),
                          const SizedBox(height: 8),
                          const NewDropDown(mapKey: 'driver'),
                          const SizedBox(height: 20),
                          const Text('Matrícula', style: labelStyle),
                          const SizedBox(height: 8),
                          const NewDropDown(mapKey: 'vehicle_registration'),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Cargar',
                            onPressed: () async {
                              //TODO: Método cargar
                            },
                            textColor: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Descargar',
                            onPressed: () {
                              //TODO: Método descargar dentro del panel
                              openPanel.openPanel();
                            },
                            textColor: Colors.indigoAccent,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Enviar',
                                  onPressed: () {
                                    homeBloc.sendFiles();
                                  },
                                  textColor: Colors.orangeAccent,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CustomButton(
                                  text: 'Recibir',
                                  onPressed: () async {
                                    await homeBloc.getFtpData();
                                    await dropDownBloc.getData();
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
          onPressed: () {
            // TODO: Agregar lógica del botón flotante
          },
          child: const Icon(Icons.refresh),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
