/// The intent model and a deterministic, rule-based intent parser. The parser is the "Intent
/// Parser" box in the architecture: it turns a free-text goal ("plan my trip to Lisbon", "help
/// me focus") into a structured [Intent] the workspace generator can act on. It is pure Dart
/// with no Flutter imports, so it is trivially unit-testable and runs identically on any device.
library;

/// The recognised categories of user intent. Each maps to a workspace of modules.
enum IntentKind {
  focus,
  travel,
  health,
  finance,
  communication,
  learning,
  relax,
  shopping,
  unknown,
}

/// A parsed intent: its category, the salient keywords that matched, and the raw text.
class Intent {
  const Intent({required this.kind, required this.keywords, required this.raw});

  final IntentKind kind;
  final List<String> keywords;
  final String raw;

  /// A short, human-readable echo of what was understood - shown in the UI.
  String get summary {
    switch (kind) {
      case IntentKind.focus:
        return 'Focus session';
      case IntentKind.travel:
        return 'Trip planning';
      case IntentKind.health:
        return 'Health & fitness';
      case IntentKind.finance:
        return 'Money & budgeting';
      case IntentKind.communication:
        return 'Messages & calls';
      case IntentKind.learning:
        return 'Learning';
      case IntentKind.relax:
        return 'Wind down';
      case IntentKind.shopping:
        return 'Shopping';
      case IntentKind.unknown:
        return 'A general workspace';
    }
  }
}

/// Keyword tables per intent. Ordered by specificity so the first strong match wins.
const Map<IntentKind, List<String>> _keywords = {
  IntentKind.travel: ['trip', 'travel', 'flight', 'hotel', 'vacation', 'holiday', 'lisbon', 'tokyo', 'pack', 'itinerary'],
  IntentKind.focus: ['focus', 'work', 'deep work', 'concentrate', 'productive', 'study session', 'ship', 'deadline'],
  IntentKind.health: ['health', 'workout', 'exercise', 'run', 'gym', 'steps', 'sleep', 'water', 'fitness', 'meditate'],
  IntentKind.finance: ['money', 'budget', 'spend', 'spending', 'save', 'savings', 'invest', 'bills', 'expenses', 'finance'],
  IntentKind.communication: ['message', 'text', 'call', 'email', 'reply', 'contact', 'chat', 'meeting'],
  IntentKind.learning: ['learn', 'study', 'course', 'read', 'practice', 'flashcards', 'language'],
  IntentKind.relax: ['relax', 'wind down', 'unwind', 'chill', 'music', 'meditate', 'rest', 'evening'],
  IntentKind.shopping: ['buy', 'shop', 'shopping', 'order', 'cart', 'groceries', 'wishlist'],
};

/// Parse free text into a structured [Intent]. Always returns something usable, defaulting to
/// [IntentKind.unknown] when nothing matches. Deterministic: the same text always parses the same.
Intent parseIntent(String input) {
  final text = input.toLowerCase().trim();
  if (text.isEmpty) {
    return const Intent(kind: IntentKind.unknown, keywords: [], raw: '');
  }

  IntentKind best = IntentKind.unknown;
  var bestScore = 0;
  final matched = <String>[];

  for (final entry in _keywords.entries) {
    final hits = entry.value.where((k) => _matchesWord(text, k)).toList();
    if (hits.length > bestScore) {
      bestScore = hits.length;
      best = entry.key;
      matched
        ..clear()
        ..addAll(hits);
    }
  }

  return Intent(kind: best, keywords: matched, raw: input.trim());
}

/// Whole-word (or whole-phrase) match, so "work" does not match inside "workout".
bool _matchesWord(String text, String keyword) {
  final escaped = RegExp.escape(keyword);
  return RegExp('(?<![a-z0-9])$escaped(?![a-z0-9])').hasMatch(text);
}
