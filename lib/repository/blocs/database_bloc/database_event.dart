part of 'database_bloc.dart';

abstract class DatabaseEvent {}

class GetDrivers extends DatabaseEvent {
  final String code;
  final String nif;
  final String name;
  final String search;

  GetDrivers({this.code = 'none', this.nif = 'none', this.name = 'none', this.search = 'none'});
}

class GetVehicleRegistrations extends DatabaseEvent {
  final String vehicleRegistrationNum;
  final String deliveryTicket;
  final String search;

  GetVehicleRegistrations({this.vehicleRegistrationNum = 'none', this.deliveryTicket = 'none', this.search = 'none'});
}

class GetClassifications extends DatabaseEvent {
  final String code;
  final String name;
  final int productId;
  final String search;

  GetClassifications({this.code = 'none', this.name = 'none', this.productId = 0, this.search = 'none'});
}

class GetClients extends DatabaseEvent {
  final String code;
  final String nif;
  final String name;
  final String email;
  final String search;

  GetClients({this.code = 'none', this.nif = 'none', this.name = 'none', this.email = 'none', this.search = 'none'});
}


class GetDeliveryTickets extends DatabaseEvent {
  final String deliveryTicket;
  final int idDriver;
  final int idVehicleRegistration;
  final int idSlaughterhouse;
  final int idRancher;
  final int idProduct;
  final String search;

  GetDeliveryTickets({this.deliveryTicket = 'none', this.idDriver = 0, this.idVehicleRegistration = 0, this.idSlaughterhouse = 0, this.idRancher = 0, this.idProduct = 0, this.search = 'none'});

}

class GetPerformances extends DatabaseEvent {
  final int idProduct;
  final int idClassification;
  final int performance;
  final String search;

  GetPerformances({this.idProduct = 0, this.idClassification = 0, this.performance = 0, this.search = 'none'});
}

class GetProduct extends DatabaseEvent {
  final String code;
  final String name;
  final String search;

  GetProduct({this.code = 'none', this.name = 'none', this.search = 'none'});
}


class GetRanchers extends DatabaseEvent {
  final String code;
  final String nif;
  final String name;
  final String search;

  GetRanchers({this.code = 'none', this.nif = 'none', this.name = 'none', this.search = 'none'});
}

class GetSlaughterhouses extends DatabaseEvent {
  final String code;
  final String name;
  final String search;

  GetSlaughterhouses({this.code = 'none', this.name = 'none', this.search = 'none'});
}

class GetProductDeliveryNotes extends DatabaseEvent {
  final int idDeliveryNote;
  final int idProduct;
  final String nameClassification;
  final int units;
  final double kilograms;
  final String search;

  GetProductDeliveryNotes({this.idDeliveryNote = 0, this.idProduct = 0, this.nameClassification = 'none', this.units = 0, this.kilograms = 0, this.search = 'none'});
}

class GetClientDeliveryNotes extends DatabaseEvent {
  final int clientId;
  final int slaughterhouseId;
  final int productId;
  final String search;

  GetClientDeliveryNotes({this.clientId = 0, this.slaughterhouseId = 0, this.productId = 0, this.search = 'none'});
}

class GetProductTickets extends DatabaseEvent {
  final int idTicket;
  final int idProduct;
  final String nameClassification;
  final int numAnimals;
  final double weight;
  final int idPerformance;
  final int losses;
  final String search;

  GetProductTickets({this.idTicket = 0, this.idProduct = 0, this.nameClassification = 'none', this.numAnimals = 0, this.weight = 0, this.idPerformance = 0, this.losses = 0, this.search = 'none'});
}
