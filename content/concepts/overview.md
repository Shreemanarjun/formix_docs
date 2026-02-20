---
title: "Concepts Overview — How Formix Works"
description: "Understand the core architecture of Formix: FormixController, FormixField, FormixScope, and reactive state management."
---

# Concepts Overview

Formix is built around a small set of composable, well-defined primitives. Understanding these makes everything else click.

## Architecture at a Glance

```
ProviderScope (Riverpod root)
  └── FormixScope
        ├── FormixController  ← Brain of the form
        │     ├── FormixField[]  ← Field definitions & validators
        │     └── FormixState   ← Current values, errors, status
        └── Widget Tree
              ├── FormixTextField  ← Reads & writes 'email' field
              ├── FormixTextField  ← Reads & writes 'password' field
              └── FormixSubmitButton  ← Triggers validation & submission
```

## FormixController

The `FormixController` is the central authority for a form. It holds the field definitions and exposes methods to interact with the form programmatically.

```dart
final controller = FormixController(
  fields: [
    FormixField.text('username'),
    FormixField.number('age'),
    FormixField.bool('agreeToTerms'),
  ],
  // Optional: initial values
  initialValues: {
    'age': 18,
    'agreeToTerms': false,
  },
);
```

### Key Methods

| Method | Description |
|---|---|
| `validate()` | Runs all validators, returns `true` if the form is valid |
| `submit()` | Validates then calls the `onSubmit` callback |
| `reset()` | Resets all fields to their initial values |
| `setValue(field, value)` | Programmatically sets a field value |
| `getValue(field)` | Gets the current typed value for a field |
| `getError(field)` | Gets the current error string for a field |

## FormixField

`FormixField` is an immutable definition of a single field. It specifies the field's name, type, validators, and optional initial value.

### Built-in Field Factories

```dart
// Text field (String type)
FormixField.text('username', validators: [Validators.required()])

// Numeric field (num type)
FormixField.number('price', validators: [Validators.min(0)])

// Boolean field (bool type)
FormixField.bool('agreeToTerms')

// Date field (DateTime type)
FormixField.date('birthdate')

// Enum field
FormixField.enumField<UserRole>('role', values: UserRole.values)

// Custom typed field
FormixField<List<String>>(
  name: 'tags',
  initialValue: [],
)
```

## FormixScope

`FormixScope` is an `InheritedWidget`-style widget that injects a `FormixController` into the widget subtree. Any Formix field widget inside the scope automatically binds to the controller.

```dart
FormixScope(
  controller: myController,
  child: MyFormBody(),
)
```

<Info>
You can nest `FormixScope` widgets to have independent sub-forms within a page. Each scope manages its own controller and does not interfere with parent scopes.
</Info>

## FormixState

The reactive state of a form. Formix uses Riverpod providers under the hood, so state changes trigger precise widget rebuilds.

```dart
// Access state via the controller
final state = controller.state;

// Or watch the state in a ConsumerWidget
final state = ref.watch(loginFormProvider);

print(state.values);  // { 'email': 'user@example.com', 'password': '...' }
print(state.errors);  // { 'email': null, 'password': 'Too short' }
print(state.status);  // FormixStatus.valid | .invalid | .submitting | .success | .error
print(state.isValid); // true | false
```

### FormixStatus

| Status | Description |
|---|---|
| `idle` | Form has not been interacted with |
| `touched` | At least one field has been changed |
| `valid` | All fields pass their validators |
| `invalid` | One or more fields fail validation |
| `submitting` | `onSubmit` is currently awaiting |
| `success` | `onSubmit` completed successfully |
| `error` | `onSubmit` threw an error |

## Reactive Rebuilds

Because Formix is built on Riverpod, rebuilds are surgical. A `FormixTextField` bound to `'email'` only rebuilds when the `email` field's value or error changes — not when any other field changes.

```dart
// This widget ONLY rebuilds when 'email' field changes
class EmailField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailValue = ref.watch(fieldValueProvider('email'));
    final emailError = ref.watch(fieldErrorProvider('email'));
    // ...
  }
}
```

## Next Topics

- **[Validation](/concepts/validation)** — Built-in validators, async validation, cross-field rules.
- **[Custom Fields](/concepts/custom-fields)** — Extend Formix with your own field types.
- **[Multi-Step Forms](/concepts/multi-step)** — Wizard forms with per-step validation.
