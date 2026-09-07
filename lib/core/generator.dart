/// The module model and the workspace generator. The generator is the "Workspace Generator" box
/// in the architecture: given a parsed [Intent] it deterministically produces a coherent set of
/// [WorkspaceModule]s (cards, actions, live data) to render on the canvas. Pure Dart, no Flutter
/// imports - fully unit-testable.
library;

import 'intent.dart';

/// The kind of module, which drives its icon and default rendering.
enum ModuleKind { timer, checklist, stat, map, budget, contacts, media, note, weather, progress }

/// The visual footprint of a module on the canvas grid.
enum ModuleSize { small, wide, tall, large }

/// A single generated module: a self-contained card on the intent canvas.
class WorkspaceModule {
  const WorkspaceModule({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    this.size = ModuleSize.small,
    this.lines = const [],
  });

  final String id;
  final ModuleKind kind;
  final String title;
  final String subtitle;
  final ModuleSize size;

  /// Optional body lines (checklist items, stats, etc.).
  final List<String> lines;
}

WorkspaceModule _m(String id, ModuleKind kind, String title, String subtitle, ModuleSize size, [List<String> lines = const []]) =>
    WorkspaceModule(id: id, kind: kind, title: title, subtitle: subtitle, size: size, lines: lines);

/// Generate a workspace (ordered list of modules) for an intent. Deterministic: the same intent
/// always yields the same modules, so the canvas is reproducible and testable.
List<WorkspaceModule> generateWorkspace(Intent intent) {
  switch (intent.kind) {
    case IntentKind.focus:
      return [
        _m('focus_timer', ModuleKind.timer, 'Focus timer', '25:00 Pomodoro', ModuleSize.wide),
        _m('focus_tasks', ModuleKind.checklist, "Today's priorities", '3 tasks', ModuleSize.tall, ['Finish the API spec', 'Review the PR', 'Write release notes']),
        _m('focus_dnd', ModuleKind.stat, 'Do Not Disturb', 'On until 12:30', ModuleSize.small),
        _m('focus_music', ModuleKind.media, 'Deep focus', 'Ambient playlist', ModuleSize.small),
      ];
    case IntentKind.travel:
      return [
        _m('trip_itinerary', ModuleKind.checklist, 'Itinerary', '4 days', ModuleSize.tall, ['Flight 08:15', 'Check in hotel', 'Old town walk', 'Day trip']),
        _m('trip_map', ModuleKind.map, 'Destination', 'Lisbon, Portugal', ModuleSize.wide),
        _m('trip_budget', ModuleKind.budget, 'Trip budget', '\$1,240 / \$2,000', ModuleSize.small),
        _m('trip_weather', ModuleKind.weather, 'Weather', '22°C, sunny', ModuleSize.small),
        _m('trip_pack', ModuleKind.checklist, 'Packing', '6 items left', ModuleSize.small, ['Passport', 'Charger', 'Adapter']),
      ];
    case IntentKind.health:
      return [
        _m('health_rings', ModuleKind.progress, 'Activity', '7,400 / 10,000 steps', ModuleSize.wide),
        _m('health_workout', ModuleKind.checklist, "Today's workout", '4 exercises', ModuleSize.tall, ['Warm up 5m', 'Squats 3×10', 'Rows 3×12', 'Stretch']),
        _m('health_water', ModuleKind.stat, 'Hydration', '1.4 / 2.0 L', ModuleSize.small),
        _m('health_sleep', ModuleKind.stat, 'Last night', '7h 12m sleep', ModuleSize.small),
      ];
    case IntentKind.finance:
      return [
        _m('fin_spend', ModuleKind.budget, 'This month', '\$2,180 spent', ModuleSize.wide),
        _m('fin_bills', ModuleKind.checklist, 'Upcoming bills', '3 due', ModuleSize.tall, ['Rent — 1st', 'Internet — 5th', 'Phone — 9th']),
        _m('fin_save', ModuleKind.progress, 'Savings goal', '\$3,400 / \$5,000', ModuleSize.small),
        _m('fin_top', ModuleKind.stat, 'Top category', 'Dining \$420', ModuleSize.small),
      ];
    case IntentKind.communication:
      return [
        _m('comm_replies', ModuleKind.checklist, 'Needs a reply', '5 threads', ModuleSize.tall, ['Alex — project', 'Mom', 'Team standup', 'Landlord', 'Bank']),
        _m('comm_meeting', ModuleKind.stat, 'Next meeting', '2:00 PM standup', ModuleSize.wide),
        _m('comm_contacts', ModuleKind.contacts, 'Frequent', '4 people', ModuleSize.small),
        _m('comm_draft', ModuleKind.note, 'Draft', 'Reply to Alex…', ModuleSize.small),
      ];
    case IntentKind.learning:
      return [
        _m('learn_today', ModuleKind.checklist, 'Study plan', '3 blocks', ModuleSize.tall, ['Review flashcards', 'Chapter 4', 'Practice set']),
        _m('learn_streak', ModuleKind.progress, 'Streak', '12 days', ModuleSize.small),
        _m('learn_cards', ModuleKind.stat, 'Flashcards due', '24 cards', ModuleSize.small),
        _m('learn_timer', ModuleKind.timer, 'Study timer', '50:00', ModuleSize.wide),
      ];
    case IntentKind.relax:
      return [
        _m('relax_music', ModuleKind.media, 'Wind down', 'Calm playlist', ModuleSize.wide),
        _m('relax_breathe', ModuleKind.timer, 'Breathe', '4-7-8 · 3 min', ModuleSize.small),
        _m('relax_lights', ModuleKind.stat, 'Lights', 'Warm · 20%', ModuleSize.small),
        _m('relax_note', ModuleKind.note, 'Journal', 'One line about today…', ModuleSize.tall),
      ];
    case IntentKind.shopping:
      return [
        _m('shop_cart', ModuleKind.checklist, 'Cart', '4 items', ModuleSize.tall, ['Coffee beans', 'Olive oil', 'Notebook', 'Batteries']),
        _m('shop_budget', ModuleKind.budget, 'Grocery budget', '\$64 / \$120', ModuleSize.small),
        _m('shop_wishlist', ModuleKind.stat, 'Wishlist', '7 saved', ModuleSize.small),
        _m('shop_reorder', ModuleKind.stat, 'Reorder', 'Usual essentials', ModuleSize.wide),
      ];
    case IntentKind.unknown:
      return [
        _m('u_search', ModuleKind.note, 'Start anywhere', 'Type an intent above', ModuleSize.wide),
        _m('u_time', ModuleKind.stat, 'Now', 'A calm blank canvas', ModuleSize.small),
        _m('u_suggest', ModuleKind.checklist, 'Try', '4 ideas', ModuleSize.tall, ['Help me focus', 'Plan my trip', 'Track my workout', 'Review my spending']),
      ];
  }
}
