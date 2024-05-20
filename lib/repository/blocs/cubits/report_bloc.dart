import 'package:bloc/bloc.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

class ReportBloc extends Cubit<ReportState> {
  ReportBloc() : super(ReportState());

  Map<int, String> preferencesKeys = {
    1: 'vehicle_registration',
    2: 'name',
  };

  Map<String, String> databaseValues = {
    'slaughterhouseDestination': '',
    'totalUnits': '',
    'rancher': '',
    'driver': '',
    'vehicle_registration': '',
  };

  /*
   ! 1. Recorre las preferencias y almacena los valores en una variable de tipo
   ! string aquellos que coincidan con los entries del mapa.

   ! 2. Si el valor no es nulo, en caso de que sea:
   ! - vehicleRegistration --> database['vehicle_registration'] = value
   ! - name --> database['driver'] = value
   ! Con esto lo que hacemos es almacenar en la entry de cada key el valor
   ! recogida de las preferencias.
   */
  Future<void> _getDriverInfoFromPreferences() async {
    for (var entry in preferencesKeys.entries) {
      String? value = await Preferences.getValue(entry.value);
      if (value != null) {
        switch (entry.value) {
          case 'vehicle_registration':
            databaseValues['vehicle_registration'] = value;
            break;
          case 'name':
            databaseValues['driver'] = value;
            break;
        }
      }
    }
  }

  Future<int> _getTotalUnits() async {
    int totalUnits = 0;
    DeliveryTicket deliveryTicket = DeliveryTicket();
    var seconds = "00:00:00.0000";
    String today = '${DateTime.now().toString().split(" ")[0]} $seconds';
    String tomorrow =
        '${DateTime.now().add(const Duration(days: 1)).toString().split(" ")[0]} $seconds';
    List<ModelDao> data = await deliveryTicket.getData(where: [
      'date',
      SqlBuilder.constOperators['greaterThan']!,
      '"$today"',
      SqlBuilder.constOperators['and']!,
      'date',
      SqlBuilder.constOperators['lessThan']!,
      '"$tomorrow"'
    ]);
    ProductDeliveryNote product = ProductDeliveryNote();
    List<ProductDeliveryNote> products = [];

    for (var ticket in data) {
      var productAux = await product.getData<ProductDeliveryNote>(where: [
        'idDeliveryNote',
        SqlBuilder.constOperators['equals']!,
        '"${ticket.id}"'
      ]);
      if (productAux.isNotEmpty) {
        products.add(productAux.first);
      }
    }

    for (var product in products) {
      totalUnits += product.units!;
    }

    return totalUnits;
  }

  Future<void> _getReportDatabaseValues() async {
    DeliveryTicket deliveryTicket = DeliveryTicket();
    DeliveryTicketModel deliveryTicketModel = DeliveryTicketModel();
    await deliveryTicketModel.fromEntity(await deliveryTicket.selectLast());
    var totalUnits = await _getTotalUnits();

    databaseValues['slaughterhouseDestination'] =
        deliveryTicketModel.slaughterhouse!.name!;
    databaseValues['totalUnits'] = '$totalUnits';
    databaseValues['rancher'] = deliveryTicketModel.rancher!.name!;
  }

  Future<bool> _isEmpty() async  {
    List deliveryTickets = await DeliveryTicket().selectAll();

    return deliveryTickets.isEmpty;
  }

  Future<void> getDatabaseValues() async {

    if(await _isEmpty()){
      emit(ReportState());
    } else {
      await _getDriverInfoFromPreferences();
      await _getReportDatabaseValues();

      emit(ReportState.all(
        state.date,
        databaseValues['slaughterhouseDestination']!,
        int.parse(databaseValues['totalUnits']!),
        databaseValues['rancher']!,
        databaseValues['driver']!,
        databaseValues['vehicle_registration']!,
      ));
    }
  }
}

class ReportState {
  String date =
      Jiffy.parse(DateTime.now().toString()).format(pattern: 'dd-MM-yyyy');
  String slaughterhouseDestination = '';
  int totalUnits = 0;
  String rancher = '';
  String driver = '';
  String vehicleRegistration = '';

  ReportState();

  ReportState.all(this.date, this.slaughterhouseDestination, this.totalUnits,
      this.rancher, this.driver, this.vehicleRegistration);

  ReportState copyWith(
      {String? date,
      String? slaughterhouseDestination,
      int? totalUnits,
      String? rancher,
      String? driver,
      String? vehicleRegistration}) {
    return ReportState.all(
      date ?? this.date,
      slaughterhouseDestination ?? this.slaughterhouseDestination,
      totalUnits ?? this.totalUnits,
      rancher ?? this.rancher,
      driver ?? this.driver,
      vehicleRegistration ?? this.vehicleRegistration,
    );
  }
}
