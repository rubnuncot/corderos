import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class SearchableDropdown extends StatefulWidget {
  final String dropdownValue;
  final String titleText;
  final Function(String) onItemSelected;  // Añadir la función de retorno

  const SearchableDropdown({
    super.key,
    required this.dropdownValue,
    required this.titleText,
    required this.onItemSelected,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  @override
  Widget build(BuildContext context) {
    SearchableDropdownBloc searchableDropdown = context.read<SearchableDropdownBloc>();
    SearchableDropdownState state = context.watch<SearchableDropdownBloc>().state;
    DropDownBloc dropDownBloc = context.read<DropDownBloc>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: state.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Quits focus from any focused element
              FocusScope.of(context).unfocus();
              searchableDropdown.closePanel();
            },
          ),
        ),
        body: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: widget.titleText,
              ),
              onChanged: (value) {
                if (value == '') {
                  searchableDropdown.clear();
                } else {
                  searchableDropdown.search(value);
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      state.items[index],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    onTap: () async {
                      await dropDownBloc.changeValue(widget.dropdownValue, state.items[index]);
                      searchableDropdown.closePanel();
                      widget.onItemSelected(state.items[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
