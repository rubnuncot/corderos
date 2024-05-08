part of 'ticket_bloc.dart';

abstract class TicketEvent {}

class GetAllProductDeliveryNotes extends TicketEvent {
  final int idDeliveryNote;
  final int idProduct;
  final int idClassification;
  final String nameClassification;
  final int units;
  final double weight;
  final String color;

  GetAllProductDeliveryNotes({
    this.idDeliveryNote = 0,
    this.idProduct = 0,
    this.idClassification = 0,

    this.nameClassification = 'Sin clasificación',
    this.units = 0,
    this.weight = 0.0,
    this.color = 'Sin color'
  });
}