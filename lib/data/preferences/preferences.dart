import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final Map<String, dynamic> _userPreferences = {
    'nif': 'none',
    'name': 'none',
    'vehicle_registration': 'none',
    'slaughterhouse': 1,
    'host': 'none',
    'port': 21,
    'username': 'none',
    'password': 'none',
    'path': 'none',
    'theme': true, // true = light, false = dark
  };

  static Future<dynamic> getValue(String key) async {
    return _userPreferences.containsKey(key)
        ? await _convertValue<dynamic>(key) ?? 'none'
        : throw Exception(
            'The key $key is not defined as User Preferences variable. Cannot get value.');
  }

  static Future<void> setValue(String key, dynamic value) async {
    _userPreferences.containsKey(key)
        ? await _convertValue<dynamic>(key, value: value)
        : throw Exception(
            'The key $key is not defined as User Preferences variable. Cannot set value $value.');
  }

  static Future<void> restorePreferences() async {
    _userPreferences.forEach((key, value) async {
      dynamic finalValue = 'none';
      switch (key) {
        case 'nif':
          finalValue = 'none';
          break;
        case 'name':
          finalValue = 'none';
          break;
        case 'vehicle_registration':
          finalValue = 'none';
          break;
        case 'slaughterhouse':
          finalValue = 1;
          break;
        case 'host':
          finalValue = 'none';
          break;
        case 'port':
          finalValue = 21;
          break;
        case 'username':
          finalValue = 'none';
          break;
        case 'password':
          finalValue = 'none';
          break;
        case 'path':
          finalValue = 'name';
          break;
        case 'theme':
          finalValue = true;
          break;
      }
      await setValue(key, finalValue);
    });
  }

  static Future<T> _convertValue<T>(dynamic key, {dynamic value = ''}) async {
    late dynamic returnValue;

    switch (value == '' ? _userPreferences[key].runtimeType : value.runtimeType) {
      case String:
        returnValue = value != ''
            ? await _prefs.setString(key, value) as T
            : _prefs.getString(key) as T;
        break;
      case int:
        returnValue = value != ''
            ? await _prefs.setInt(key, value) as T
            : _prefs.getInt(key) as T;
        break;
      case double:
        returnValue = value != ''
            ? await _prefs.setDouble(key, value) as T
            : _prefs.getDouble(key) as T;
        break;
      case bool:
        returnValue = value != ''
            ? await _prefs.setBool(key, value) as T
            : _prefs.getBool(key) as T;
        break;
      case List:
        returnValue = value != ''
            ? await _prefs.setStringList(key, value) as T
            : _prefs.getStringList(key) as T;
        break;
      default:
        value != ''
            ? throw Exception(
                'The type ${value.runtimeType} cannot be set on preferences.')
            : throw Exception(
                'The type ${value.runtimeType} cannot be get from preferences.');
    }

    return returnValue;
  }
}
