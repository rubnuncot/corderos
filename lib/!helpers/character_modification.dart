import 'package:characters/characters.dart';

class CharacterModification {
  static String normalizeString(String input) {
    final Map<String, String> replacements = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'Á': 'A',
      'É': 'E',
      'Í': 'I',
      'Ó': 'O',
      'Ú': 'U',
      'ñ': 'n',
      'Ñ': 'N',
      'ª': 'a',
      'º': 'o',
      '’': '\'',
      '‘': '\'',
      '´': '\'',
      '`': '\''
    };

    final buffer = StringBuffer();
    for (final char in input.characters) {
      buffer.write(replacements[char] ?? char);
    }
    return buffer.toString();
  }
}
