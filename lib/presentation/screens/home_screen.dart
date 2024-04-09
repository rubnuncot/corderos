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
                ActionButton(
                  text: 'Cargar',
                  onPressed: () {
                    navigator.push(const BurdenScreen(), 1, 'Carga');
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                ActionButton(
                  text: 'Descargar',
                  onPressed: () {
                    openPanel.openPanel();
                  },
                  backgroundColor: Colors.indigoAccent,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: 'Enviar',
                        onPressed: () {
                          // TODO: Agregar lógica del tercer botón
                        },
                        backgroundColor: Colors.orangeAccent,
                        textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ActionButton(
                        text: 'Recibir',
                        onPressed: () {
                          // TODO: Agregar lógica del cuarto botón
                        },
                        backgroundColor: Colors.lightGreen,
                        textColor: Colors.white,
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
