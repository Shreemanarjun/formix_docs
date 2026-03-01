---
title: "Flutter Embedding"
description: "Learn how to embed Flutter widgets and apps inside your Jaspr documentation."
---

# Flutter Embedding

Formix documentation uses `jaspr_flutter_embed` to provide interactive examples directly in the browser.

## Interactive Counter Example

Below is a Flutter counter widget embedded directly into this page. This is not an iframe, but a Flutter widget rendered into a specific element in the Jaspr application.

<ExampleApp width="400" height="300" />

## How it works

1. **Define your Flutter widget** in a separate file (e.g., `lib/widgets/example_counter.dart`).
2. **Create a Jaspr component** that uses `FlutterEmbedView.deferred`.
3. **Register the component** in your `ContentApp`.
4. **Use the custom tag** in your markdown files.

```dart
// In your Jaspr component
@Import.onWeb('../widgets/example_counter.dart', show: [#ExampleCounter])
import 'example_app_embed.imports.dart' deferred as flutter_counter;

// ...
FlutterEmbedView.deferred(
  loadLibrary: flutter_counter.loadLibrary(),
  builder: () => flutter_counter.ExampleCounter(),
)
```

## Check Visibility

The example above should be visible and interactive. If you see the "Initializing Flutter..." message for too long, make sure your Flutter environment is correctly set up for web.

<Info>
  This feature is extremely useful for demonstrating complex UI components or interactive playgounds without leaving the documentation.
</Info>
