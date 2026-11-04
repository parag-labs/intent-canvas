import 'package:flutter/material.dart' hide Intent;
import 'core/intent.dart';
import 'core/generator.dart';
import 'ui/theme.dart';
import 'ui/module_card.dart';

void main() => runApp(const IntentCanvasApp());

class IntentCanvasApp extends StatelessWidget {
  const IntentCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntentCanvas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const CanvasScreen(),
    );
  }
}

const _suggestions = [
  'Help me focus',
  'Plan my trip to Lisbon',
  'Track my workout',
  'Review my spending',
  'Who do I need to reply to?',
  'Help me wind down',
];

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final _controller = TextEditingController();
  Intent _intent = parseIntent('');
  List<WorkspaceModule> _modules = generateWorkspace(parseIntent(''));

  void _run(String text) {
    _controller.text = text;
    setState(() {
      _intent = parseIntent(text);
      _modules = generateWorkspace(_intent);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // A phone-sized frame so the web demo reads as a mobile app.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, -0.9),
                radius: 1.4,
                colors: [Color(0x267C6CFF), AppTheme.bg],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accent2]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('IntentCanvas', style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700, fontSize: 16)),
                        const Spacer(),
                        Text(_intent.summary, style: const TextStyle(color: AppTheme.accent2, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _IntentField(controller: _controller, onSubmit: _run),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => _Chip(label: _suggestions[i], onTap: () => _run(_suggestions[i])),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(child: _Canvas(modules: _modules)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IntentField extends StatelessWidget {
  const _IntentField({required this.controller, required this.onSubmit});
  final TextEditingController controller;
  final void Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmit,
      style: const TextStyle(color: AppTheme.text, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'What do you want to do?',
        hintStyle: const TextStyle(color: AppTheme.muted),
        prefixIcon: const Icon(Icons.auto_awesome, color: AppTheme.accent2, size: 20),
        filled: true,
        fillColor: AppTheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.accent)),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppTheme.accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppTheme.border),
        ),
        child: Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
      ),
    );
  }
}

/// The living canvas: modules animate in when the intent changes. A two-column masonry-ish
/// layout gives a spatial, workspace feel rather than a rigid grid.
class _Canvas extends StatelessWidget {
  const _Canvas({required this.modules});
  final List<WorkspaceModule> modules;

  @override
  Widget build(BuildContext context) {
    final left = <WorkspaceModule>[];
    final right = <WorkspaceModule>[];
    for (var i = 0; i < modules.length; i++) {
      (i.isEven ? left : right).add(modules[i]);
    }

    Widget column(List<WorkspaceModule> items) => Expanded(
          child: Column(
            children: [
              for (final m in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ModuleCard(key: ValueKey(m.id), module: m),
                ),
            ],
          ),
        );

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          column(left),
          const SizedBox(width: 12),
          column(right),
        ],
      ),
    );
  }
}
