import 'dart:async';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/widgets/new_drop_down.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablaTicket extends StatefulWidget {
  const TablaTicket({Key? key}) : super(key: key);

  @override
  State<TablaTicket> createState() => _TablaTicketState();
}

class _TablaTicketState extends State<TablaTicket> {
  DatabaseBloc? databaseBloc;
  bool isLoading = false;
  StreamSubscription? databaseBlocSubscription;

  @override
  void initState() {
    super.initState();
    databaseBloc = context.read<DatabaseBloc>();
    databaseBlocSubscription = databaseBloc!.stream.listen((state) {
      setState(() {
        isLoading = state is DatabaseLoading;
        if (state is DatabaseSuccess) {
          LogHelper.logger.d(state.message);
          LogHelper.logger.f(state.data.toString());
        } else if (state is DatabaseError) {
          LogHelper.logger.d(state.message);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //! Fecha con formato europeo
    String formattedDate =
        "${DateTime
        .now()
        .day
        .toString()
        .padLeft(2, '0')}/${DateTime
        .now()
        .month
        .toString()
        .padLeft(2, '0')}/${DateTime
        .now()
        .year}";
    final appColors = AppColors(context: context).getColors();

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                      child: InputSettings(
                        label: 'Fecha',
                        isNumeric: false,
                        isEditable: false,
                        valueNonEditable: formattedDate,
                      )),
                  const SizedBox(width: 16.0),
                  const Expanded(child: NewDropDown(listIndex: 1))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(child: NewDropDown(listIndex: 1)),
                  SizedBox(width: 16.0),
                  Expanded(child: NewDropDown(listIndex: 1))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(child: NewDropDown(listIndex: 1)),
                  SizedBox(width: 16.0),
                  Expanded(child: NewDropDown(listIndex: 1))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
