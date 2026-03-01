import 'package:flutter/material.dart';
import 'example_counter.dart';
import 'updater_overlay.dart';

/// A Flutter widget that can render either the ExampleCounter widget,
/// or the FlutterUpdaterOverlay widget, chosen by an ID.
///
/// This is used to work around the jaspr_flutter_embed limitation where
/// multiple FlutterEmbedView instances on the same page race on addView().
class CombinedFlutterApp extends StatefulWidget {
  const CombinedFlutterApp({
    required this.widgetId,
    this.overlayTitle,
    this.overlayMessage,
    this.overlayActionLabel,
    this.isDark = false,
    super.key,
  });

  /// 'counter' → ExampleCounter, 'overlay' → FlutterUpdaterOverlay
  final String widgetId;
  final String? overlayTitle;
  final String? overlayMessage;
  final String? overlayActionLabel;
  final bool isDark;

  @override
  State<CombinedFlutterApp> createState() => _CombinedFlutterAppState();
}

class _CombinedFlutterAppState extends State<CombinedFlutterApp> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData.fromView(View.of(context)),
        child: switch (widget.widgetId) {
          'overlay' => FlutterUpdaterOverlay(
            title: widget.overlayTitle ?? 'Update Available',
            message: widget.overlayMessage ?? 'A new version is ready.',
            actionLabel: widget.overlayActionLabel ?? 'Update',
            onClose: () {},
            onAction: () {},
            isDark: widget.isDark,
          ),
          _ => const ExampleCounter(),
        },
      ),
    );
  }
}
