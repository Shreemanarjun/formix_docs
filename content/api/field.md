---
title: "FormixField API Reference"
description: "Complete API reference for FormixField — the type-safe field definition class in Formix."
---

# FormixField

`FormixField<T>` is an immutable descriptor for a single form field. It declares the field's name, type, validators, and initial value.

## Generic Type Parameter

`FormixField<T>` is generic over `T` — the Dart type of the field's value. Built-in factory constructors handle common types. Use `FormixField<T>` directly for custom types.

## Factory Constructors

### `FormixField.text()`

```dart
FormixField.text(
  String name, {
  String? label,
  String? hint,
  String? initialValue,
  List<FormixValidator<String>>? validators,
  List<AsyncValidator<String>>? asyncValidators,
  bool enabled = true,
})
```

Creates a `FormixField<String>`. Use for text inputs, email fields, passwords, etc.

---

### `FormixField.number()`

```dart
FormixField.number(
  String name, {
  String? label,
  num? initialValue,
  List<FormixValidator<num>>? validators,
  bool enabled = true,
})
```

Creates a `FormixField<num>`. Values from `FormixNumberField` are parsed and stored as `num`.

---

### `FormixField.bool()`

```dart
FormixField.bool(
  String name, {
  String? label,
  bool initialValue = false,
  List<FormixValidator<bool>>? validators,
})
```

Creates a `FormixField<bool>`. Use for checkboxes, toggles, and switches.

---

### `FormixField.date()`

```dart
FormixField.date(
  String name, {
  String? label,
  DateTime? initialValue,
  List<FormixValidator<DateTime>>? validators,
})
```

Creates a `FormixField<DateTime>`. Use with `FormixDatePicker`.

---

### `FormixField.custom<T>()`

```dart
FormixField.custom<T>(
  String name, {
  String? label,
  T? initialValue,
  List<FormixValidator<T>>? validators,
  List<AsyncValidator<T>>? asyncValidators,
  bool enabled = true,
})
```

Creates a `FormixField<T>` for any custom type.

```dart
FormixField.custom<List<String>>(
  'selectedTags',
  initialValue: const [],
  validators: [
    (tags) => (tags?.length ?? 0) > 5
        ? 'Select no more than 5 tags'
        : null,
  ],
)
```

---

## Properties

| Property | Type | Description |
|---|---|---|
| `name` | `String` | Unique identifier within the form |
| `label` | `String?` | Human-readable display label |
| `hint` | `String?` | Placeholder / hint text |
| `initialValue` | `T?` | Value the field starts with and resets to |
| `validators` | `List<FormixValidator<T>>` | Sync validators for this field |
| `asyncValidators` | `List<AsyncValidator<T>>` | Async validators for this field |
| `enabled` | `bool` | Whether the field is interactive |

## FormixValidator Type

```dart
typedef FormixValidator<T> = String? Function(T? value);
```

Return `null` to indicate validity. Return a non-null string as the error message.

## AsyncValidator

```dart
class AsyncValidator<T> {
  final Duration debounce;
  final Future<String?> Function(T? value) validator;

  const AsyncValidator({
    this.debounce = const Duration(milliseconds: 300),
    required this.validator,
  });
}
```

## copyWith

`FormixField` is immutable. Use `copyWith` to create modified copies:

```dart
final baseField = FormixField.text('email');

// Override validators for a different context
final strictField = baseField.copyWith(
  validators: [
    ...baseField.validators,
    (v) => v?.endsWith('@company.com') == true
        ? null
        : 'Must use a company email',
  ],
);
```

## See Also

- **[Validators](/api/validators)** — Full list of built-in validators.
- **[FormixController](/api/controller)** — How to use fields within a controller.
- **[Custom Fields](/concepts/custom-fields)** — Building custom field widgets.
