import 'package:bloc/bloc.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

import '../../../data/!data.dart';

part 'database_state.dart';

part 'database_event.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc() : super(DatabaseLoading()) {
    on<GetDrivers>((event, emit) async {
      emit(DatabaseLoading());

      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        Driver driver = Driver();
        List<String> whereClause = [];
        List<Driver> drivers = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "code LIKE '%${event.search}%'",
            or,
            "name LIKE '%${event.search}%'",
            or,
            "nif LIKE '%${event.search}%'",
            and
          ],
          "name_${event.name}": ["name LIKE '%${event.name}%'", and],
          "nif_${event.nif}": ["nif LIKE '%${event.nif}%'", and],
          "code_${event.code}": ["code = '%${event.code}%'", and]
        };

        getConditions(eventData);

        drivers = whereClause.isEmpty
            ? await driver.selectAll() as List<Driver>
            : await driver.select(
                sqlBuilder: SqlBuilder()
                    .querySelect(fields: ["*"])
                    .queryFrom(table: driver.getTableName(driver))
                    .queryWhere(conditions: whereClause)) as List<Driver>;

        emit(
            DatabaseSuccess('Conductores obtenidos correctamente.', [drivers]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetVehicleRegistrations>((event, emit) async {
      emit(DatabaseLoading());

      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        VehicleRegistration vehicleRegistration = VehicleRegistration();
        List<String> whereClause = [];
        List<VehicleRegistration> vehicleRegistrations = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "vehicleRegistrationNum LIKE '%${event.search}%'",
            or,
            "deliveryTicket LIKE '%${event.search}%'",
            and
          ],
          "vehicleRegistrationNum_${event.vehicleRegistrationNum}": ["vehicleRegistrationNum LIKE '%${event.vehicleRegistrationNum}%'", and],
          "deliveryTicket_${event.deliveryTicket}": ["deliveryTicket LIKE '%${event.deliveryTicket}%'", and],
        };

        getConditions(eventData);

        vehicleRegistrations = whereClause.isEmpty
            ? await vehicleRegistration.selectAll() as List<VehicleRegistration>
            : await vehicleRegistration.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: vehicleRegistration.getTableName(vehicleRegistration))
                .queryWhere(conditions: whereClause)) as List<VehicleRegistration>;

        emit(
            DatabaseSuccess('Matrículas obtenidas correctamente.', [vehicleRegistrations]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetClassifications>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        Classification classification = Classification();
        List<String> whereClause = [];
        List<Classification> classifications = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "code LIKE '%${event.search}%'",
            or,
            "name LIKE '%${event.search}%'",
            or,
            "productId LIKE '%${event.search}%'",
            and
          ],
          "code_${event.code}": ["code = '%${event.code}%'", and],
          "name_${event.name}": ["name LIKE '%${event.name}%'", and],
          "productId_${event.productId}": ["productId = '%${event.productId}%'", and]
        };

        getConditions(eventData);

        classifications = whereClause.isEmpty
            ? await classification.selectAll() as List<Classification>
            : await classification.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: classification.getTableName(classification))
                .queryWhere(conditions: whereClause)) as List<Classification>;

        emit(
            DatabaseSuccess('Clasificaciones obtenidas correctamente.', [classifications]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetClients>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        Client client = Client();
        List<String> whereClause = [];
        List<Client> clients = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "code LIKE '%${event.search}%'",
            or,
            "name LIKE '%${event.search}%'",
            or,
            "nif LIKE '%${event.search}%'",
            or,
            "email LIKE '%${event.search}%'",
            and
          ],
          "name_${event.name}": ["name LIKE '%${event.name}%'", and],
          "nif_${event.nif}": ["nif LIKE '%${event.nif}%'", and],
          "code_${event.code}": ["code = '%${event.code}%'", and],
          "email_${event.email}": ["email LIKE '%${event.email}%'", and]
        };

        getConditions(eventData);

        clients = whereClause.isEmpty
            ? await client.selectAll() as List<Client>
            : await client.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: client.getTableName(client))
                .queryWhere(conditions: whereClause)) as List<Client>;

        emit(
            DatabaseSuccess('Clientes obtenidos correctamente.', [clients]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetDeliveryTickets>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        DeliveryTicket deliveryTicket = DeliveryTicket();
        List<String> whereClause = [];
        List<DeliveryTicket> deliveryTickets = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "deliveryTicket LIKE '%${event.search}%'",
            or,
            "idDriver LIKE '%${event.search}%'",
            or,
            "idVehicleRegistration LIKE '%${event.search}%'",
            or,
            "idSlaughterhouse LIKE '%${event.search}%'",
            or,
            "idRancher LIKE '%${event.search}%'",
            or,
            "idProduct LIKE '%${event.search}%'",
            and,
          ],
          "deliveryTicket_${event.deliveryTicket}": ["deliveryTicket LIKE '%${event.deliveryTicket}%'", and],
          "idDriver_${event.idDriver}": ["idDriver = '%${event.idDriver}%'", and],
          "idVehicleRegistration_${event.idVehicleRegistration}": ["idVehicleRegistration = '%${event.idVehicleRegistration}%'", and],
          "idSlaughterhouse_${event.idSlaughterhouse}": ["idSlaughterhouse = '%${event.idSlaughterhouse}%'", and],
          "idRancher_${event.idRancher}": ["idRancher = '%${event.idRancher}%'", and],
          "idProduct_${event.idProduct}": ["idProduct = '%${event.idProduct}%'", and],
        };

        getConditions(eventData);

        deliveryTickets = whereClause.isEmpty
            ? await deliveryTicket.selectAll() as List<DeliveryTicket>
            : await deliveryTicket.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: deliveryTicket.getTableName(deliveryTicket))
                .queryWhere(conditions: whereClause)) as List<DeliveryTicket>;

        emit(
            DatabaseSuccess('Tickes de entrega obtenidos correctamente.', [deliveryTickets]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetPerformances>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        Performance performance = Performance();
        List<String> whereClause = [];
        List<Performance> performances = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "idProduct LIKE '%${event.search}%'",
            or,
            "idClassification LIKE '%${event.search}%'",
            or,
            "performance LIKE '%${event.search}%'",
            and
          ],
          "idProduct_${event.idProduct}": ["idProduct LIKE '%${event.idProduct}%'", and],
          "idClassification_${event.idClassification}": ["idClassification LIKE '%${event.idClassification}%'", and],
          "performance_${event.performance}": ["performance = '%${event.performance}%'", and]
        };

        getConditions(eventData);

        performances = whereClause.isEmpty
            ? await performance.selectAll() as List<Performance>
            : await performance.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: performance.getTableName(performance))
                .queryWhere(conditions: whereClause)) as List<Performance>;

        emit(
              DatabaseSuccess('Rendimientos obtenidos correctamente.', [performances]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetProduct>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        Product product = Product();
        List<String> whereClause = [];
        List<Product> products = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "code LIKE '%${event.search}%'",
            or,
            "name LIKE '%${event.search}%'",
            and
          ],
          "name_${event.name}": ["name LIKE '%${event.name}%'", and],
          "code_${event.code}": ["code = '%${event.code}%'", and]
        };

        getConditions(eventData);

        products = whereClause.isEmpty
            ? await product.selectAll() as List<Product>
            : await product.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: product.getTableName(product))
                .queryWhere(conditions: whereClause)) as List<Product>;

        emit(
            DatabaseSuccess('Productos obtenidos correctamente.', [products]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetRanchers>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        Rancher rancher = Rancher();
        List<String> whereClause = [];
        List<Rancher> ranchers = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "code LIKE '%${event.search}%'",
            or,
            "name LIKE '%${event.search}%'",
            or,
            "nif LIKE '%${event.search}%'",
            and
          ],
          "name_${event.name}": ["name LIKE '%${event.name}%'", and],
          "nif_${event.nif}": ["nif LIKE '%${event.nif}%'", and],
          "code_${event.code}": ["code = '%${event.code}%'", and]
        };

        getConditions(eventData);

        ranchers = whereClause.isEmpty
            ? await rancher.selectAll() as List<Rancher>
            : await rancher.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: rancher.getTableName(rancher))
                .queryWhere(conditions: whereClause)) as List<Rancher>;

        emit(
            DatabaseSuccess('Ganaderos obtenidos correctamente.', [ranchers]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetSlaughterhouses>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        Slaughterhouse slaughterhouse = Slaughterhouse();
        List<String> whereClause = [];
        List<Slaughterhouse> slaughters = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "code LIKE '%${event.search}%'",
            or,
            "name LIKE '%${event.search}%'",
            and
          ],
          "name_${event.name}": ["name LIKE '%${event.name}%'", and],
          "code_${event.code}": ["code = '%${event.code}%'", and]
        };

        getConditions(eventData);

        slaughters = whereClause.isEmpty
            ? await slaughterhouse.selectAll() as List<Slaughterhouse>
            : await slaughterhouse.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: slaughterhouse.getTableName(slaughterhouse))
                .queryWhere(conditions: whereClause)) as List<Slaughterhouse>;

        emit(
            DatabaseSuccess('Mataderos obtenidos correctamente.', [slaughters]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetProductDeliveryNotes>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        ProductDeliveryNote productDeliveryNote = ProductDeliveryNote();
        List<String> whereClause = [];
        List<ProductDeliveryNote> productDeliveryNotes = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "idDeliveryNote LIKE '%${event.search}%'",
            or,
            "idProduct LIKE '%${event.search}%'",
            or,
            "nameClassification LIKE '%${event.search}%'",
            or,
            "idSlaughterhouse LIKE '%${event.search}%'",
            or,
            "units LIKE '%${event.search}%'",
            or,
            "kilograms LIKE '%${event.search}%'",
            and,
          ],
          "idDeliveryNote_${event.idDeliveryNote}": ["idDeliveryNote = '%${event.idDeliveryNote}%'", and],
          "idProduct_${event.idProduct}": ["idProduct LIKE '%${event.idProduct}%'", and],
          "nameClassification_${event.nameClassification}": ["nameClassification LIKE '%${event.nameClassification}%'", and],
          "units_${event.units}": ["units LIKE '%${event.units}%'", and],
          "kilograms_${event.kilograms}": ["kilograms LIKE '%${event.kilograms}%'", and],
        };

        getConditions(eventData);

        productDeliveryNotes = whereClause.isEmpty
            ? await productDeliveryNote.selectAll() as List<ProductDeliveryNote>
            : await productDeliveryNote.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: productDeliveryNote.getTableName(productDeliveryNote))
                .queryWhere(conditions: whereClause)) as List<ProductDeliveryNote>;

        emit(
            DatabaseSuccess('Albarán de productos obtenidos correctamente.', [productDeliveryNotes]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetClientDeliveryNotes>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        ClientDeliveryNote clientDeliveryNote = ClientDeliveryNote();
        List<String> whereClause = [];
        List<ClientDeliveryNote> clientsDeliveryNotes = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "idDeliveryNote LIKE '%${event.search}%'",
            or,
            "idProduct LIKE '%${event.search}%'",
            or,
            "nameClassification LIKE '%${event.search}%'",
            or,
            "idSlaughterhouse LIKE '%${event.search}%'",
            or,
            "units LIKE '%${event.search}%'",
            or,
            "kilograms LIKE '%${event.search}%'",
            and,
          ],
          "idDeliveryNote_${event.clientId}": ["idDeliveryNote LIKE '%${event.clientId}%'", and],
          "idProduct_${event.productId}": ["idProduct LIKE '%${event.productId}%'", and],
          "idProduct_${event.slaughterhouseId}": ["idProduct LIKE '%${event.slaughterhouseId}%'", and],
        };

        getConditions(eventData);

        clientsDeliveryNotes = whereClause.isEmpty
            ? await clientDeliveryNote.selectAll() as List<ClientDeliveryNote>
            : await clientDeliveryNote.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: clientDeliveryNote.getTableName(clientDeliveryNote))
                .queryWhere(conditions: whereClause)) as List<ClientDeliveryNote>;

        emit(
            DatabaseSuccess('Albarán de productos obtenidos correctamente.', [clientsDeliveryNotes]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });

    on<GetProductTickets>((event, emit) async {
      emit(DatabaseLoading());
      try {
        String or = SqlBuilder.constOperators['or']!;
        String and = SqlBuilder.constOperators['and']!;

        ProductDeliveryNote productDeliveryNote = ProductDeliveryNote();
        List<String> whereClause = [];
        List<ProductDeliveryNote> productsDeliveryNotes = [];

        Map<String, Iterable<String>> eventData = {
          "search_${event.search}": [
            "idDeliveryNote LIKE '%${event.search}%'",
            or,
            "idProduct LIKE '%${event.search}%'",
            or,
            "nameClassification LIKE '%${event.search}%'",
            or,
            "idSlaughterhouse LIKE '%${event.search}%'",
            or,
            "units LIKE '%${event.search}%'",
            or,
            "kilograms LIKE '%${event.search}%'",
            and,
          ],
          "idDeliveryNote_${event.idPerformance}": ["idDeliveryNote LIKE '%${event.idPerformance}%'", and],
          "idProduct_${event.idProduct}": ["idProduct LIKE '%${event.idProduct}%'", and],
          "idProduct_${event.idTicket}": ["idProduct LIKE '%${event.idTicket}%'", and],
          "idProduct_${event.losses}": ["idProduct LIKE '%${event.losses}%'", and],
          "idProduct_${event.nameClassification}": ["idProduct LIKE '%${event.nameClassification}%'", and],
          "idProduct_${event.numAnimals}": ["idProduct LIKE '%${event.numAnimals}%'", and],
          "idProduct_${event.weight}": ["idProduct LIKE '%${event.weight}%'", and],
        };

        getConditions(eventData);

        productsDeliveryNotes = whereClause.isEmpty
            ? await productDeliveryNote.selectAll() as List<ProductDeliveryNote>
            : await productDeliveryNote.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: productDeliveryNote.getTableName(productDeliveryNote))
                .queryWhere(conditions: whereClause)) as List<ProductDeliveryNote>;

        emit(
            DatabaseSuccess('Albarán de productos obtenidos correctamente.', [productsDeliveryNotes]));
      } catch (e) {
        emit(DatabaseError(e.toString()));
      }
    });
  }

  List<String> getConditions(Map<String, Iterable<String>> eventData) {
    List<String> conditions = [];
    for (String key in eventData.keys) {
      if (key.contains("none")) {
        for(var condition in eventData[key]!){
          conditions.add(condition);
        }
      }
    }
    conditions.removeLast();
    return conditions;
  }
}
