import 'package:bloc/bloc.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:corderos_app/repository/!repository.dart';

class DropDownBloc extends Cubit<DropDownState> {
  DropDownBloc() : super(DropDownState());
  Map<String, List<String>> values = {
    'driver': [],
    'vehicle_registration': [],
    'slaughterhouse': [],
    'rancher': [],
    'product': [],
    'classification': [],
    'performance': [],
  };

  Map<String, String> preferencesKeys = {
    'vehicle_registration': 'vehicle_registration',
    'driver': 'name',
  };

  Future<void> changeValue(String key, String value) async {
    if (values.containsKey(key) && values[key]!.contains(value)) {
      await Preferences.setValue(preferencesKeys[key]!, value);
    }

    state.selectedValues[key] = value;
  }

  Future<void> _getDatabaseValues() async {
    // Ejecución en paralelo de todas las consultas de selección
    var fetchResults = await Future.wait([
      Driver().selectAll<Driver>(),
      Rancher().selectAll<Rancher>(),
      Slaughterhouse().selectAll<Slaughterhouse>(),
      VehicleRegistration().selectAll<VehicleRegistration>(),
      Product().selectAll<Product>(),
      Classification().selectAll<Classification>(),
      Performance().selectAll<Performance>(),
    ]);

    // Convertir entidades a modelos en paralelo
    var modelResults = await Future.wait([
      DriverModel().fromEntityList<DriverModel>(fetchResults[0]),
      RancherModel().fromEntityList<RancherModel>(fetchResults[1]),
      SlaughterhouseModel()
          .fromEntityList<SlaughterhouseModel>(fetchResults[2]),
      VehicleRegistrationModel()
          .fromEntityList<VehicleRegistrationModel>(fetchResults[3]),
      ProductModel().fromEntityList<ProductModel>(fetchResults[4]),
      ClassificationModel()
          .fromEntityList<ClassificationModel>(fetchResults[5]),
      PerformanceModel().fromEntityList<PerformanceModel>(fetchResults[6]),
    ]);

    // Asignación simplificada de modelos a state
    List<String> modelKeys = [
      'driver',
      'rancher',
      'slaughterhouse',
      'vehicle_registration',
      'product',
      'classification',
      'performance'
    ];

    Map<String, List> models = Map.fromIterables(modelKeys, modelResults);
    state.models = models;

    // Procesamiento de datos de modelos para almacenar valores específicos
    Map<String, List<String>> values = {};
    for (var key in modelKeys) {
      values[key] = state.models[key]!.map<String>((e) {
        if (key == 'vehicle_registration') {
          return e.vehicleRegistrationNum;
        } else if (key == 'performance') {
          return e.performance.toString();
        }
        return e.name;
      }).toList();
    }

    // Asignación condicional a los valores seleccionados
    if (state.selectedValues['driver']! == '') {
      state.values = values;
      state.selectedValues = {
        for (var key in modelKeys) key: values[key]!.first
      };
    } else {
      state.values = values;
    }
  }

  //! Método que cuando seleccione un producto, en la lista de valores del dropdown de clasificaciones
  //! enseñe solo las clasificaciones que tenga ese producto. Luego lo mismo pero con los rendimientos.
  //! Luego coger los rendimientos que pertenezcan a ese producto.
  Future<void> filterSelectedProduct() async {
    String productSelectedValue = state.selectedValues['product']!;

    List<ClassificationModel> classifications =
        state.models["classification"]! as List<ClassificationModel>;

    state.values["classification"] = [];
    for (var classification in classifications) {
      if (classification.product!.name == productSelectedValue) {
        state.values["classification"]!.add(classification.name!);
      }
    }
  }

  Future<void> filterSelectedClassification() async {
    String productSelectedValue = state.selectedValues['product']!;
    String classificationSelectedValue =
        state.selectedValues['classification']!;

    List<PerformanceModel> performances =
        state.models["performance"]! as List<PerformanceModel>;

    state.values["performance"] = [];
    for (var performance in performances) {
      if (performance.product!.name == productSelectedValue &&
          performance.classification!.name == classificationSelectedValue) {
        state.values["performance"]!.add("${performance.performance}");
      }
    }
  }

  Future<void> _getPreferenceValue() async {
    for (var entry in preferencesKeys.entries) {
      final value = await Preferences.getValue(entry.value);
      if (values[entry.key] != null && values[entry.key]!.contains(value)) {
        state.selectedValues[entry.key] = value;
      }
    }
  }

  Future<Map<String, dynamic>> getSelectedModel() async {
    Map<String, dynamic> returnedList = {};

    state.models.forEach((modelListKey, modelList) {
      for (var model in modelList) {
        var selectedValue = state.selectedValues[modelListKey];
        bool shouldAddModel = false;

        if (model is VehicleRegistrationModel) {
          shouldAddModel = model.vehicleRegistrationNum == selectedValue;
        } else if (model is PerformanceModel) {
          shouldAddModel = model.performance == int.tryParse(selectedValue!);
        } else {
          shouldAddModel = model.name == selectedValue;
        }

        if (shouldAddModel) {
          returnedList[model.runtimeType.toString()] = model;
        }
      }
    });

    return returnedList;
  }


  Future<void> getData() async {
    await _getDatabaseValues();
    await _getPreferenceValue();
    emit(state);
  }

  void reset() {
    emit(DropDownState());
  }
}

class DropDownState {
  Map<String, List<String>> values = {
    'driver': [],
    'vehicle_registration': [],
    'slaughterhouse': [],
    'rancher': [],
    'product': [],
    'classification': [],
    'performance': [],
  };

  Map<String, String> selectedValues = {
    'driver': '',
    'vehicle_registration': '',
    'slaughterhouse': '',
    'rancher': '',
    'product': '',
    'classification': '',
    'performance': '',
  };

  Map<String, List> models = {
    'driver': [],
    'vehicle_registration': [],
    'slaughterhouse': [],
    'rancher': [],
    'product': [],
    'classification': [],
    'performance': [],
  };

  DropDownState();

  DropDownState.all(
      {Map<String, List<String>>? values, Map<String, String>? selectedValues});

  DropDownState copyWith(
      {Map<String, List<String>>? values,
      Map<String, String>? selectedValues}) {
    return DropDownState.all(
        values: values ?? this.values,
        selectedValues: selectedValues ?? this.selectedValues);
  }
}
