import 'package:flutter_test/flutter_test.dart';
import 'package:intent_canvas/core/intent.dart';
import 'package:intent_canvas/core/generator.dart';

void main() {
  group('generateWorkspace', () {
    test('produces a coherent workspace for each known intent', () {
      for (final kind in IntentKind.values) {
        final modules = generateWorkspace(Intent(kind: kind, keywords: const [], raw: ''));
        expect(modules.length, greaterThanOrEqualTo(3), reason: '$kind should have >= 3 modules');
        // ids are unique within a workspace
        final ids = modules.map((m) => m.id).toSet();
        expect(ids.length, modules.length, reason: '$kind has duplicate module ids');
      }
    });

    test('is deterministic', () {
      final a = generateWorkspace(parseIntent('plan my trip to Lisbon'));
      final b = generateWorkspace(parseIntent('plan my trip to Lisbon'));
      expect(a.map((m) => m.id).toList(), b.map((m) => m.id).toList());
    });

    test('a travel intent yields a map and an itinerary', () {
      final modules = generateWorkspace(parseIntent('plan my trip to Lisbon'));
      expect(modules.any((m) => m.kind == ModuleKind.map), isTrue);
      expect(modules.any((m) => m.kind == ModuleKind.checklist), isTrue);
    });

    test('a focus intent yields a timer', () {
      final modules = generateWorkspace(parseIntent('help me focus'));
      expect(modules.any((m) => m.kind == ModuleKind.timer), isTrue);
    });

    test('checklist modules carry their lines', () {
      final modules = generateWorkspace(parseIntent('help me focus'));
      final list = modules.firstWhere((m) => m.kind == ModuleKind.checklist);
      expect(list.lines, isNotEmpty);
    });

    test('at least six sample intents produce distinct workspaces', () {
      final samples = [
        'help me focus',
        'plan my trip to Lisbon',
        'track my workout',
        'review my spending',
        'who do I need to reply to',
        'help me wind down',
      ];
      final signatures = samples.map((s) => generateWorkspace(parseIntent(s)).map((m) => m.id).join(',')).toSet();
      expect(signatures.length, samples.length, reason: 'each sample should produce a distinct workspace');
    });
  });
}
