import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class NewDropDown extends StatelessWidget {
  final int listIndex;
  final String? labelText;

  const NewDropDown({
    super.key,
    required this.listIndex,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();
    final dropdownBloc = context.read<DropDownBloc>();
    final dropdownState = context.watch<DropDownBloc>().state;

    final list = dropdownBloc.values[listIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(labelText != null)
          Text(labelText!, style: TextStyle(fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
              appColors?['labelInputColor'])),
        const SizedBox(height: 8),
        CustomDropdown<String>(
          hintText: 'Select job role',
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
          initialItem: list![dropdownState.index],
          onChanged: (value) async {
            await dropdownBloc.changeValue(listIndex, value);
          },
        ),
      ],
    );
  }
}
