import 'package:bloc/bloc.dart';

import '../../data_conversion/!data_conversion.dart';

class HomeBloc extends Cubit<HomeBlocState> {
  final FtpDataTransfer ftpDataTransfer = FtpDataTransfer();
  final DataFileReader dataFileReader = DataFileReader();

  HomeBloc() : super(HomeBlocState());

  Future<void> getFtpData() async {
    emit(state.copyWith(message: 'Cargando...', state: 220));
    try {
      await dataFileReader.readFile();
      emit(state.copyWith(message: 'Datos recibidos correctamente', state: 200));
    } catch (e) {
      emit(state.copyWith(message: 'Error cargando datos\n$e', state: 500));
    }
  }

  Future<void> sendFiles() async {
    await ftpDataTransfer.sendFilesToFTP();
  }
}

class HomeBlocState {
  String message = '';

  ///Estados:
  /// 200: Estado correcto.
  /// 220: Estado cargando.
  /// 500: Estado error.
  int state = 0;

  HomeBlocState();

  HomeBlocState.all({String? message, int? state});

  HomeBlocState copyWith({String? message, int? state}) {
    return HomeBlocState.all(
        message: message ?? this.message, state: state ?? this.state);
  }
}
