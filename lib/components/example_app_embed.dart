import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';
import 'package:jaspr_content/jaspr_content.dart';

@Import.onWeb('../widgets/example_counter.dart', show: [#ExampleCounter])
import 'example_app_embed.imports.dart' deferred as flutter_counter;

class ExampleAppEmbedMarkdown extends CustomComponentBase {
  @override
  final Pattern pattern = 'ExampleApp';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return ExampleAppEmbed(
      width: double.tryParse(attributes['width'] ?? '') ?? 400,
      height: double.tryParse(attributes['height'] ?? '') ?? 300,
    );
  }
}

@client
class ExampleAppEmbed extends StatelessComponent {
  const ExampleAppEmbed({
    this.width = 400,
    this.height = 300,
    super.key,
  });

  final double width;
  final double height;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex justify-center my-8',
      [
        FlutterEmbedView.deferred(
          id: 'flutter-embed-example-counter-$hashCode',
          constraints: ViewConstraints(
            minWidth: width,
            minHeight: height,
            maxWidth: width,
            maxHeight: height,
          ),
          loadLibrary: flutter_counter.loadLibrary(),
          loader: div(
            classes:
                'flex items-center justify-center border border-slate-200 dark:border-slate-800 rounded-xl bg-slate-50 dark:bg-slate-900',
            styles: Styles(
              width: width.px,
              height: height.px,
            ),
            [
              div(classes: 'flex flex-col items-center gap-3', [
                div(
                  classes: 'w-8 h-8 rounded-full border-2 border-slate-300 border-t-purple-500 animate-spin',
                  [],
                ),
                span(
                  classes: 'text-slate-500 text-xs font-medium',
                  [Component.text('Initializing Flutter…')],
                ),
              ]),
            ],
          ),
          builder: () => flutter_counter.ExampleCounter(),
        ),
      ],
    );
  }
}
