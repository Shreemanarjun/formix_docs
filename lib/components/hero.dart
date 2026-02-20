import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// A spectacular hero component inspired by Nitro (nitro.margelo.com)
///
/// Usage in markdown:
/// ```
/// <Hero title="Elite Form Engine" subtitle="for Flutter" command="flutter pub add formix">
/// Build type-safe, ultra-reactive forms with Riverpod. Lightning-fast performance, zero boilerplate.
/// </Hero>
/// ```
class Hero extends CustomComponentBase {
  Hero();

  @override
  final Pattern pattern = 'Hero';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return _HeroComponent(
      title: attributes['title'] ?? 'Elite Form Engine',
      subtitle: attributes['subtitle'] ?? 'for Flutter',
      command: attributes['command'],
      child: child,
    );
  }
}

class _HeroComponent extends StatelessComponent {
  const _HeroComponent({
    required this.title,
    required this.subtitle,
    this.command,
    this.child,
  });

  final String title;
  final String subtitle;
  final String? command;
  final Component? child;

  @override
  Component build(BuildContext context) {
    return div(classes: 'relative flex flex-col items-center text-center py-32 mb-16 px-4', [
      // Background glow effect
      div(
        classes:
            'absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[90vw] h-[90vw] max-w-[1000px] max-h-[1000px] bg-purple-500/20 rounded-full blur-[80px] -z-10 pointer-events-none',
        [],
      ),

      div(
        classes:
            'inline-flex items-center px-4 py-2 rounded-full mb-8 border border-purple-500/30 bg-purple-500/10 text-purple-700 dark:text-purple-400 text-sm font-semibold tracking-wide backdrop-blur-md shadow-sm',
        [
          span([Component.text('v1.0.3 is out now 🚀')]),
        ],
      ),

      h1(
        classes: 'text-slate-900 dark:text-white text-6xl md:text-8xl font-black leading-tight tracking-tighter mb-6',
        [
          span(classes: 'text-transparent bg-clip-text bg-gradient-to-r from-purple-600 to-pink-500', [
            Component.text('Formix '),
          ]),
          br(classes: 'hidden md:block'),
          Component.text(title),
        ],
      ),

      if (child != null)
        p(
          classes:
              'text-slate-600 dark:text-slate-400 text-xl md:text-2xl mb-12 max-w-[750px] leading-relaxed font-medium',
          [
            child!,
          ],
        ),

      if (command != null)
        div(
          classes:
              'group relative flex items-center justify-between w-full max-w-[500px] bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 pl-5 pr-2 py-2 rounded-xl mb-12 font-mono shadow-sm transition-all hover:shadow-md hover:border-slate-300 dark:hover:border-slate-700',
          [
            div(classes: 'flex items-center gap-3 overflow-x-auto', [
              span(
                classes: 'text-purple-500 dark:text-purple-400 select-none font-bold',
                [Component.text(r'$')],
              ),
              code(classes: 'text-slate-700 dark:text-slate-300 text-sm md:text-base font-semibold whitespace-nowrap', [
                Component.text(command!),
              ]),
            ]),
            button(
              classes:
                  'flex items-center justify-center ml-4 px-3 py-2 rounded-lg transition-all bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 cursor-pointer border-none',
              attributes: {
                'onclick':
                    "navigator.clipboard.writeText('$command'); const el = this.querySelector('span'); const orig = el.innerText; el.innerText = 'Copied!'; setTimeout(() => el.innerText = orig, 2000);",
                'title': 'Copy to clipboard',
              },
              [
                span(classes: 'text-xs font-bold uppercase tracking-wider', [Component.text('Copy')]),
              ],
            ),
          ],
        ),

      div(classes: 'flex gap-5 flex-wrap justify-center', [
        a(
          href: '/getting-started',
          classes:
              'inline-flex items-center px-8 py-4 bg-purple-600 text-white rounded-xl text-lg font-semibold no-underline transition-all hover:-translate-y-1 hover:shadow-xl hover:shadow-purple-500/40 hover:bg-purple-500',
          [
            Component.text('Get Started →'),
          ],
        ),
        a(
          href: 'https://github.com/shreemanarjun/formix',
          classes:
              'inline-flex items-center px-8 py-4 bg-white/50 dark:bg-slate-900/50 backdrop-blur-sm text-slate-900 dark:text-white border border-slate-200 dark:border-slate-800 rounded-xl text-lg font-semibold no-underline transition-all hover:bg-slate-50 dark:hover:bg-slate-800 hover:-translate-y-1 hover:shadow-md',
          [
            Component.text('GitHub'),
          ],
        ),
      ]),
    ]);
  }
}
