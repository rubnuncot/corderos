part of 'burden_bloc.dart';

abstract class BurdenEvent {}

//checkChanges, tableData, markDataRead, saveData

class GetChanges extends BurdenEvent {
  final int id;
  final DateTime date;
  final String tableChanged;
  final bool isRead;

  GetChanges(
      {this.id = 0,
      DateTime? date,
      this.tableChanged = 'none',
      this.isRead = false})
      : date = date ?? DateTime.now();
}

class GetProductTicketsBurden extends BurdenEvent {
  final int idTicket;
  final int idProduct;
  final String nameClassification;
  final int numAnimals;
  final double weight;
  final int idPerformance;

  GetProductTicketsBurden({
    this.idTicket = 0,
    this.idProduct = 0,
    this.nameClassification = 'none',
    this.numAnimals = 0,
    this.weight = 0,
    this.idPerformance = 0,
  });
}

class GetTableIndex extends BurdenEvent {
  final int idTable;

  GetTableIndex({
    this.idTable = 0
  });
}

class IncrementTableIndex extends BurdenEvent {
  final int idTable;

  IncrementTableIndex({
    this.idTable = 0
  });
}

class UploadData extends BurdenEvent {
  BuildContext? context;
  DeliveryTicket? deliveryTicket;
  ProductDeliveryNote? productDeliveryNote;

  UploadData({
    this.context,
    this.deliveryTicket,
    this.productDeliveryNote,
  });
}





