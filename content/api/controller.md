---
title: "FormixController API Reference"
description: "Complete API reference for FormixController — the central state manager for Formix forms."
---

# FormixController

`FormixController` is the brain of every Formix form. It holds the field definitions, manages form state, and exposes methods for programmatic interaction.

## Constructor

```dart
FormixController({
  required List<FormixField> fields,
  Map<String, dynamic>? initialValues,
  List<FormValidator>? formValidators,
  ValidationMode validationMode = ValidationMode.onTouched,
  Future<void> Function(Map<String, dynamic> values)? onSubmit,
})
```

### Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `fields` | `List<FormixField>` | ✅ | Declares all fields in the form |
| `initialValues` | `Map<String, dynamic>?` | — | Override initial values from field definitions |
| `formValidators` | `List<FormValidator>?` | — | Cross-field validators that run on the whole form |
| `validationMode` | `ValidationMode` | — | When field validation runs. Defaults to `onTouched` |
| `onSubmit` | `Future<void> Function(...)?` | — | Optional global submit callback |

## Properties

### `state`

```dart
FormixState get state
```

Returns the current snapshot of the form's state. Use `ref.watch(formixProvider)` in widgets for reactive access.

### `isValid`

```dart
bool get isValid
```

`true` when all field validators pass and no form validators return errors.

### `isDirty`

```dart
bool get isDirty
```

`true` when any field value has changed from its initial value.

### `isTouched`

```dart
bool get isTouched
```

`true` when any field has been interacted with by the user.

### `isSubmitting`

```dart
bool get isSubmitting
```

`true` while an async `onSubmit` function is pending.

## Methods

### `validate()`

```dart
bool validate()
```

Runs all field validators and form validators synchronously. Returns `true` if the form is valid. Does **not** run async validators.

```dart
final isValid = controller.validate();
if (isValid) {
  // proceed
}
```

### `submit()`

```dart
Future<void> submit({
  required Future<void> Function(Map<String, dynamic> values) onSubmit,
  void Function(Object error)? onError,
})
```

Validates the form, then calls `onSubmit` with all field values. Sets `isSubmitting` to `true` during the async operation. Calls `onError` if the future throws.

```dart
await controller.submit(
  onSubmit: (values) async {
    await apiClient.createUser(
      email: values['email'] as String,
      name: values['name'] as String,
    );
  },
  onError: (error) {
    showErrorSnackbar(error.toString());
  },
);
```

### `reset()`

```dart
void reset({Map<String, dynamic>? values})
```

Resets all fields to their initial values, clears all errors, and sets `isTouched` to `false`. Pass `values` to reset to specific values instead of the original initial values.

```dart
// Reset to initial values
controller.reset();

// Reset to specific values
controller.reset(values: {'email': 'prefilled@example.com'});
```

### `setValue()`

```dart
void setValue(String fieldName, dynamic value)
```

Programmatically sets a field's value. Triggers validation if the current `validationMode` requires it.

```dart
controller.setValue('country', 'US');
controller.setValue('agreeToTerms', true);
```

### `getValue()`

```dart
T? getValue<T>(String fieldName)
```

Returns the current typed value of a field.

```dart
final email = controller.getValue<String>('email');
final age = controller.getValue<int>('age');
```

### `getError()`

```dart
String? getError(String fieldName)
```

Returns the current error message for a field, or `null` if the field is valid.

```dart
final emailError = controller.getError('email');
```

### `setError()`

```dart
void setError(String fieldName, String? error)
```

Manually set an error on a field. Pass `null` to clear a manually-set error. Useful for setting server-side errors after form submission:

```dart
try {
  await apiClient.register(values);
} on EmailAlreadyExistsException {
  controller.setError('email', 'This email is already registered');
}
```

### `clearErrors()`

```dart
void clearErrors()
```

Clears all errors on all fields without resetting field values.

### `patchValues()`

```dart
void patchValues(Map<String, dynamic> values)
```

Updates multiple field values at once without resetting the entire form. Only fields included in the map are updated.

```dart
// Pre-fill form from an existing user object
controller.patchValues({
  'firstName': user.firstName,
  'lastName': user.lastName,
  'email': user.email,
});
```

### `addField()`

```dart
void addField(FormixField field)
```

Dynamically adds a field to the form. Useful for conditional/dynamic fields.

### `removeField()`

```dart
void removeField(String fieldName)
```

Dynamically removes a field and its current value and error from the form.

## FormixState

The `FormixState` object returned by `controller.state`:

```dart
class FormixState {
  final Map<String, dynamic> values;   // Current field values
  final Map<String, String?> errors;   // Current field errors
  final FormixStatus status;           // Current form status
  final bool isDirty;
  final bool isTouched;
  final bool isSubmitting;
  final bool isValid;
}
```

## Accessing the Controller

### In a `ConsumerWidget`:

```dart
class MyForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(formixControllerProvider);
    // or
    final controller = FormixScope.of(context);
  }
}
```

### Via `FormixScope`:

```dart
final controller = FormixScope.controllerOf(context);
```

## See Also

- **[FormixField API](/api/field)** — Field definition and configuration.
- **[Validation](/concepts/validation)** — Comprehensive validation guide.
