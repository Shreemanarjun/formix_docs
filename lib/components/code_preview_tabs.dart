import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/components/tabs.dart';

class CodePreviewTabsMarkdown extends CustomComponentBase {
  @override
  final Pattern pattern = RegExp('CodePreviewTabs', caseSensitive: false);

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    if (child == null) return Component.empty();
    return Tabs.from(
      defaultValue: attributes['defaultValue'] ?? 'preview',
      items: [],
    );
  }

  @override
  Component? create(Node node, NodesBuilder builder) {
    // We must match case-insensitively since HTML parsers often lowercase tags
    if (node is ElementNode && node.tag.toLowerCase() == 'codepreviewtabs') {
      final tabs =
          node.children?.whereType<ElementNode>().where((n) {
            final tag = n.tag.toLowerCase();
            return tag == 'previewtab' || tag == 'codetab';
          }) ??
          [];

      return div(classes: 'code-preview-tabs-wrapper', [
        Style(
          styles: [
            css('.code-preview-tabs-wrapper .tab-view:not([active])', [
              css('&').styles(
                display: Display.block,
                position: Position.absolute(top: (-9999).px),
                visibility: Visibility.hidden,
              ),
            ]),
            css('.code-preview-tabs-wrapper .tab-view[active]', [
              css('&').styles(
                display: Display.block,
                position: Position.static,
                visibility: Visibility.visible,
              ),
            ]),
          ],
        ),
        Tabs.from(
          defaultValue: node.attributes['defaultValue'] ?? 'preview',
          items: [
            for (final tab in tabs)
              TabItem(
                label: tab.attributes['label'] ?? (tab.tag.toLowerCase() == 'previewtab' ? 'Preview' : 'Code'),
                value: tab.tag.toLowerCase() == 'previewtab' ? 'preview' : 'code',
                child: builder.build(tab.children),
              ),
          ],
        ),
      ]);
    }
    return null;
  }
}
