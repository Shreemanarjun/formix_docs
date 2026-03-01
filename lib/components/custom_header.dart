import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/sidebar_toggle_button.dart';
import 'package:formix_docs/components/enhanced_theme_toggle.dart';
import 'package:formix_docs/components/search_component.dart';

/// A header component with a logo, title, and navigation bar below.
class CustomHeader extends StatelessComponent {
  const CustomHeader({
    required this.logo,
    required this.title,
    this.subtitle,
    this.version = '1.0.3',
    this.leading = const [SidebarToggleButton()],
    this.items = const [],
    this.navigationItems = const [],
    this.includeSearch = false,
    super.key,
  });

  /// The src href to render as the site logo.
  final String logo;

  /// The name of the site to render alongside the [logo].
  final String title;

  /// An optional subtitle to render below the [title].
  final String? subtitle;

  /// The current version of the package.
  final String version;

  /// Components to render before the site logo and title.
  ///
  /// If not specified, defaults to a [SidebarToggleButton].
  final List<Component> leading;

  /// Other components to render in the header, such as site section links.
  final List<Component> items;

  /// Components to render in the navigation bar below the header.
  final List<Component> navigationItems;

  /// Whether to include the search component in the navigation bar.
  final bool includeSearch;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(
        children: [
          // Algolia site verification
          meta(
            name: 'algolia-site-verification',
            content: 'A6639029AF6B0912',
          ),
          Style(
            styles: [
              css('body').styles(
                raw: {'padding-bottom': '80px'},
              ),
            ],
          ),
          script(src: 'flutter_bootstrap.js', async: true),
          ThemeScript(),
        ],
      ),
      // Single row header with responsive Tailwind classes
      header(
        classes:
            'sticky top-0 z-50 w-full border-b border-slate-200/60 dark:border-slate-800/60 bg-white/80 dark:bg-slate-950/80 backdrop-blur-xl transition-colors duration-300',
        [
          div(classes: 'flex h-16 items-center justify-between px-4 sm:px-6 lg:px-8 max-w-screen-2xl mx-auto', [
            // Left side: Logo and title
            div(classes: 'flex items-center gap-3 md:gap-4', [
              if (leading.isNotEmpty)
                div(
                  classes:
                      'flex lg:hidden items-center text-slate-500 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white transition-colors',
                  leading,
                ),

              a(classes: 'flex items-center gap-3 transition-opacity hover:opacity-80 no-underline', href: '/', [
                img(src: logo, alt: '$title Logo', classes: 'h-16 sm:h-9 w-auto object-contain'),
                div(classes: 'flex flex-col justify-center', [
                  div(classes: 'flex items-center gap-2', [
                    span(
                      classes:
                          'font-bold text-lg sm:text-xl leading-none tracking-tight text-slate-900 dark:text-white',
                      [Component.text(title)],
                    ),
                    span(
                      classes:
                          'hidden sm:inline-flex items-center justify-center rounded-md bg-purple-100 dark:bg-purple-900/30 px-1.5 py-0.5 text-[0.65rem] font-semibold text-purple-700 dark:text-purple-300 uppercase tracking-widest leading-none border border-purple-200 dark:border-purple-800/50',
                      [Component.text('v$version')],
                    ),
                  ]),
                  if (subtitle != null)
                    span(classes: 'hidden md:block text-xs text-slate-500 dark:text-slate-400 font-medium mt-0.5', [
                      Component.text(subtitle!),
                    ]),
                ]),
              ]),
            ]),

            // Center: Search (if enabled)
            if (includeSearch)
              div(classes: 'hidden md:flex flex-1 max-w-sm mx-6', [
                div(classes: 'w-full header-search-wrapper', [
                  AlgoliaDocSearch.datum(),
                ]),
              ]),

            // Right side: Actions and items
            div(classes: 'flex items-center gap-3 sm:gap-5', [
              if (items.isNotEmpty)
                nav(
                  classes: 'hidden lg:flex items-center gap-6 text-sm font-medium text-slate-600 dark:text-slate-300',
                  [
                    ...items.map(
                      (item) =>
                          div(classes: 'hover:text-purple-600 dark:hover:text-purple-400 transition-colors', [item]),
                    ),
                  ],
                ),

              if (navigationItems.isNotEmpty)
                div(
                  classes: 'flex items-center gap-2 sm:gap-3 pl-1 sm:pl-2',
                  [
                    ...navigationItems,
                  ],
                ),
            ]),
          ]),
        ],
      ),
    ]);
  }
}
