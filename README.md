# Chip Email

![Chip Email Demonstration](https://github.com/umarKhan1/chipemails/raw/main/assets/vidz.gif)

A sophisticated Flutter package designed for high-performance, professional email input. Chip Email provides an interactive, keyboard-aware interface for managing multiple email addresses with technical precision.

## Background

### The Problem
Managing multiple email inputs in mobile applications often leads to significant user experience challenges:
1. Input Clutter: Long lists of email addresses become visually overwhelming and difficult to edit.
2. Lack of Context: Standard text fields do not distinguish between individual email entities.
3. Inefficient Extraction: Manually separating emails from bulk text (e.g., CSV) is tedious for users.
4. Non-Native Feel: Many chip implementations lack the professional keyboard behaviors expected in modern operating systems.

### The Solution
Chip Email addresses these challenges by providing a "True Inline" input architecture that treats each email as a first-class interactive object. It integrates chips and the text cursor into a single dynamic flow, supporting standard professional behaviors such as backspace navigation and intelligent extraction.

## Features

- True Inline Architecture: Chips and text flow together natively.
- Professional Interaction: Industry-standard keyboard awareness, including backspace-to-select logic.
- Intelligent Extraction: Automated parsing logic for bulk ingestion of email lists.
- Adaptive Styling: Inherits application themes and design systems without opinionated overrides.
- Form Ready: Full integration with Flutter's Form and FormField state management.

## Implementation Steps

### Step 1: Install Dependencies
Add the package to your pubspec.yaml file:
```bash
flutter pub add chip_emails
```

### Step 2: Initialize the Widget
Incorporate the EmailChipInput widget into your view. It adapts to any standard InputDecoration.

```dart
EmailChipInput(
  decoration: InputDecoration(
    hintText: "Enter recipients...",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onChanged: (emails) {
    // Process the list of validated emails
  },
)
```

### Step 3: Advanced State Management (Optional)
Utilize the ChipEmailController for programmatic control over the email list.

```dart
final controller = ChipEmailController(
  initialEmails: ['admin@company.com'],
);

EmailChipInput(controller: controller);
```

## Community and Contribution

This package is maintained as a contribution to the global Flutter ecosystem. Developers are encouraged to submit pull requests and resolve issues through the official repository.

### Professional Profiles

GitHub: [umarKhan1](https://github.com/umarKhan1)
LinkedIn: [Muhammad Omar](https://www.linkedin.com/in/muhammad-omar-0335/)

License: MIT
