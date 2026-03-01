// The entrypoint for the **server** environment.
//
// The [main] method will only be executed on the server during pre-rendering.
// To run code on the client, use the @client annotation.

// Server-specific jaspr import.
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/components/tabs.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

// Custom components from datum_docs adapted for formix_docs
import 'components/code_block.dart';
import 'components/steps.dart';
import 'components/card.dart';
import 'components/badge.dart';
import 'components/tip.dart';
import 'components/custom_header.dart';
import 'components/custom_image.dart';
import 'components/responsive_docs_layout.dart';
import 'components/enhanced_theme_toggle.dart';
import 'components/cached_github_button.dart';
import 'components/hero.dart';
import 'components/feature_grid.dart';
import 'components/home_layout.dart';
import 'components/jaspr_badge.dart';
import 'components/embedded_updater_overlay.dart';
import 'components/example_app_embed.dart';
import 'page_extensions.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [ContentApp] spins up the content rendering pipeline from jaspr_content to render
  // your markdown files in the content/ directory to a beautiful documentation site.
  runApp(
    ProviderScope(
      child: ContentApp(
        // Enables mustache templating inside the markdown files.
        templateEngine: MustacheTemplateEngine(),
        debugPrint: true,
        eagerlyLoadAllPages: true,
        parsers: [
          MarkdownParser(),
          HtmlParser(),
        ],
        extensions: [
          // Adds heading anchors to each heading.
          HeadingAnchorsExtension(),
          // Generates a table of contents for each page.
          TableOfContentsExtension(),
          // Estimates reading time based on word count.
          ReadingTimeExtension(),
          // Adds SEO enhancements like meta tags and structured data.
          SEOEnhancementsExtension(),
          // Adds last modified date based on file modification time.
          LastModifiedExtension(),
          // Generates breadcrumb navigation data.
          BreadcrumbExtension(),
          // Generates previous/next page navigation (basic implementation).
          PageNavigationExtension(),
        ],
        components: [
          // Callouts: <Info>, <Warning>, <Tip>, <Danger>
          Callout(),
          // Adds syntax highlighting to code blocks.
          CodeBlock(
            defaultLanguage: 'dart',
            grammars: {},
          ),
          // Step-by-step instructions component
          Steps(),
          // Card component for highlighting content
          Card(),
          // Badge component for status indicators
          FormixBadge(),
          // Custom tip component for helpful information
          Tip(),
          // Adds zooming and caption support to images.
          CustomImage(zoom: true),
          // Adds support for tabbed content blocks.
          Tabs(),
          // Visual Nitro-inspired UI components
          Hero(),
          FeatureGrid(),
          JasprBadgeMarkdown(),
          EmbeddedUpdaterOverlayMarkdown(),
          ExampleAppEmbedMarkdown(),
        ],
        layouts: [
          // Enhanced responsive layout for documentation sites. (Default layout)
          ResponsiveDocsLayout(
            header: _buildHeader(),
            sidebar: Sidebar(
              groups: [
                SidebarGroup(
                  links: [
                    SidebarLink(text: 'Introduction', href: '/'),
                    SidebarLink(text: 'Getting Started', href: '/getting-started'),
                  ],
                ),
                SidebarGroup(
                  title: 'Concepts',
                  links: [
                    SidebarLink(text: 'Overview', href: '/concepts/overview'),
                    SidebarLink(text: 'Validation', href: '/concepts/validation'),
                    SidebarLink(text: 'Custom Fields', href: '/concepts/custom-fields'),
                    SidebarLink(text: 'Multi-Step Forms', href: '/concepts/multi-step'),
                  ],
                ),
                SidebarGroup(
                  title: 'API Reference',
                  links: [
                    SidebarLink(text: 'FormixController', href: '/api/controller'),
                    SidebarLink(text: 'FormixField', href: '/api/field'),
                    SidebarLink(text: 'FormixFieldID', href: '/api/field-id'),
                    SidebarLink(text: 'FormixData (State)', href: '/api/form-state'),
                    SidebarLink(text: 'FormixValidators', href: '/api/validators'),
                    SidebarLink(text: 'FormixRawFormField', href: '/api/raw-form-field'),
                  ],
                ),
                SidebarGroup(
                  title: 'Examples',
                  links: [
                    SidebarLink(text: 'Login Form', href: '/examples/login-form'),
                    SidebarLink(text: 'Registration Form', href: '/examples/registration-form'),
                    SidebarLink(text: 'Dynamic Array', href: '/examples/dynamic-array'),
                    SidebarLink(text: 'Flutter Embedding', href: '/examples/flutter-embed'),
                  ],
                ),
              ],
            ),
            footer: _buildFooter(),
          ),
          // Home layout for the landing page without the docs sidebar.
          HomeLayout(
            header: _buildHeader(),
            footer: _buildFooter(),
          ),
        ],
        theme: ContentTheme(
          // Formix brand: purple.
          primary: ThemeColor(ThemeColors.purple.$600, dark: ThemeColors.purple.$400),
          background: ThemeColor(ThemeColors.slate.$50, dark: ThemeColors.zinc.$950),
          colors: [
            ContentColors.quoteBorders.apply(ThemeColors.purple.$400),
            ContentColors.preBg.apply(
              ThemeColor(ThemeColors.slate.$800, dark: ThemeColors.slate.$800),
            ),
          ],
        ),
      ),
    ),
  );
}

Component _buildHeader() {
  return CustomHeader(
    title: 'Formix',
    subtitle: "Elite Form Engine for Flutter",
    logo: '/images/formix_logo.svg',
    includeSearch: true,
    navigationItems: [
      EnhancedThemeToggle(),
      CachedGitHubButton(repo: 'shreemanarjun/formix'),
    ],
  );
}

Component _buildFooter() {
  return Builder(
    builder: (context) {
      return footer(
        classes: 'w-full py-12 border-t border-slate-200/60 dark:border-slate-800/60 mt-20',
        [
          div(classes: 'max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8', [
            div(classes: 'flex flex-col md:flex-row items-center justify-between gap-6', [
              // Left side: Version and Badge
              div(classes: 'flex flex-col items-center md:items-start gap-4', [
                div(
                  classes:
                      'inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-500/10 border border-purple-500/20 text-purple-600 dark:text-purple-400 text-xs font-bold tracking-tight',
                  [
                    span([Component.text('v1.0.3')]),
                    div(classes: 'w-1 h-1 rounded-full bg-purple-500', []),
                    span([Component.text('Latest Release')]),
                  ],
                ),
                div(classes: 'flex items-center gap-2', [
                  const BuiltWithJasprBadge.darkTwoTone(),
                ]),
              ]),

              // Center/Right: Copyright and Credits
              div(classes: 'flex flex-col items-center md:items-end gap-2 text-sm text-slate-500 dark:text-slate-400', [
                p(classes: 'font-medium', [
                  Component.text('© 2026 Shreeman Arjun Sahu. All rights reserved.'),
                ]),
                p(classes: 'flex items-center gap-1.5', [
                  Component.text('Made with '),
                  span(classes: 'text-red-500 animate-pulse', [Component.text('❤️')]),
                  Component.text(' and '),
                  a(
                    href: 'https://jaspr.site',
                    classes: 'text-slate-900 dark:text-white font-semibold hover:text-purple-600 transition-colors',
                    [Component.text('Jaspr')],
                  ),
                ]),
              ]),
            ]),
          ]),
        ],
      );
    },
  );
}
