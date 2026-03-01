import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';
import 'package:universal_web/web.dart' as web;
import 'package:jaspr_content/jaspr_content.dart';
import '../theme_mode.dart';
import '../providers.dart';

@Import.onWeb('../widgets/updater_overlay.dart', show: [#FlutterUpdaterOverlay])
import 'embedded_updater_overlay.imports.dart' deferred as flutter_overlay;

class EmbeddedUpdaterOverlayMarkdown extends CustomComponentBase {
  @override
  final Pattern pattern = RegExp('UpdaterOverlay', caseSensitive: false);

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return EmbeddedUpdaterOverlay(
      title: attributes['title'] ?? 'Update Available',
      message: attributes['message'] ?? 'A new version is ready.',
      actionLabel: attributes['actionLabel'] ?? attributes['actionlabel'] ?? 'Update',
      width: double.tryParse(attributes['width'] ?? '') ?? 375,
      height: double.tryParse(attributes['height'] ?? '') ?? 812,
    );
  }
}

@client
class EmbeddedUpdaterOverlay extends StatelessComponent {
  const EmbeddedUpdaterOverlay({
    required this.title,
    required this.message,
    required this.actionLabel,
    this.width = 375,
    this.height = 812,
    super.key,
  });

  final String title;
  final String message;
  final String actionLabel;
  final double width;
  final double height;

  @override
  Component build(BuildContext context) {
    ThemeMode themeMode = context.watch(themeProvider);
    bool isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.auto => kIsWeb ? web.window.matchMedia('(prefers-color-scheme: dark)').matches : true,
    };

    return div(
      classes:
          'relative flex justify-center my-8 mx-auto overflow-hidden rounded-[2.5rem] border-[8px] border-slate-900 shadow-2xl bg-white dark:bg-slate-950',
      styles: Styles(
        width: width.px,
        height: height.px,
      ),
      [
        FlutterEmbedView.deferred(
          key: ValueKey('flutter-embed-updater-overlay-$hashCode'),
          id: 'flutter-embed-updater-overlay-$hashCode',
          classes: 'overlay-view',
          constraints: ViewConstraints(
            minWidth: width,
            minHeight: height,
            maxWidth: width,
            maxHeight: height,
          ),
          loadLibrary: flutter_overlay.loadLibrary(),
          // ── Spinner shown while Flutter initialises — transparent bg so
          // the phone skeleton shows through instead of going black
          loader: div(
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
          ),
          builder: () => flutter_overlay.FlutterUpdaterOverlay(
            title: title,
            message: message,
            actionLabel: actionLabel,
            onClose: () {},
            onAction: () {},
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // Position overlay to fill phone shell
    css('.overlay-view').styles(
      position: Position.absolute(top: 0.px, left: 0.px),
      zIndex: ZIndex(10),
      width: 100.percent,
      height: 100.percent,
    ),
  ];
}
