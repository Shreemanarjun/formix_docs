---
title: "Getting Started with Formix"
description: "Learn how to install Formix, configure Riverpod, and build your first reactive Flutter form in minutes."
---



## Prerequisites

- Flutter **3.19+**
- Dart **3.3+**
- An existing Flutter project (or `flutter create my_app`)

## Installation

Add Formix and Riverpod to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  formix: ^1.0.0
  flutter_riverpod: ^2.6.1
```

Run the package resolver:

```bash
flutter pub get
```

## Setup: ProviderScope

Formix is powered by Riverpod. Wrap your root widget with `ProviderScope` — if you already use Riverpod, skip this step:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

<Info>
Formix will show a helpful `FormixConfigurationErrorWidget` in debug builds if it detects a missing `ProviderScope`, making setup errors easy to spot.
</Info>

## Your First Form

Let's build a complete login form step-by-step.

### Step 1: Declare Your Field IDs

`FormixFieldID<T>` is the cornerstone of Formix's type safety. Define them once, near your form:

```dart
// login_fields.dart
import 'package:formix/formix.dart';

const emailField    = FormixFieldID<String>('email');
const passwordField = FormixFieldID<String>('password');
```

The type parameter `<String>` ensures every call to `getValue`, `setValue`, or `validator` is type-checked at compile time.

### Step 2: Create the Form with Formix Widget

`Formix` is the root widget that manages state and provides the `FormixController` to descendant widgets:

```dart
import 'package:flutter/material.dart';
import 'package:formix/formix.dart';
import 'login_fields.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Formix(
        // Declare field configurations in-line
        fields: [
          FormixFieldConfig(
            id: emailField,
            label: 'Email Address',
            validator: FormixValidators.string()
                .required()
                .email()
                .build(),
          ),
          FormixFieldConfig(
            id: passwordField,
            label: 'Password',
            validator: FormixValidators.string()
                .required()
                .minLength(8)
                .build(),
          ),
        ],
        autovalidateMode: FormixAutovalidateMode.onUserInteraction,
        child: const _LoginFormBody(),
      ),
    );
  }
}
```

### Step 3: Build the Form Body

Use `FormixTextFormField` to create text fields that automatically connect to the controller:

```dart
class _LoginFormBody extends StatelessWidget {
  const _LoginFormBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormixTextFormField(
            fieldId: emailField,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          FormixTextFormField(
            fieldId: passwordField,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Formix.controllerOf(context)?.submit(
                onValid: (values) async {
                  final email    = values[emailField.key]    as String;
                  final password = values[passwordField.key] as String;
                  await authService.login(email: email, password: password);
                },
                onError: (errors) {
                  // errors is Map<String, ValidationResult>
                  // validation errors are already shown inline by the field widgets
                },
                autoFocusOnInvalid: true, // auto-scrolls to first error
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Step 4: Run Your App

```bash
flutter run
```

You now have a fully reactive form with:
- ✅ Inline, real-time validation
- ✅ Type-safe value access
- ✅ Automatic loading state on submission
- ✅ Auto-focus on the first error field

## Accessing the Controller

Anywhere inside a `Formix` tree, get the controller with:

```dart
// Static helper (returns null if no Formix ancestor)
final controller = Formix.controllerOf(context);

// Or retrieve the Riverpod provider and watch it
final provider = Formix.of(context); // AutoDisposeStateNotifierProvider
```

## Using a GlobalKey

To access the controller from *outside* the Formix tree (e.g. a parent widget's button):

```dart
final _formKey = GlobalKey<FormixState>();

// Attach to Formix
Formix(key: _formKey, fields: [...], child: ...)

// Submit from parent
_formKey.currentState?.controller.submit(onValid: (values) async { ... });

// Access current state
final state = _formKey.currentState?.data;
```

## Next Steps

- **[Core Concepts](/concepts/overview)** — Understand how `FormixFieldID`, `FormixController`, and `FormixData` work.
- **[Validation](/concepts/validation)** — Master the fluent `FormixValidators` API.
- **[Custom Fields](/concepts/custom-fields)** — Wrap any widget with `FormixRawFormField`.
- **[Multi-Step Forms](/concepts/multi-step)** — Build wizard forms with `keepAlive` and sectioned state.
