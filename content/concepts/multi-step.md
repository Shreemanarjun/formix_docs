---
title: "Multi-Step Forms (Wizards) — Formix"
description: "Build complex multi-step form wizards with Formix. Per-step validation, state persistence, progress tracking, and step navigation."
---

# Multi-Step Forms

Formix has first-class support for multi-step forms — commonly called "wizards". Each step can have its own fields and validators, and form state is preserved as the user navigates between steps.

## FormixWizard

`FormixWizard` is the top-level widget for wizard forms. It manages a list of `FormixStep` definitions and orchestrates navigation between them.

```dart
class RegistrationWizard extends StatelessWidget {
  const RegistrationWizard({super.key});

  @override
  Widget build(BuildContext context) {
    return FormixWizard(
      steps: [
        FormixStep(
          title: 'Account',
          fields: [
            FormixField.text('email', validators: [Validators.email()]),
            FormixField.text('password', validators: [Validators.minLength(8)]),
            FormixField.text('confirmPassword'),
          ],
          formValidators: [
            FormValidator(
              fields: ['password', 'confirmPassword'],
              validator: (v) => v['password'] != v['confirmPassword']
                  ? {'confirmPassword': 'Passwords do not match'}
                  : null,
            ),
          ],
          builder: (context) => const AccountStep(),
        ),
        FormixStep(
          title: 'Profile',
          fields: [
            FormixField.text('firstName', validators: [Validators.required()]),
            FormixField.text('lastName', validators: [Validators.required()]),
            FormixField.date('birthdate'),
          ],
          builder: (context) => const ProfileStep(),
        ),
        FormixStep(
          title: 'Preferences',
          fields: [
            FormixField.bool('newsletter'),
            FormixField<List<String>>.custom('interests', initialValue: []),
          ],
          builder: (context) => const PreferencesStep(),
        ),
      ],
      onComplete: (allValues) async {
        // allValues contains all fields from all steps
        await userService.register(
          email: allValues['email'],
          password: allValues['password'],
          firstName: allValues['firstName'],
          interests: allValues['interests'],
        );
      },
    );
  }
}
```

## Wizard Navigation

Inside each step widget, use `FormixWizardController` to navigate:

```dart
class AccountStep extends ConsumerWidget {
  const AccountStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = FormixWizardController.of(context);

    return Column(
      children: [
        const FormixTextField(fieldName: 'email', label: 'Email'),
        const FormixTextField(
          fieldName: 'password',
          label: 'Password',
          obscureText: true,
        ),
        const FormixTextField(
          fieldName: 'confirmPassword',
          label: 'Confirm Password',
          obscureText: true,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              // Validates current step, then advances if valid
              onPressed: () => wizard.nextStep(),
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Navigation Methods

| Method | Description |
|---|---|
| `wizard.nextStep()` | Validates current step and advances. Stays on step if invalid. |
| `wizard.previousStep()` | Goes back (no validation). |
| `wizard.goToStep(index)` | Jump to a specific step index (validates all steps before target). |
| `wizard.complete()` | Validates final step and triggers `onComplete`. |
| `wizard.currentStep` | Current step index (reactive) |
| `wizard.totalSteps` | Total number of steps |
| `wizard.canGoBack` | True if not on the first step |
| `wizard.isLastStep` | True if on the final step |

## Progress Indicator

Show users where they are in the flow with the built-in `FormixWizardProgress`:

```dart
FormixWizard(
  progressBuilder: (context, currentStep, totalSteps) {
    return FormixWizardProgress(
      currentStep: currentStep,
      totalSteps: totalSteps,
      style: WizardProgressStyle.dots, // .linear | .dots | .steps
    );
  },
  steps: [...],
)
```

## Accessing All Step Values

The `onComplete` callback receives a flat map of all field values from all steps:

```dart
FormixWizard(
  onComplete: (allValues) async {
    print(allValues);
    // {
    //   'email': 'user@example.com',
    //   'password': 'securepass',
    //   'firstName': 'Jane',
    //   'birthdate': DateTime(1995, 3, 15),
    //   'newsletter': true,
    //   'interests': ['flutter', 'dart'],
    // }
  },
  steps: [...],
)
```

## Step State Persistence

By default, Formix preserves all step values in memory as the user navigates back and forth. Values entered in Step 1 are still there when the user returns from Step 3.

To persist data across app restarts, implement a `FormixPersistence` adapter:

```dart
FormixWizard(
  persistence: SharedPreferencesFormixPersistence(
    key: 'registration_wizard',
  ),
  steps: [...],
)
```

## Conditional Steps

Show or hide steps based on values entered in earlier steps:

```dart
FormixWizard(
  steps: [
    FormixStep(title: 'Account', ...),
    FormixStep(
      title: 'Company Details',
      // This step only shows if user selected 'company' account type
      isVisible: (formValues) => formValues['accountType'] == 'company',
      fields: [
        FormixField.text('companyName'),
        FormixField.text('vatNumber'),
      ],
      builder: (context) => const CompanyDetailsStep(),
    ),
    FormixStep(title: 'Summary', ...),
  ],
)
```

## Example: Checkout Flow

```dart
FormixWizard(
  steps: [
    FormixStep(
      title: 'Cart Review',
      fields: [],
      builder: (context) => const CartReviewStep(),
    ),
    FormixStep(
      title: 'Shipping',
      fields: shippingFields,
      builder: (context) => const ShippingStep(),
    ),
    FormixStep(
      title: 'Payment',
      fields: paymentFields,
      builder: (context) => const PaymentStep(),
    ),
    FormixStep(
      title: 'Confirm',
      fields: [],
      builder: (context) => const ConfirmationStep(),
    ),
  ],
  onComplete: (values) => orderService.placeOrder(values),
)
```

## Next Steps

- **[API Reference: FormixWizard](/api/wizard)** — Full API docs.
- **[Examples: Registration Form](/examples/registration-form)** — Complete code for a multi-step registration.
