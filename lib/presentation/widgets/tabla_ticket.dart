import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TablaTicket extends StatefulWidget {
  const TablaTicket({Key? key}) : super(key: key);

  @override
  State<TablaTicket> createState() => _TablaTicketState();
}

class _TablaTicketState extends State<TablaTicket> {

  final DatabaseRepository db = DatabaseRepository();
  final List<FilaTabla> filas = [];

  @override
  void initState() {
    super.initState();
    filas.add(FilaTabla(
      numeroCorderos: 0, //
      clase: '', //
      kgs: 0.0,
      rendimiento: 0.0,
      color: '',
    ));
  }

  void addFila() {
    setState(() {
      filas.add(FilaTabla());
    });
  }

  void removeFila(int index) {
    setState(() {
      filas.removeAt(index);
    });
  }

  Future<void> editValue(String title, dynamic currentValue, Function(dynamic) onSubmitted, {bool isDropdown = false}) async {
    if (!isDropdown) {
      TextEditingController _controller = TextEditingController(text: currentValue.toString());
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar $title'),
            content: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(hintText: title),
              onSubmitted: (_) {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () {
                  onSubmitted(_controller.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      double selectedValue = currentValue.toDouble();
      return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Editar $title'),
                content: DropdownButton<double>(
                  value: selectedValue,
                  items: List.generate(21, (index) {
                    return DropdownMenuItem<double>(
                      value: index.toDouble(),
                      child: Text(index.toString()),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedValue = value); // Actualizamos el estado localmente
                    }
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Guardar'),
                    onPressed: () {
                      onSubmitted(selectedValue); // Usamos el valor actualizado
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.blue[200];
                    }
                    return Colors.green[200];
                  }),
                  columns: const [
                    DataColumn(label: Text('Nº Corderos', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Clase', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Kgs.', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Rendimiento', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Color', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List<DataRow>.generate(
                    filas.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text(filas[index].numeroCorderos.toString()),
                              onTap: () => editValue('Nº Corderos', filas[index].numeroCorderos, (newValue) {
                                setState(() => filas[index].numeroCorderos = int.tryParse(newValue) ?? filas[index].numeroCorderos);
                              }),
                            ),
                            DataCell(
                              Text(filas[index].clase),
                              onTap: () => editValue('Clase', filas[index].clase, (newValue) {
                                setState(() => filas[index].clase = newValue);
                              }),
                            ),
                            DataCell(
                              Text(filas[index].kgs.toString()),
                              onTap: () => editValue('Kgs.', filas[index].kgs, (newValue) {
                                setState(() => filas[index].kgs = double.tryParse(newValue) ?? filas[index].kgs);
                              }),
                            ),
                            DataCell(
                              Text(filas[index].rendimiento.toString()),
                              onTap: () => editValue('Rendimiento', filas[index].rendimiento, (newValue) {
                                setState(() => filas[index].rendimiento = newValue);
                              }, isDropdown: true),
                            ),
                            DataCell(
                              Text(filas[index].color),
                              onTap: () => editValue('Color', filas[index].color, (newValue) {
                                setState(() => filas[index].color = newValue);
                              }),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(FontAwesomeIcons.trashCan, color: Colors.red),
                                onPressed: () => removeFila(index),
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addFila,
        backgroundColor:  Theme.of(context).primaryColor,
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }

}

class FilaTabla {
  int numeroCorderos;
  String clase;
  double kgs;
  double rendimiento;
  String color;

  FilaTabla({
    this.numeroCorderos = 0,
    this.clase = '',
    this.kgs = 0.0,
    this.rendimiento = 0.0,
    this.color = '',
  });
}