import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class NewDropDown extends StatefulWidget {
  final String? mapKey;
  final String? labelText;
  final List? values;
  final String? initialValue;

  const NewDropDown({
    super.key,
    this.mapKey,
    this.labelText,
    this.values,
    this.initialValue,
  });

  @override
  State<NewDropDown> createState() => _NewDropDownState();
}

class _NewDropDownState extends State<NewDropDown> {
  late DropDownBloc dropdownBloc;
  late DropDownStateBloc dropdownState;
  List<String>? list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dropdownBloc = context.read<DropDownBloc>();
    dropdownState = context.watch<DropDownBloc>().state;
    list = widget.mapKey == null
        ? widget.values as List<String>?
        : dropdownState.values[widget.mapKey];
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(widget.labelText!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appColors?['labelInputColor'])),
        const SizedBox(height: 8),
        if (list != null && list!.isNotEmpty)
          CustomDropdown<String>(
            hintText: 'Seleccione una opción',
            items: list,
            decoration: CustomDropdownDecoration(
                closedFillColor: appColors?['buttonBackgroundNeuColor'],
                expandedFillColor: appColors?['buttonBackgroundNeuColor'],
                closedShadow: [
                  BoxShadow(
                    color: appColors?['buttonBackgroundNeuGradientColor'],
                    blurRadius: 5,
                    offset: const Offset(-1, 0),
                  ),
                  BoxShadow(
                    color: appColors?['buttonBackgroundNeuGradientSecondColor'],
                    blurRadius: 2,
                    offset: const Offset(3, 1),
                  ),
                ]),
            initialItem:
                list!.contains(dropdownState.selectedValues[widget.mapKey])
                    ? dropdownState.selectedValues[widget.mapKey]
                    : widget.initialValue,
            onChanged: (value) async {
              if (widget.mapKey != null) {
                await dropdownBloc.changeValue(widget.mapKey!, value);
              }
            },
          )
        else
          const Text("No items available", style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
