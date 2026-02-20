---
title: "Custom Fields — Formix"
description: "Build your own type-safe Formix field widgets using FormixRawFormField. Wrap any Flutter widget in the Formix ecosystem."
---

# Custom Fields

Formix's built-in field widgets cover the most common use cases, but real apps need custom inputs — color pickers, tag selectors, signature pads, rich text editors, and more. Formix makes this easy.

## FormixRawFormField

`FormixRawFormField` is the foundation for every field widget in Formix. You use it to connect *any* widget to the Formix state machine.

```dart
class MyRatingField extends StatelessWidget {
  const MyRatingField({
    super.key,
    required this.fieldName,
  });

  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return FormixRawFormField<int>(
      fieldName: fieldName,
      builder: (context, field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your custom input widget
            StarRatingWidget(
              rating: field.value ?? 0,
              onRatingChanged: (rating) {
                field.onChanged(rating);  // ← updates Formix state
              },
            ),
            // Automatically shows validation error
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
```

### What `FormixRawFormField` Gives You

The `field` parameter exposes:

| Property | Type | Description |
|---|---|---|
| `field.value` | `T?` | Current typed value |
| `field.errorText` | `String?` | Current error message, or null if valid |
| `field.onChanged` | `void Function(T?)` | Call this to update the field value |
| `field.onFocusChanged` | `void Function(bool)` | Report focus changes for `onBlur` validation mode |
| `field.isTouched` | `bool` | Whether the field has been interacted with |
| `field.isValidating` | `bool` | True while an async validator is running |

## Example: Dropdown Select Field

```dart
class FormixDropdown<T> extends StatelessWidget {
  const FormixDropdown({
    super.key,
    required this.fieldName,
    required this.items,
    this.label,
  });

  final String fieldName;
  final List<DropdownMenuItem<T>> items;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return FormixRawFormField<T>(
      fieldName: fieldName,
      builder: (context, field) {
        return DropdownButtonFormField<T>(
          value: field.value,
          items: items,
          decoration: InputDecoration(
            labelText: label,
            errorText: field.errorText,
          ),
          onChanged: field.onChanged,
        );
      },
    );
  }
}
```

**Usage:**

```dart
FormixDropdown<String>(
  fieldName: 'country',
  label: 'Country',
  items: countries
      .map((c) => DropdownMenuItem(value: c.code, child: Text(c.name)))
      .toList(),
)
```

## Example: Multi-Select Tag Field

```dart
class FormixTagField extends StatelessWidget {
  const FormixTagField({
    super.key,
    required this.fieldName,
    required this.options,
  });

  final String fieldName;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return FormixRawFormField<List<String>>(
      fieldName: fieldName,
      builder: (context, field) {
        final selected = field.value ?? [];
        return Wrap(
          spacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) {
                final next = List<String>.from(selected);
                if (isSelected) {
                  next.remove(option);
                } else {
                  next.add(option);
                }
                field.onChanged(next);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
```

## Integrating with Third-Party Widgets

Almost any third-party picker or input can be wrapped in `FormixRawFormField`. The key is calling `field.onChanged(newValue)` whenever the user changes the value.

```dart
// Example: integrating a date range picker package
FormixRawFormField<DateTimeRange>(
  fieldName: 'bookingRange',
  builder: (context, field) {
    return MyDateRangePicker(
      initialDateRange: field.value,
      onRangeSelected: (range) {
        field.onChanged(range);
        field.onFocusChanged(false); // Trigger blur validation
      },
    );
  },
)
```

## Registering the Field Type

Ensure your field type is declared in the controller when using non-primitive types:

```dart
FormixController(
  fields: [
    FormixField<DateTimeRange>(
      name: 'bookingRange',
      validators: [
        (range) => range == null ? 'Please select a date range' : null,
      ],
    ),
    FormixField<List<String>>(
      name: 'tags',
      initialValue: [],
    ),
  ],
)
```

## Tips & Best Practices

- **Always report focus changes** using `field.onFocusChanged` to support `onBlur` and `onTouched` validation modes.
- **Keep field widgets stateless** — Formix manages all state; avoid local `StatefulWidget` state for the form value.
- **Co-locate your field definition** with the widget if building a reusable package component.

## Next Steps

- **[Multi-Step Forms](/concepts/multi-step)** — Use custom fields inside step-by-step wizards.
- **[API: FormixRawFormField](/api/raw-form-field)** — Full API reference.
