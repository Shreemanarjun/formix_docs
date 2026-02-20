---
title: "Formix — Elite Form Engine for Flutter"
description: "Formix is a type-safe, ultra-reactive form engine for Flutter, powered by Riverpod. Lightning-fast performance, zero boilerplate, effortless state management."
layout: home
---

<Hero title="Elite Form Engine" subtitle="for Flutter" command="flutter pub add formix">
Build type-safe, ultra-reactive forms with Riverpod. Lightning-fast performance, zero boilerplate, effortless state management.
</Hero>

<FeatureGrid>
  <FeatureCard title="⚡️ Zero Boilerplate" desc="Define your form fields via FormixFieldID + Formix widget. Formix handles registration, validation, and state automatically." />
  <FeatureCard title="🚀 Lightning Fast" desc="Built on Riverpod's fine-grained reactivity. Fields only rebuild when their own value or validation changes." />
  <FeatureCard title="🛡️ 100% Type-Safe" desc="FormixFieldID carries the Dart type at compile time. Every getValue or validator is checked by the type system." />
  <FeatureCard title="🧩 Composable" desc="FormixRawFormField lets you wrap any widget — pickers, selectors, sliders — in the Formix ecosystem effortlessly." />
</FeatureGrid>

---

## Quick Look

```dart
// 1. Declare type-safe field IDs (put these in a file near your form)
const emailField    = FormixFieldID<String>('email');
const passwordField = FormixFieldID<String>('password');

// 2. Wrap your page with Formix
Formix(
  fields: [
    FormixFieldConfig(
      id: emailField,
      validator: FormixValidators.string().required().email().build(),
    ),
    FormixFieldConfig(
      id: passwordField,
      validator: FormixValidators.string().required().minLength(8).build(),
    ),
  ],
  child: Column(
    children: [
      // 3. Place built-in field widgets
      FormixTextFormField(fieldId: emailField),
      FormixTextFormField(fieldId: passwordField, obscureText: true),

      // 4. Submit
      ElevatedButton(
        onPressed: () => Formix.controllerOf(context)?.submit(
          onValid: (values) async {
            final email    = values[emailField.key] as String;
            final password = values[passwordField.key] as String;
            await authService.login(email: email, password: password);
          },
        ),
        child: const Text('Login'),
      ),
    ],
  ),
)
```

---

## Installation

Add Formix to your `pubspec.yaml`:

```yaml
dependencies:
  formix: ^1.0.0
  flutter_riverpod: ^2.6.1
```

Then run:

```bash
flutter pub get
```

Wrap your root widget with `ProviderScope`:

```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## What's Next?

- **[Getting Started](/getting-started)** — Installation, `ProviderScope` setup, and your first form in 5 minutes.
- **[Core Concepts](/concepts/overview)** — Understand `Formix`, `FormixFieldID`, `FormixController`, and reactive state.
- **[Validation](/concepts/validation)** — Fluent validator chains, async validators, cross-field rules.
- **[Custom Fields](/concepts/custom-fields)** — Use `FormixRawFormField` to wrap any widget.
- **[API Reference](/api/controller)** — Full API reference for every class and method.
- **[Examples](/examples/login-form)** — Real-world code examples you can copy and adapt.
