import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final Map<String, dynamic> _userPreferences = {
    'dni': 'none',
    'nombre': 'none',
    'save': '0',
    'overlay': '1',
    'salt': 'none',
    'password': 'none',
    'connection': 'none'
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
      String finalValue = 'none';
      switch (key) {
        case 'save':
          finalValue = '0';
          break;
        case 'overlay':
          finalValue = '1';
          break;
        case 'connection':
          break;
        case 'password':
          break;
      }
      await setValue(key, finalValue);
    });
  }

  static Future<T> _convertValue<T>(dynamic key, {dynamic value = ''}) async {
    late dynamic returnValue;

    switch (value.runtimeType) {
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
