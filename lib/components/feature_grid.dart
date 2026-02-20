import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// Features Grid inspired by Nitro website.
///
/// Usage in markdown:
/// ```
/// <FeatureGrid>
///   <FeatureCard title="⚡️ Lightning Fast" desc="Rebuilds only exactly what changed." />
///   <FeatureCard title="🛡️ 100% Type-Safe" desc="Compile-time safety with FormixFieldID." />
///   <FeatureCard title="🧩 Composable" desc="Wrap any widget with headless Formix UI." />
///   <FeatureGrid title="🌊 Riverpod Native" desc="Built seamlessly on top of Riverpod." />
/// </FeatureGrid>
/// ```
class FeatureGrid extends CustomComponentBase {
  FeatureGrid();

  @override
  final Pattern pattern = RegExp(r'FeatureGrid|FeatureCard');

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    if (name == 'FeatureGrid') {
      return _FeatureGridComponent(child: child);
    } else if (name == 'FeatureCard') {
      return _FeatureCardComponent(
        title: attributes['title'] ?? 'Title',
        desc: attributes['desc'] ?? 'Description',
      );
    }
    return Component.text('');
  }
}

class _FeatureGridComponent extends StatelessComponent {
  const _FeatureGridComponent({required this.child});
  final Component? child;

  @override
  Component build(BuildContext context) {
    return div(classes: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 my-16 w-full max-w-7xl', [
      if (child != null) child!,
    ]);
  }
}

class _FeatureCardComponent extends StatelessComponent {
  const _FeatureCardComponent({required this.title, required this.desc});
  final String title;
  final String desc;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'group relative p-7 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200/50 dark:border-slate-800/50 shadow-sm transition-all duration-300 hover:-translate-y-1 hover:border-purple-500/30 hover:shadow-[0_10px_30px_-10px_rgba(168,85,247,0.2)] dark:hover:shadow-[0_10px_30px_-10px_rgba(168,85,247,0.1)] overflow-hidden flex flex-col',
      [
        // Glow line at the top, visible on hover
        div(
          classes:
              'absolute top-0 left-0 right-0 h-[2px] bg-gradient-to-r from-transparent via-purple-500 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100',
          [],
        ),
        h3(classes: 'text-xl font-bold text-slate-900 dark:text-white mb-3 tracking-tight', [Component.text(title)]),
        p(classes: 'text-slate-600 dark:text-slate-400 text-base leading-relaxed', [Component.text(desc)]),
      ],
    );
  }
}
