import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

class HomeLayout extends PageLayoutBase {
  const HomeLayout({this.header, this.footer});

  final Component? header;
  final Component? footer;

  @override
  String get name => 'home';

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page);
    yield link(href: 'https://fonts.googleapis.com', rel: 'preconnect');
    yield link(href: 'https://fonts.gstatic.com', rel: 'preconnect', attributes: {'crossorigin': ''});
    yield link(
      href:
          'https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Fira+Code:wght@400;500;600&display=swap',
      rel: 'stylesheet',
    );
    yield link(href: '/styles.css', rel: 'stylesheet');
    yield Style(styles: _styles);
  }

  @override
  Component buildBody(Page page, Component child) {
    return div(classes: 'home-layout', [
      if (header case final header?) header,
      main_([
        div(classes: 'home-content', [
          child,
        ]),
      ]),
      if (footer case final footer?) footer,
    ]);
  }

  static List<StyleRule> get _styles => [
    css('.home-layout', [
      css('&').styles(
        minHeight: 100.vh,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        backgroundColor: Color('hsl(var(--background))'),
        raw: {
          'overflow-x': 'hidden',
        },
      ),
      css('main', [
        css('&').styles(
          flex: Flex(grow: 1, shrink: 0, basis: Unit.auto),
          display: Display.flex,
          flexDirection: FlexDirection.column,
          padding: Padding.only(top: 4.rem), // Account for fixed header
        ),
      ]),
      css('.home-content', [
        css('&').styles(
          width: 100.percent,
          maxWidth: 1200.px,
          margin: Margin.symmetric(horizontal: Unit.auto),
          padding: Padding.symmetric(horizontal: 1.5.rem),
        ),
      ]),
    ]),
  ];
}
