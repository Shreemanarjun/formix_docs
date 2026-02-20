---
title: "Validation — Formix"
description: "Master Formix's validation system: built-in validators, async validators, cross-field validation, and custom validator functions."
---

# Validation

Formix provides a powerful, composable validation system. Validators are pure functions that receive a field value and return either `null` (valid) or an error message string.

## Built-in Validators

Formix ships with a comprehensive set of standard validators via the `Validators` class:

### String Validators

```dart
FormixField.text(
  'email',
  validators: [
    Validators.required('This field is required'),
    Validators.email('Enter a valid email address'),
    Validators.minLength(3, 'At least 3 characters'),
    Validators.maxLength(100, 'No more than 100 characters'),
    Validators.pattern(r'^[a-zA-Z]+$', 'Letters only'),
    Validators.noWhitespace('No spaces allowed'),
    Validators.url('Enter a valid URL'),
  ],
)
```

### Numeric Validators

```dart
FormixField.number(
  'age',
  validators: [
    Validators.required(),
    Validators.min(0, 'Age cannot be negative'),
    Validators.max(150, 'Enter a realistic age'),
    Validators.integer('Age must be a whole number'),
  ],
)
```

### Boolean Validators

```dart
FormixField.bool(
  'agreeToTerms',
  validators: [
    Validators.mustBeTrue('You must accept the terms'),
  ],
)
```

## Validation Modes

Controls when validation runs:

| Mode | Behavior |
|---|---|
| `ValidationMode.onChange` | Validates on every keystroke *(default)* |
| `ValidationMode.onBlur` | Validates when the field loses focus |
| `ValidationMode.onSubmit` | Validates only when the form is submitted |
| `ValidationMode.onTouched` | Validates on blur, then switches to onChange after first validation |

```dart
FormixController(
  validationMode: ValidationMode.onTouched, // Recommended for UX
  fields: [...],
)
```

<Info>
`ValidationMode.onTouched` delivers the best user experience: it doesn't show errors while the user is still typing, but catches errors quickly once they leave the field.
</Info>

## Custom Validator Functions

Any function with the signature `String? Function(T? value)` works as a validator:

```dart
FormixField.text(
  'username',
  validators: [
    Validators.required(),
    // Custom inline validator
    (value) {
      if (value != null && value.contains('@')) {
        return 'Username cannot contain @';
      }
      return null; // valid
    },
    // Named custom validator
    _noBadWords,
  ],
)

String? _noBadWords(String? value) {
  const banned = ['spam', 'hack'];
  if (banned.any((word) => value?.toLowerCase().contains(word) ?? false)) {
    return 'Username contains prohibited words';
  }
  return null;
}
```

## Async Validators

For server-side checks like username availability, use async validators:

```dart
FormixField.text(
  'username',
  validators: [Validators.required()],
  asyncValidators: [
    // Debounced async check
    AsyncValidator(
      debounce: const Duration(milliseconds: 500),
      validator: (value) async {
        if (value == null || value.isEmpty) return null;
        final available = await userService.isUsernameAvailable(value);
        return available ? null : 'Username is already taken';
      },
    ),
  ],
)
```

The field automatically shows a loading indicator while the async validator runs.

## Cross-Field Validation

Use `FormixController.addFormValidator` to add validators that operate across multiple fields:

```dart
final registrationController = FormixController(
  fields: [
    FormixField.text('password'),
    FormixField.text('confirmPassword'),
  ],
  formValidators: [
    // Cross-field: passwords must match
    FormValidator(
      fields: ['password', 'confirmPassword'],
      validator: (values) {
        if (values['password'] != values['confirmPassword']) {
          return {'confirmPassword': 'Passwords do not match'};
        }
        return null;
      },
    ),
    // Cross-field: end date after start date
    FormValidator(
      fields: ['startDate', 'endDate'],
      validator: (values) {
        final start = values['startDate'] as DateTime?;
        final end = values['endDate'] as DateTime?;
        if (start != null && end != null && end.isBefore(start)) {
          return {'endDate': 'End date must be after start date'};
        }
        return null;
      },
    ),
  ],
)
```

## Conditional Validation

Apply validators conditionally based on other field values:

```dart
FormixField.text(
  'vatNumber',
  validators: [
    // Only required when 'isCompany' is true
    Validators.requiredIf(
      condition: (formValues) => formValues['isCompany'] == true,
      message: 'VAT number is required for companies',
    ),
  ],
)
```

## Displaying Errors

All built-in Formix field widgets display errors automatically. For custom fields, use `FormixErrorText`:

```dart
FormixErrorText(fieldName: 'myCustomField')
```

Or read the error programmatically:

```dart
final error = ref.watch(fieldErrorProvider('myCustomField'));
if (error != null) {
  // show error
}
```

## Next Steps

- **[Custom Fields](/concepts/custom-fields)** — Wrap any widget in the Formix validation system.
- **[Multi-Step Forms](/concepts/multi-step)** — Validate independently per step.
