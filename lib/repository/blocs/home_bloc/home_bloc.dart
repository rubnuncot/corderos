import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/!helpers/print_helper.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_simple_dao_backend/database/utilities/print_handle.dart';

import '../../data_conversion/!data_conversion.dart';

part 'home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    final FtpDataTransfer ftpDataTransfer = FtpDataTransfer();
    final DataFileReader dataFileReader = DataFileReader();

    on<GetFtpData>((event, emit) async {
      emit(HomeLoading());

      try {
        await dataFileReader.readFile();
        await event.dropDownBloc!.getData();
        emit(HomeSuccess('Datos recibidos correctamente', [], 'GetFtpData'));
      } catch (e) {
        LogHelper.logger.d(e);
        emit(HomeError('Error cargando datos'));
      }
    });

    on<SendFiles>((event, emit) {
      emit(HomeLoading());

      try {
        ftpDataTransfer.sendFilesToFTP();
        emit(HomeSuccess('Datos enviados correctamente', [], 'SendFiles'));

      } catch (e) {
        LogHelper.logger.d(e);
        emit(HomeError('Error enviando datos'));
      }
    });

    on<UpdateApp>((event, emit) async {
      emit(HomeLoading());

      try {
        await dataFileReader.executeApp();
        emit(HomeSuccess('App actualizada correctamente', [], 'UpdateApp'));

      } catch (e) {
        LogHelper.logger.d(e);
        emit(HomeError('Error actualizando app'));
      }
    });

    on<PrintResume>((event, emit) async {
      emit(HomeLoading());

      try {
        PrintHelper printHelper = PrintHelper();
        final itemsMap = await printHelper.getBluetooth();
        await printHelper.printResume(event.context, itemsMap.values.toList().first);
        emit(HomeSuccess('Resumen impreso correctamente', [], 'PrintResume'));

      } catch (e) {
        LogHelper.logger.d(e);
        emit(HomeError('Error imprimiendo resumen'));
      }
    });
  }
}
