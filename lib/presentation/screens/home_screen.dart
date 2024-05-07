import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/widgets/new_drop_down.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  static const String name = "Inicio";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

// @override
// Widget build(BuildContext context) {
//   HomeBloc homeBloc = context.read<HomeBloc>();
//   DropDownBloc dropDownBloc = context.read<DropDownBloc>();
//   NavigatorBloc navigatorBloc = context.read<NavigatorBloc>();
//   final navigatorState = context.watch<NavigatorBloc>().state;
//   final openPanel = context.read<OpenPanelBloc>();
//   const labelStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
//
//   if (homeBlocState.state == 0 ||
//       homeBlocState.state == 200 ||
//       homeBlocState.state == 500) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           if (homeBlocState.state == 220)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//           if (homeBlocState.state == 0 ||
//               homeBlocState.state == 200 ||
//               homeBlocState.state == 500)
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Stack(
//                 children: [
//                   SingleChildScrollView(
//                     // Usa SingleChildScrollView aquí
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const Text('Conductor', style: labelStyle),
//                         const SizedBox(height: 8),
//                         const NewDropDown(mapKey: 'driver'),
//                         const SizedBox(height: 20),
//                         const Text('Matrícula', style: labelStyle),
//                         const SizedBox(height: 8),
//                         const NewDropDown(mapKey: 'vehicle_registration'),
//                         const SizedBox(height: 20),
//                         CustomButton(
//                           text: 'Cargar',
//                           onPressed: () async {
//                             navigatorBloc.push(
//                                 const BurdenScreen(),
//                                 1,
//                                 BurdenScreen.name,
//                                 navigatorState.index,
//                                 navigatorState.name,
//                                 navigatorState.screen);
//                           },
//                           textColor: Theme.of(context).primaryColor,
//                         ),
//                         const SizedBox(height: 20),
//                         CustomButton(
//                           text: 'Descargar',
//                           onPressed: () {
//                             openPanel.openPanel();
//                           },
//                           textColor: Colors.indigoAccent,
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomButton(
//                                 text: 'Enviar',
//                                 onPressed: () async {
//                                   await homeBloc.changeState(220);
//                                   await homeBloc.sendFiles();
//                                   await homeBloc.changeState(200);
//                                 },
//                                 textColor: Colors.orangeAccent,
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Expanded(
//                               child: CustomButton(
//                                 text: 'Recibir',
//                                 onPressed: () async {
//                                   await homeBloc.changeState(220);
//                                   await homeBloc.getFtpData();
//                                   await dropDownBloc.getData();
//                                   await homeBloc.changeState(200);
//                                 },
//                                 textColor: Colors.lightGreen,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Panel(size: MediaQuery.of(context).size)
//                 ],
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await homeBloc.changeState(220);
//           await homeBloc.changeState(200);
//         },
//         child: const Icon(Icons.refresh),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   } else {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
}
