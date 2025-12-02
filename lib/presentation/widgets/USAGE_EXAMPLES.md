# Widgets Usage Examples

## 📦 Available Widgets

### Buttons
- `CustomButton` - Styled button with multiple types
- `CustomIconButton` - Icon button with tooltip

### Cards
- `PostCard` - Card for displaying posts
- `InfoCard` - Information display card

### Forms
- `CustomTextField` - Enhanced text field
- `ImagePickerField` - Image picker with preview
- `FormSection` - Section wrapper for forms

### Common
- `LoadingIndicator` - Loading spinner
- `ErrorDisplay` - Error message display

---

## 🔘 Buttons

### CustomButton

```dart
import 'package:taskapp/presentation/widgets/widgets.dart';

// Primary button
CustomButton(
  text: 'Save',
  onPressed: () {
    // Handle save
  },
  type: ButtonType.primary,
)

// Secondary button
CustomButton(
  text: 'Cancel',
  onPressed: () {},
  type: ButtonType.secondary,
)

// Danger button
CustomButton(
  text: 'Delete',
  onPressed: () {},
  type: ButtonType.danger,
)

// Outline button
CustomButton(
  text: 'Learn More',
  onPressed: () {},
  type: ButtonType.outline,
)

// Button with icon
CustomButton(
  text: 'Upload',
  icon: Icons.upload,
  onPressed: () {},
)

// Loading button
CustomButton(
  text: 'Saving...',
  isLoading: true,
  onPressed: null,
)

// Full width button
CustomButton(
  text: 'Submit',
  width: double.infinity,
  onPressed: () {},
)
```

### CustomIconButton

```dart
CustomIconButton(
  icon: Icons.edit,
  onPressed: () {},
  tooltip: 'Edit',
  color: Colors.blue,
)
```

---

## 🃏 Cards

### PostCard

```dart
PostCard(
  post: postEntity,
  onTap: () {
    // Navigate to details
  },
  onEdit: () {
    // Navigate to edit
  },
  onDelete: () {
    // Delete post
  },
  showActions: true,
)
```

### InfoCard

```dart
// Simple info card
InfoCard(
  title: 'Total Posts',
  value: '42',
  icon: Icons.article,
)

// With custom widget
InfoCard(
  title: 'Status',
  valueWidget: Chip(
    label: Text('Active'),
    backgroundColor: Colors.green,
  ),
  icon: Icons.check_circle,
  color: Colors.green,
)

// Clickable card
InfoCard(
  title: 'User',
  value: 'John Doe',
  icon: Icons.person,
  onTap: () {
    // Navigate to user profile
  },
)
```

---

## 📝 Forms

### CustomTextField

```dart
// Basic text field
CustomTextField(
  labelText: 'Title',
  hintText: 'Enter title',
  controller: titleController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  },
)

// With icon
CustomTextField(
  labelText: 'Email',
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
)

// Password field
CustomTextField(
  labelText: 'Password',
  obscureText: true,
  suffixIcon: Icons.visibility,
  onSuffixTap: () {
    // Toggle visibility
  },
)

// Multiline
CustomTextField(
  labelText: 'Description',
  maxLines: 5,
  maxLength: 500,
)
```

### ImagePickerField

```dart
ImagePickerField(
  labelText: 'Image',
  selectedImage: _selectedImage,
  imageUrl: _existingImageUrl,
  onPickImage: () async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  },
  onRemoveImage: () {
    setState(() {
      _selectedImage = null;
    });
  },
  errorText: _imageError,
)
```

### FormSection

```dart
FormSection(
  title: 'Personal Information',
  subtitle: 'Enter your details',
  children: [
    CustomTextField(
      labelText: 'Name',
      controller: nameController,
    ),
    const SizedBox(height: 16),
    CustomTextField(
      labelText: 'Email',
      controller: emailController,
    ),
  ],
)
```

---

## 🔄 Common Widgets

### LoadingIndicator

```dart
// Simple loading
LoadingIndicator()

// With message
LoadingIndicator(
  message: 'Loading posts...',
  size: 50,
)
```

### ErrorDisplay

```dart
// Error with retry
ErrorDisplay(
  message: 'Failed to load posts',
  onRetry: () {
    // Retry action
  },
)

// Error without retry
ErrorDisplay(
  message: 'No internet connection',
  icon: Icons.wifi_off,
)
```

---

## 📋 Complete Form Example

```dart
import 'package:taskapp/presentation/widgets/widgets.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormSection(
              title: 'Post Information',
              children: [
                CustomTextField(
                  labelText: 'Title',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  labelText: 'Body',
                  controller: _bodyController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter body text';
                    }
                    return null;
                  },
                ),
              ],
            ),
            FormSection(
              title: 'Image',
              children: [
                ImagePickerField(
                  selectedImage: _selectedImage,
                  onPickImage: _pickImage,
                  onRemoveImage: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Save',
              width: double.infinity,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save logic
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    // Image picker logic
  }
}
```

---

## 🎨 Import All Widgets

```dart
import 'package:taskapp/presentation/widgets/widgets.dart';
```

Or import individually:

```dart
import 'package:taskapp/presentation/widgets/buttons/custom_button.dart';
import 'package:taskapp/presentation/widgets/cards/post_card.dart';
import 'package:taskapp/presentation/widgets/forms/custom_text_field.dart';
```




