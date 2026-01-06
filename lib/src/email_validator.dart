/// Interface for email validation.
/// Follows the Strategy pattern for flexible validation logic.
abstract class IEmailValidator {
  bool isValid(String email);
  String? getValidationError(String email);
}

/// Default implementation of [IEmailValidator] using a standard regex.
class DefaultEmailValidator implements IEmailValidator {
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&'
    r"'"
    r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  @override
  bool isValid(String email) {
    return _emailRegExp.hasMatch(email.trim());
  }

  @override
  String? getValidationError(String email) {
    if (email.trim().isEmpty) return 'Email cannot be empty';
    if (!isValid(email)) return 'Invalid email format';
    return null;
  }
}
