/// Utility class for extracting emails from any text.
class ChipEmailParser {
  static final RegExp _emailRegExp = RegExp(
    r'[a-zA-Z0-9.!#$%&'
    r"'"
    r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*',
  );

  /// Extracts all valid emails from a given text string.
  static List<String> parse(String text) {
    if (text.isEmpty) return [];
    return _emailRegExp
        .allMatches(text)
        .map((m) => m.group(0)!)
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Checks if a single string is a valid email.
  static bool isValid(String email) {
    return _emailRegExp.hasMatch(email.trim());
  }
}
