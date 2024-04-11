import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  static const String name = "Inicio";

  @override
  Widget build(BuildContext context) {
    final navigator = context.read<NavigatorBloc>();
    final openPanel = context.read<OpenPanelBloc>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDropdown(
                  hint: 'Seleccionar nombre',
                  items: ['Cuco', 'Paco', 'Juli'],
                  onChanged: (String newValue) {
                    // TODO: Agregar lógica de cambio
                  },
                ),
                const SizedBox(height: 20),
                CustomDropdown(
                  hint: 'Seleccionar matrícula',
                  items: ['Matrícula 1', 'Matrícula 2', 'Matrícula 3'],
                  onChanged: (String newValue) {
                    // TODO: Agregar lógica de cambio
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Cargar',
                  onPressed: () {
                    navigator.push(const BurdenScreen(), 1, 'Carga');
                  },
                  textColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Descargar',
                  onPressed: () {
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
                          // TODO: Agregar lógica del tercer botón
                        },
                        textColor: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        text: 'Recibir',
                        onPressed: () {
                          // TODO: Agregar lógica del cuarto botón
                        },
                        textColor: Colors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Panel(size: MediaQuery.of(context).size)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Agregar lógica del botón flotante
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
