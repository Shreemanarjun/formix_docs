// The entrypoint for the **server** environment.
//
// The [main] method will only be executed on the server during pre-rendering.
// To run code on the client, use the @client annotation.

// Server-specific jaspr import.
import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/github_button.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

// Custom components
import 'components/code_block.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // [ContentApp] spins up the content rendering pipeline from jaspr_content to render
  // markdown files in the content/ directory to a beautiful documentation site.
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
      ],
      components: [
        // Callouts: <Info>, <Warning>, <Tip>, <Danger>
        Callout(),
        // Syntax highlighting with graceful fallback for non-dart languages.
        CodeBlock(
          defaultLanguage: 'dart',
          grammars: {},
        ),
        // Zooming and caption support for images.
        Image(zoom: true),
      ],
      layouts: [
        DocsLayout(
          header: Header(
            title: 'Formix',
            logo: '/images/formix_logo.svg',
            items: [
              // Light / dark mode toggle.
              ThemeToggle(),
              // GitHub star button.
              GitHubButton(repo: 'shreemanarjunsahu/formix'),
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
