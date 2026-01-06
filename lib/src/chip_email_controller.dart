import 'package:flutter/material.dart';
import 'email_validator.dart';

/// Controller for managing the state of email chips.
/// Follows the Observer pattern (via ValueNotifier) and encapsulates state logic.
class ChipEmailController extends ValueNotifier<List<String>> {
  final IEmailValidator validator;

  ChipEmailController({
    List<String>? initialEmails,
    IEmailValidator? validator,
  })  : validator = validator ?? DefaultEmailValidator(),
        super(initialEmails ?? []);

  /// Adds a new email after validation.
  /// Returns true if added, false otherwise.
  bool addEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;

    // Check if already exists
    if (value.contains(trimmed)) return false;

    if (validator.isValid(trimmed)) {
      value = [...value, trimmed];
      return true;
    }
    return false;
  }

  /// Removes an email from the list.
  void removeEmail(String email) {
    value = value.where((e) => e != email).toList();
  }

  /// Parses a block of text and extracts all valid emails.
  /// This implements the "Intelligent Batch Parsing" feature.
  void parseAndAddEmails(String text) {
    final RegExp emailFinder = RegExp(
      r'[a-zA-Z0-9.!#$%&'
      r"'"
      r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*',
    );

    final matches = emailFinder.allMatches(text);
    final List<String> newEmails = [];

    for (var match in matches) {
      final email = match.group(0);
      if (email != null && !value.contains(email)) {
        newEmails.add(email);
      }
    }

    if (newEmails.isNotEmpty) {
      value = [...value, ...newEmails];
    }
  }

  /// Reorders emails (Drag-and-Drop support).
  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<String> newList = List.from(value);
    final String item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);
    value = newList;
  }
}
