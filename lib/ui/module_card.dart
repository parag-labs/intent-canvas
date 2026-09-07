import 'package:flutter/material.dart';
import '../core/generator.dart';
import 'theme.dart';

/// Maps a module kind to an icon and an accent colour.
IconData _iconFor(ModuleKind kind) {
  switch (kind) {
    case ModuleKind.timer:
      return Icons.timer_outlined;
    case ModuleKind.checklist:
      return Icons.checklist_rounded;
    case ModuleKind.stat:
      return Icons.insights_rounded;
    case ModuleKind.map:
      return Icons.map_outlined;
    case ModuleKind.budget:
      return Icons.account_balance_wallet_outlined;
    case ModuleKind.contacts:
      return Icons.people_outline_rounded;
    case ModuleKind.media:
      return Icons.music_note_outlined;
    case ModuleKind.note:
      return Icons.sticky_note_2_outlined;
    case ModuleKind.weather:
      return Icons.wb_sunny_outlined;
    case ModuleKind.progress:
      return Icons.donut_large_rounded;
  }
}

/// One module rendered as a soft, draggable card on the canvas.
class ModuleCard extends StatefulWidget {
  const ModuleCard({super.key, required this.module});

  final WorkspaceModule module;

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.module;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _hovered ? AppTheme.accent.withOpacity(0.5) : AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.45 : 0.3),
              blurRadius: _hovered ? 26 : 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_iconFor(m.kind), size: 18, color: AppTheme.accent2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.title, style: const TextStyle(color: AppTheme.text, fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(m.subtitle, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            if (m.lines.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...m.lines.take(m.size == ModuleSize.tall ? 5 : 3).map(
                    (line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.radio_button_unchecked, size: 13, color: AppTheme.muted),
                          const SizedBox(width: 8),
                          Expanded(child: Text(line, style: const TextStyle(color: AppTheme.text, fontSize: 12.5))),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

