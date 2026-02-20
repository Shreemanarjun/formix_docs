---
title: "Formix — Elite Form Engine for Flutter"
description: "Formix is a type-safe, ultra-reactive form engine for Flutter, powered by Riverpod. Lightning-fast performance, zero boilerplate, effortless state management."
---

# Formix 🚀

**An elite, type-safe, and ultra-reactive form engine for Flutter.**

Powered by [Riverpod](https://riverpod.dev), Formix delivers lightning-fast performance, zero boilerplate, and effortless state management. Whether it's a simple login screen or a complex multi-step wizard, Formix scales with you.

[![pub.dev](https://img.shields.io/pub/v/formix.svg)]({{links.pub}})
[![License](https://img.shields.io/badge/license-MIT-purple.svg)]({{links.github}}/blob/main/LICENSE)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)]({{links.github}}/actions)

---

## Why Formix?

<Info>
Formix was built to solve a core Flutter problem: managing complex form state without drowning in boilerplate. With a Riverpod-first design, your forms become first-class reactive citizens in your app.
</Info>

### ✅ Zero Boilerplate

Define your form fields via `FormixFieldID` + `Formix` widget. Formix handles registration, validation, and state automatically.

### ⚡ Lightning-Fast Reactive Updates

Built on Riverpod's fine-grained reactivity. Fields only rebuild when their own value or validation changes — not the whole form.

### 🔒 100% Type-Safe

`FormixFieldID<T>` carries the Dart type at compile time. Every `getValue`, `setValue`, and validator is checked by the type system.

### 🧩 Headless & Composable

`FormixRawFormField<T>` lets you wrap *any* widget — pickers, selectors, sliders — in the Formix ecosystem with a single builder function.

### 📦 Batteries Included

Undo/redo history, state persistence, form analytics, i18n validation messages, DevTools integration, Navigation Guard, and more — all built in.

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
