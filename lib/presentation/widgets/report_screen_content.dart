import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../!helpers/app_theme.dart';

class ReportScreenContent extends StatelessWidget {
  const ReportScreenContent({super.key});

  final double fontSize = 18;
  final FontWeight bold = FontWeight.bold;
  final double iconSize = 25;

  List<Map<String, dynamic>> getRowValues() {
    return [
      {"icon": FontAwesomeIcons.calendarDays, "text": "Fecha"},
      {"icon": Icons.location_on, "text": "Matadero Destino"},
      {"icon": Icons.widgets, "text": "Unidades Totales"},
      {"icon": Icons.person, "text": "Ganadero"},
    ];
  }

  List<Map<String, dynamic>> getRealValues(ReportState reportState) {
    return [
      {'text': reportState.date},
      {'text': reportState.slaughterhouseDestination},
      {'text': reportState.totalUnits},
      {'text': reportState.rancher}
    ];
  }

  @override
  Widget build(BuildContext context) {
    final reportState = context.watch<ReportBloc>().state;
    final appColors = AppColors(context: context).getColors();
    List<Map<String, dynamic>> rowValues = getRowValues();
    List<Map<String, dynamic>> realValues = getRealValues(reportState);

    Widget buildRow(Map<String, dynamic> rowData, Map<String, dynamic> realData) {
      return Column(
        children: [
          Row(
            children: [
              Icon(rowData["icon"],
                  size: iconSize, color: appColors!['iconCardColor']),
              const SizedBox(width: 10.0),
              Text(rowData["text"],
                  style: TextStyle(fontSize: fontSize, fontWeight: bold)),
              const SizedBox(width: 10.0),
            ],
          ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.all(18.0)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(realData["text"].toString(),
                    style: TextStyle(fontSize: fontSize), overflow: TextOverflow.ellipsis, maxLines: 2,),
              ),
            ],
          )
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: appColors!['headerBackgroundColor'],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Matrícula: ${reportState.vehicleRegistration}",
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: appColors['fontHeaderColor']),
                ),
                Text(
                  "Nombre: ${reportState.driver}",
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: appColors['fontHeaderColor']),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            elevation: 7.0,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowValues.asMap().entries.map((entry) {
                  final rowData = entry.value;
                  final realData = realValues[entry.key];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (realData.isNotEmpty) buildRow(rowData, realData),
                      const SizedBox(height: 20.0),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
