import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }
}
