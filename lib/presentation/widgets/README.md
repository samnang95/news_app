# Widgets Library

Reusable UI components for the TaskApp.

## 📁 Structure

```
widgets/
├── buttons/
│   ├── custom_button.dart      # Styled buttons (primary, secondary, danger, outline)
│   └── icon_button.dart        # Icon button with tooltip
│
├── cards/
│   ├── post_card.dart          # Post display card
│   └── info_card.dart          # Information display card
│
├── forms/
│   ├── custom_text_field.dart  # Enhanced text field
│   ├── image_picker_field.dart # Image picker with preview
│   └── form_section.dart       # Form section wrapper
│
├── loading_indicator.dart      # Loading spinner
├── error_widget.dart           # Error display
├── index.dart                  # Export all widgets
└── USAGE_EXAMPLES.md          # Usage examples
```

## 🚀 Quick Start

### Import All Widgets

```dart
import 'package:taskapp/presentation/widgets/index.dart';
```

### Import Specific Widgets

```dart
import 'package:taskapp/presentation/widgets/buttons/custom_button.dart';
import 'package:taskapp/presentation/widgets/cards/post_card.dart';
import 'package:taskapp/presentation/widgets/forms/custom_text_field.dart';
```

## 📦 Available Widgets

### Buttons
- ✅ **CustomButton** - Multiple button styles (primary, secondary, danger, outline)
- ✅ **CustomIconButton** - Icon button with tooltip support

### Cards
- ✅ **PostCard** - Card for displaying posts with actions
- ✅ **InfoCard** - Information card with icon and value

### Forms
- ✅ **CustomTextField** - Enhanced text field with validation
- ✅ **ImagePickerField** - Image picker with preview and error handling
- ✅ **FormSection** - Section wrapper for grouping form fields

### Common
- ✅ **LoadingIndicator** - Loading spinner with optional message
- ✅ **ErrorDisplay** - Error message display with retry option

## 📖 Documentation

See [USAGE_EXAMPLES.md](./USAGE_EXAMPLES.md) for detailed usage examples.

## 🎨 Features

- ✅ Consistent styling
- ✅ Theme support (Light/Dark)
- ✅ Error handling
- ✅ Loading states
- ✅ Validation support
- ✅ Responsive design
- ✅ Accessibility support

## 💡 Usage Tips

1. **Use CustomButton** for all button actions
2. **Use PostCard** for displaying posts in lists
3. **Use CustomTextField** for all text inputs
4. **Use ImagePickerField** for image selection
5. **Use FormSection** to group related fields
6. **Use LoadingIndicator** for async operations
7. **Use ErrorDisplay** for error states

## 🔄 Updates

All widgets follow Clean Architecture principles and are located in the Presentation layer.
