import 'package:corderos_app/presentation/widgets/!widgets.dart';
import 'package:corderos_app/presentation/widgets/input_settings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String name = "Ajustes";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Map<String, String> settings = {
      'Host': 'host',
      'Puerto': 'port',
      'Nombre de Usuario': 'username',
      'Contraseña': 'password',
      'Ruta FTP': 'path',
      'Ruta Envío FTP': 'sendPath'
    };

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: settings.length,
                    itemBuilder: (context, index) {
                      return InputSettings(
                        isNumeric: settings.values.toList()[index] == 'host'
                        || settings.values.toList()[index] == 'port',
                        label: settings.keys.toList()[index],
                        preferenceKey: settings.values.toList()[index],
                        isPassword: settings.values.toList()[index] == 'password',
                        isEditable: true,
                      );
                    },
                  )
                )
            ),
          ),
          const Text('Version: 1.2.2')
        ],
      ),
    );
  }
}
