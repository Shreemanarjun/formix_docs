import 'dart:async';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';
import 'package:universal_web/web.dart' as web;
import 'package:jaspr_content/jaspr_content.dart';
import '../theme_mode.dart';
import '../providers.dart';

@Import.onWeb('../widgets/combined_flutter_app.dart', show: [#CombinedFlutterApp])
import 'combined_embed.imports.dart' deferred as combined_lib;

// ─── Markdown-parsing glue ───────────────────────────────────────────────────

class ExampleAppEmbedMarkdown extends CustomComponentBase {
  @override
  final Pattern pattern = 'ExampleApp';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return CombinedEmbed(
      widgetId: 'counter',
      width: double.tryParse(attributes['width'] ?? '') ?? 400,
      height: double.tryParse(attributes['height'] ?? '') ?? 300,
    );
  }
}

class EmbeddedUpdaterOverlayMarkdown extends CustomComponentBase {
  @override
  final Pattern pattern = RegExp('UpdaterOverlay', caseSensitive: false);

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return CombinedEmbed(
      widgetId: 'overlay',
      overlayTitle: attributes['title'] ?? 'Update Available',
      overlayMessage: attributes['message'] ?? 'A new version is ready.',
      overlayActionLabel: attributes['actionLabel'] ?? attributes['actionlabel'] ?? 'Update',
      width: double.tryParse(attributes['width'] ?? '') ?? 375,
      height: double.tryParse(attributes['height'] ?? '') ?? 812,
    );
  }
}

// ─── Shared queue so addView calls are serialised ────────────────────────────

/// A page-level counter that keeps track of how many CombinedEmbed widgets
/// have finished mounting, so each one waits for the previous to become ready.
final _renderQueue = _EmbedQueue();

class _EmbedQueue {
  /// Current slot number (next widget to mount gets this).
  int _next = 0;

  /// Completers for each slot, resolved when a previous widget is ready.
  final _completers = <int, Completer<void>>{};

  /// Called by widget N when it is ready.  Unblocks widget N+1.
  void notifyReady(int slot) {
    _completers[slot + 1]?.complete();
  }

  /// Returns a future that completes when slot [slot] may mount.
  /// Slot 0 always completes immediately.
  Future<void> waitForSlot(int slot) {
    if (slot == 0) return Future.value();
    final c = _completers.putIfAbsent(slot, () => Completer<void>());
    return c.future;
  }

  int reserveSlot() => _next++;

  void reset() {
    _next = 0;
    _completers.clear();
  }
}

// ─── The single client component used for every Flutter embed ─────────────────

@client
class CombinedEmbed extends StatefulComponent {
  const CombinedEmbed({
    required this.widgetId,
    this.overlayTitle,
    this.overlayMessage,
    this.overlayActionLabel,
    this.width = 400,
    this.height = 300,
    super.key,
  });

  final String widgetId;
  final String? overlayTitle;
  final String? overlayMessage;
  final String? overlayActionLabel;
  final double width;
  final double height;

  @override
  State<CombinedEmbed> createState() => _CombinedEmbedState();

  @css
  static List<StyleRule> get styles => [
    css('.overlay-view').styles(
      position: Position.absolute(top: 0.px, left: 0.px),
      zIndex: ZIndex(10),
      width: 100.percent,
      height: 100.percent,
    ),
  ];
}

