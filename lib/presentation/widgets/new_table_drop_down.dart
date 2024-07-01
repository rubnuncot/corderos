import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class NewTableDropDown extends StatelessWidget {
  final String mapKey;

  const NewTableDropDown({
    super.key,
    required this.mapKey,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();
    final dropdownBloc = context.read<DropDownBloc>();
    final dropdownState = context.watch<DropDownBloc>().state;

    final list = dropdownBloc.values[mapKey];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight * 0.2,
          width: screenWidth * 0.9,
          child: CustomDropdown<String>(
            items: list,
            decoration: CustomDropdownDecoration(
              closedFillColor: appColors!['buttonBackgroundNeuColor'],
              expandedFillColor: appColors['buttonBackgroundNeuColor'],
            ),
            initialItem: dropdownState.selectedValues[mapKey],
            onChanged: (value) async {
              await dropdownBloc.changeValue(mapKey, value!);
            },
          ),
        ),
      ],
    );
  }
}
