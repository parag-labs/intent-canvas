import 'package:flutter_test/flutter_test.dart';
import 'package:intent_canvas/core/intent.dart';

void main() {
  group('parseIntent', () {
    test('classifies a focus intent', () {
      expect(parseIntent('help me focus for the next hour').kind, IntentKind.focus);
      expect(parseIntent('I need to do deep work').kind, IntentKind.focus);
    });

    test('classifies a travel intent', () {
      expect(parseIntent('plan my trip to Lisbon').kind, IntentKind.travel);
      expect(parseIntent('book a flight and hotel').kind, IntentKind.travel);
    });

    test('classifies health, finance, and communication intents', () {
      expect(parseIntent('track my workout and steps').kind, IntentKind.health);
      expect(parseIntent('review my spending this month').kind, IntentKind.finance);
      expect(parseIntent('who do I need to reply to?').kind, IntentKind.communication);
    });

    test('falls back to unknown for unrelated text', () {
      expect(parseIntent('asdf qwerty zzz').kind, IntentKind.unknown);
    });

    test('is empty-safe', () {
      final i = parseIntent('');
      expect(i.kind, IntentKind.unknown);
      expect(i.keywords, isEmpty);
    });

    test('is deterministic', () {
      expect(parseIntent('plan my trip').kind, parseIntent('plan my trip').kind);
    });

    test('collects the matched keywords', () {
      final i = parseIntent('plan my trip, book a flight');
      expect(i.kind, IntentKind.travel);
      expect(i.keywords, contains('trip'));
      expect(i.keywords, contains('flight'));
    });

    test('every kind has a non-empty summary', () {
      for (final kind in IntentKind.values) {
        final i = Intent(kind: kind, keywords: const [], raw: '');
        expect(i.summary.isNotEmpty, isTrue);
      }
    });
  });
}
