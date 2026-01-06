import 'package:flutter_test/flutter_test.dart';
import 'package:chip_emails/chip_emails.dart';

void main() {
  group('ChipEmailParser Tests', () {
    test('isValid correctly identifies emails', () {
      expect(ChipEmailParser.isValid('test@example.com'), isTrue);
      expect(ChipEmailParser.isValid('invalid-email'), isFalse);
    });

    test('parse extracts multiple emails from text', () {
      const text = "Contact dev@flutter.dev or support@google.com";
      final results = ChipEmailParser.parse(text);
      expect(results, containsAll(['dev@flutter.dev', 'support@google.com']));
      expect(results.length, 2);
    });
  });

  group('ChipEmailController Tests', () {
    test('initial values are set', () {
      final controller = ChipEmailController(initialEmails: ['a@b.com']);
      expect(controller.value, equals(['a@b.com']));
    });
  });
}
