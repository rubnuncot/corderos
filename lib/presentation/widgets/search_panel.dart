import 'package:flutter/material.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({Key? key}) : super(key: key);

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {

  final TextEditingController _controller = TextEditingController();

  final List<String> _valores = [
    "gato", "perro", "casa", "árbol", "coche", "sol", "luna", "mar", "montaña", "libro",
    "computadora", "teléfono", "fútbol", "musica", "arte", "viaje", "avión", "tren", "bicicleta",
    "jardín", "flor", "nube", "viento", "lluvia", "nieve", "café", "té", "leche", "agua",
    "manzana", "banana", "naranja", "fresa", "uva", "limón", "nuez", "almendra", "pan", "queso",
    "jamón", "pollo", "pescado", "arroz", "pasta", "pizza", "helado", "pastel", "galleta", "chocolate"
  ];

  List<String> _coincidencias = [];

  @override
  void initState() {
    super.initState();
    _coincidencias = List.from(_valores);
    _controller.addListener(_filtrarValores);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filtrarValores() {
    setState(() {
      _coincidencias = _controller.text.isEmpty
          ? List.from(_valores)
          : _valores.where((valor) =>
          valor.toLowerCase().contains(_controller.text.toLowerCase())).toList();
    });
  }

  Widget _searchField() {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelText: 'Buscar',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _controller.clear();
            _filtrarValores();
          },
        )
            : null,
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: _coincidencias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_coincidencias[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _searchField(),
          Expanded(child: _listView()),
        ],
      ),
    );
  }
}
