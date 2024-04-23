import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/widgets/new_drop_down.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_simple_dao_backend/database/database/dao_connector.dart';

class HomeScreen extends StatelessWidget {
  static const String name = "Inicio";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final openPanel = context.read<OpenPanelBloc>();
    const labelStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            SingleChildScrollView( // Usa SingleChildScrollView aquí
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Conductor', style: labelStyle),
                  const SizedBox(height: 8),
                  const NewDropDown(listIndex: 1),
                  const SizedBox(height: 20),
                  const Text('Matrícula', style: labelStyle),
                  const SizedBox(height: 8),
                  const NewDropDown(listIndex: 2),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Cargar',
                    onPressed: () async {
                      //navigator.push(const BurdenScreen(), 1, 'Carga');
                      Dao dao = const Dao();

                      ClientDeliveryNote clientDeliveryNote1 = ClientDeliveryNote.all(id: 5, date: DateTime.now(), clientId: 101, slaughterhouseId: 201, idProduct: 301);
                      ClientDeliveryNote clientDeliveryNote2 = ClientDeliveryNote.all(id: 6,date: DateTime.now().subtract(const Duration(days: 2)),clientId: 102,slaughterhouseId: 202,idProduct: 302,);
                      ClientDeliveryNote clientDeliveryNote3 = ClientDeliveryNote.all(id: 7, date: DateTime.now().add(Duration(days: 5)), clientId: 103, slaughterhouseId: 203, idProduct: 303,);
                      ClientDeliveryNote clientDeliveryNote4 = ClientDeliveryNote.all(id: 8, date: DateTime.now().subtract(Duration(days: 1)), clientId: 104, slaughterhouseId: 204, idProduct: 304,);
                      DeliveryTicket deliveryTicket1 = DeliveryTicket.all(id: 5, deliveryTicket: 'DT20240422-001', date: DateTime.now(), idDriver: 101, idVehicleRegistration: 201, idSlaughterhouse: 301, idRancher: 401, idProduct: 501);
                      DeliveryTicket deliveryTicket2 = DeliveryTicket.all(id: 6, deliveryTicket: 'DT20240421-002', date: DateTime.now().subtract(Duration(days: 2)), idDriver: 102, idVehicleRegistration: 202, idSlaughterhouse: 302, idRancher: 402, idProduct: 502);
                      DeliveryTicket deliveryTicket3 = DeliveryTicket.all(id: 7, deliveryTicket: 'DT20240427-003', date: DateTime.now().add(Duration(days: 5)), idDriver: 103, idVehicleRegistration: 203, idSlaughterhouse: 303, idRancher: 403, idProduct: 503);
                      DeliveryTicket deliveryTicket4 = DeliveryTicket.all(id: 8, deliveryTicket: 'DT20240423-004', date: DateTime.now().subtract(Duration(days: 1)), idDriver: 104, idVehicleRegistration: 204, idSlaughterhouse: 304, idRancher: 404, idProduct: 504);
                      ProductDeliveryNote productDeliveryNote1 = ProductDeliveryNote.all(id: 5, idDeliveryNote: 5, idProduct: 301, nameClassification: 'Class A', units: 10, kilograms: 25.5);
                      ProductDeliveryNote productDeliveryNote2 = ProductDeliveryNote.all(id: 6, idDeliveryNote: 6, idProduct: 302, nameClassification: 'Class B', units: 15, kilograms: 30.2);
                      ProductDeliveryNote productDeliveryNote3 = ProductDeliveryNote.all(id: 7, idDeliveryNote: 7, idProduct: 303, nameClassification: 'Class C', units: 20, kilograms: 40.0);
                      ProductDeliveryNote productDeliveryNote4 = ProductDeliveryNote.all(id: 8, idDeliveryNote: 8, idProduct: 304, nameClassification: 'Class A', units: 12, kilograms: 28.8);
                      ProductTicket productTicket1 = ProductTicket.all(id: 5, idTicket: 5, idProduct: 501, nameClassification: 'Class A', numAnimals: 10, weight: 25.5, idPerformance: 301, losses: 2);
                      ProductTicket productTicket2 = ProductTicket.all(id: 6, idTicket: 6, idProduct: 502, nameClassification: 'Class B', numAnimals: 15, weight: 30.2, idPerformance: 302, losses: 1);
                      ProductTicket productTicket3 = ProductTicket.all(id: 7, idTicket: 7, idProduct: 503, nameClassification: 'Class C', numAnimals: 20, weight: 40.0, idPerformance: 303, losses: 3);
                      ProductTicket productTicket4 = ProductTicket.all(id: 8, idTicket: 8, idProduct: 504, nameClassification: 'Class A', numAnimals: 12, weight: 28.8, idPerformance: 304, losses: 0);

                      List list = [clientDeliveryNote1, clientDeliveryNote2, clientDeliveryNote3, clientDeliveryNote4, deliveryTicket1, deliveryTicket2, deliveryTicket3, deliveryTicket4, productDeliveryNote1, productDeliveryNote2, productDeliveryNote3, productDeliveryNote4, productTicket1, productTicket2, productTicket3, productTicket4];

                      await dao.batchInsertOrUpdate(objects: list);
                      FtpDataTransfer ftpDataTransfer = FtpDataTransfer();
                      await ftpDataTransfer.sendFilesToFTP();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Descargar',
                    onPressed: () {
                      openPanel.openPanel();
                    },
                    textColor: Colors.indigoAccent,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Enviar',
                          onPressed: () {
                            // TODO: Agregar lógica del tercer botón
                          },
                          textColor: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomButton(
                          text: 'Recibir',
                          onPressed: () {
                            // TODO: Agregar lógica del cuarto botón
                          },
                          textColor: Colors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Panel(size: MediaQuery.of(context).size)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Agregar lógica del botón flotante
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
