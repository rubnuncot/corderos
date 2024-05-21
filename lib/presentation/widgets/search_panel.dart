import 'package:flutter/material.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key});

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {

  final TextEditingController _controller = TextEditingController();

  final List<String> _values = [
    "gato", "perro", "casa", "árbol", "coche", "sol", "luna", "mar", "montaña", "libro",
    "computadora", "teléfono", "fútbol", "musica", "arte", "viaje", "avión", "tren", "bicicleta",
    "jardín", "flor", "nube", "viento", "lluvia", "nieve", "café", "té", "leche", "agua",
    "manzana", "banana", "naranja", "fresa", "uva", "limón", "nuez", "almendra", "pan", "queso",
    "jamón", "pollo", "pescado", "arroz", "pasta", "pizza", "helado", "pastel", "galleta", "chocolate"
  ];

  List<String> _coincidences = [];

  @override
  void initState() {
    super.initState();
    _coincidences = List.from(_values);
    _controller.addListener(_filterValues);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterValues() {
    setState(() {
      _coincidences = _controller.text.isEmpty
          ? List.from(_values)
          : _values.where((valor) =>
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
            _filterValues();
          },
        )
            : null,
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: _coincidences.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_coincidences[index]),
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
