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
    ContentApp(
      // Enables mustache templating inside the markdown files.
      templateEngine: MustacheTemplateEngine(),
      debugPrint: true,
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
        Badge(),
        // Custom tip component for helpful information
        Tip(),
        // Adds zooming and caption support to images.
        CustomImage(zoom: true),
        // Adds support for tabbed content blocks.
        Tabs(),
      ],
      layouts: [
        // Enhanced responsive layout for documentation sites.
        ResponsiveDocsLayout(
          header: CustomHeader(
            title: 'Formix',
            subtitle: "Elite Form Engine for Flutter",
            logo: '/images/formix_logo.svg',
            includeSearch: true,
            navigationItems: [
              // Enables switching between light and dark mode.
              EnhancedThemeToggle(),
              // Shows github stats.
              CachedGitHubButton(
                repo: 'shreemanarjunsahu/formix',
              ),
            ],
          ),
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
                ],
              ),
            ],
          ),
          footer: Builder(
            builder: (context) {
              return div(
                styles: Styles(
                  position: Position.fixed(bottom: 0.px, right: 24.px),
                  padding: Spacing.only(bottom: 24.px),
                  backgroundColor: Color('hsl(var(--background))'),
                  raw: {
                    'transition': 'all 0.3s ease-in-out',
                  },
                ),
                [
                  div(
                    styles: Styles(
                      display: Display.flex,
                      flexDirection: FlexDirection.column,
                      alignItems: AlignItems.end,
                      gap: Gap(row: 8.px),
                    ),
                    [
                      div(
                        styles: Styles(
                          display: Display.flex,
                          padding: Spacing.symmetric(horizontal: 8.px, vertical: 4.px),
                          radius: BorderRadius.all(Radius.circular(12.px)),
                          alignItems: AlignItems.center,
                          gap: Gap(row: 6.px),
                          backgroundColor: Color('hsl(var(--primary) / 0.1)'),
                        ),
                        [
                          span(
                            styles: Styles(
                              color: Color('hsl(var(--primary))'),
                              fontSize: 0.6875.rem,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.025.em,
                            ),
                            [Component.text('v1.0.0')],
                          ),
                          div(
                            styles: Styles(
                              width: 6.px,
                              height: 6.px,
                              radius: BorderRadius.circular(50.percent),
                              backgroundColor: Color('hsl(var(--primary))'),
                            ),
                            [],
                          ),
                        ],
                      ),
                      // Jaspr badge is inside jaspr_content or needs an implementation.
                      // For now, we omit it or implement standard jaspr badge
                    ],
                  ),
                ],
              );
            },
          ),
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
  );
}
