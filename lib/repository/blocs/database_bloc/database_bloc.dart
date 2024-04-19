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
          "name_${event.name}": ["name LIKE '%${event.search}%'", and],
          "nif_${event.nif}": ["nif LIKE '%${event.search}%'", and],
          "code_${event.code}": ["code = '%${event.search}%'", and]
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "vehicleRegistrationNum${event.vehicleRegistrationNum}": ["vehicleRegistrationNum LIKE '%${event.search}%'", and],
          "deliveryTicket${event.deliveryTicket}": ["deliveryTicket LIKE '%${event.search}%'", and],
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "code_${event.code}": ["code = '%${event.search}%'", and],
          "name_${event.name}": ["name LIKE '%${event.search}%'", and],
          "productId_${event.productId}": ["productId LIKE '%${event.search}%'", and]
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "name_${event.name}": ["name LIKE '%${event.search}%'", and],
          "nif_${event.nif}": ["nif LIKE '%${event.search}%'", and],
          "code_${event.code}": ["code = '%${event.search}%'", and],
          "email_${event.email}": ["email LIKE '%${event.search}%'", and]
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "deliveryTicket${event.deliveryTicket}": ["deliveryTicket LIKE '%${event.search}%'", and],
          "idDriver${event.idDriver}": ["idDriver LIKE '%${event.search}%'", and],
          "idVehicleRegistration${event.idVehicleRegistration}": ["idVehicleRegistration LIKE '%${event.search}%'", and],
          "idSlaughterhouse${event.idSlaughterhouse}": ["idSlaughterhouse LIKE '%${event.search}%'", and],
          "idRancher${event.idRancher}": ["idRancher LIKE '%${event.search}%'", and],
          "idProduct${event.idProduct}": ["idProduct LIKE '%${event.search}%'", and],
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "idProduct_${event.idProduct}": ["idProduct LIKE '%${event.search}%'", and],
          "idClassification_${event.idClassification}": ["idClassification LIKE '%${event.search}%'", and],
          "performance_${event.performance}": ["performance = '%${event.search}%'", and]
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "name_${event.name}": ["name LIKE '%${event.search}%'", and],
          "code_${event.code}": ["code = '%${event.search}%'", and]
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "name_${event.name}": ["name LIKE '%${event.search}%'", and],
          "nif_${event.nif}": ["nif LIKE '%${event.search}%'", and],
          "code_${event.code}": ["code = '%${event.search}%'", and]
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "name_${event.name}": ["name LIKE '%${event.search}%'", and],
          "code_${event.code}": ["code = '%${event.search}%'", and]
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
          "idDeliveryNote${event.idDeliveryNote}": ["idDeliveryNote LIKE '%${event.search}%'", and],
          "idProduct${event.idProduct}": ["idProduct LIKE '%${event.search}%'", and],
          "nameClassification${event.nameClassification}": ["nameClassification LIKE '%${event.search}%'", and],
          "units${event.units}": ["units LIKE '%${event.search}%'", and],
          "kilograms${event.kilograms}": ["kilograms LIKE '%${event.search}%'", and],
        };

        for (String key in eventData.keys) {
          if (key.contains("none")) {
            whereClause.addAll(eventData[key]!);
          }
        }

        whereClause.removeLast();
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
      await Future.delayed(const Duration(seconds: 2));
      emit(DatabaseSuccess('', []));
    });

    on<GetProductTickets>((event, emit) async {
      emit(DatabaseLoading());
      await Future.delayed(const Duration(seconds: 2));
      emit(DatabaseSuccess('', []));
    });
  }
}