class _CombinedEmbedState extends State<CombinedEmbed> {
  late final int _slot;
  bool _ready = false; // true once our slot's turn has come

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _slot = _renderQueue.reserveSlot();
      _renderQueue.waitForSlot(_slot).then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
      });
    } else {
      // On the server, render the loader placeholder immediately.
      _slot = 0;
      _ready = false;
    }
  }

  void _onFlutterViewReady() {
    // Tell the next widget it may now mount.
    _renderQueue.notifyReady(_slot);
  }

  bool get _isOverlay => component.widgetId == 'overlay';

  @override
  Component build(BuildContext context) {
    ThemeMode themeMode = _isOverlay ? context.watch(themeProvider) : ThemeMode.light;
    bool isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.auto => kIsWeb ? web.window.matchMedia('(prefers-color-scheme: dark)').matches : true,
    };

    if (_isOverlay) {
      // Phone-shell wrapper for the overlay
      return div(
        classes:
            'relative flex justify-center my-8 mx-auto overflow-hidden rounded-[2.5rem] border-[8px] border-slate-900 shadow-2xl bg-white dark:bg-slate-950',
        styles: Styles(width: component.width.px, height: component.height.px),
        [
          if (!_ready)
            _spinner()
          else
            _SequentialFlutterEmbed(
              id: 'flutter-embed-overlay-${component.hashCode}',
              classes: 'overlay-view',
              widgetId: component.widgetId,
              overlayTitle: component.overlayTitle,
              overlayMessage: component.overlayMessage,
              overlayActionLabel: component.overlayActionLabel,
              isDark: isDark,
              width: component.width,
              height: component.height,
              onReady: _onFlutterViewReady,
            ),
        ],
      );
    } else {
      // Plain centered wrapper for the counter
      return div(
        classes: 'flex justify-center my-8',
        [
          if (!_ready)
            _loader(component.width, component.height)
          else
            _SequentialFlutterEmbed(
              id: 'flutter-embed-counter-${component.hashCode}',
              widgetId: component.widgetId,
              isDark: isDark,
              width: component.width,
              height: component.height,
              onReady: _onFlutterViewReady,
            ),
        ],
      );
    }
  }

  Component _spinner() {
    return div(
      classes: 'absolute inset-0 flex items-center justify-center bg-white/50 dark:bg-black/50 backdrop-blur-sm',
      [
        div(classes: 'flex flex-col items-center gap-3', [
          div(
            classes: 'w-7 h-7 rounded-full border-2 border-zinc-700 border-t-violet-500 animate-spin',
            [],
          ),
          span(
            classes: 'text-zinc-600 text-[10px] font-mono tracking-wider',
            [Component.text('Loading preview…')],
          ),
        ]),
      ],
    );
  }

  Component _loader(double w, double h) {
    return div(
      classes:
          'flex items-center justify-center border border-slate-200 dark:border-slate-800 rounded-xl bg-slate-50 dark:bg-slate-900',
      styles: Styles(width: w.px, height: h.px),
      [
        div(classes: 'flex flex-col items-center gap-3', [
          div(
            classes: 'w-8 h-8 rounded-full border-2 border-slate-300 border-t-purple-500 animate-spin',
            [],
          ),
          span(
            classes: 'text-slate-500 text-xs font-medium',
            [Component.text('Initializing Flutter…')],
          ),
        ]),
      ],
    );
  }
}

// ─── Inner component — wraps FlutterEmbedView + fires onReady ──────────────

class _SequentialFlutterEmbed extends StatelessComponent {
  _SequentialFlutterEmbed({
    required this.widgetId,
    required this.width,
    required this.height,
    required this.isDark,
    required void Function() onReady,
    this.id,
    this.classes,
    this.overlayTitle,
    this.overlayMessage,
    this.overlayActionLabel,
  }) : // Build the loadLibrary future once; fire onReady exactly once.
       _loadFuture = combined_lib.loadLibrary().then((_) => onReady());

  final String widgetId;
  final double width;
  final double height;
  final bool isDark;
  final String? id;
  final String? classes;
  final String? overlayTitle;
  final String? overlayMessage;
  final String? overlayActionLabel;
  final Future<void> _loadFuture;

  @override
  Component build(BuildContext context) {
    return FlutterEmbedView.deferred(
      id: id,
      classes: classes,
      constraints: ViewConstraints(
        minWidth: width,
        minHeight: height,
        maxWidth: width,
        maxHeight: height,
      ),
      loadLibrary: _loadFuture,
      builder: () => combined_lib.CombinedFlutterApp(
        widgetId: widgetId,
        overlayTitle: overlayTitle,
        overlayMessage: overlayMessage,
        overlayActionLabel: overlayActionLabel,
        isDark: isDark,
      ),
    );
  }
}
