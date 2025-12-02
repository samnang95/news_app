import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/post_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../domain/entities/post_entity.dart';
import '../../widgets/index.dart';

class PostFormPage extends ConsumerStatefulWidget {
  final PostEntity? post;

  const PostFormPage({super.key, this.post});

  @override
  ConsumerState<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends ConsumerState<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImageFile;
  String? _existingImageUrl;
  String? _imageError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
    _selectedImageFile = widget.post?.imageFile;
    _existingImageUrl = widget.post?.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.post != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? AppLocalizations.of(context)!.editPost
              : AppLocalizations.of(context)!.newPost,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormSection(
                  title: AppLocalizations.of(context)!.title,
                  children: [
                    CustomTextField(
                      labelText: AppLocalizations.of(context)!.title,
                      controller: _titleController,
                      prefixIcon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                FormSection(
                  title: AppLocalizations.of(context)!.body,
                  children: [
                    CustomTextField(
                      labelText: AppLocalizations.of(context)!.body,
                      controller: _bodyController,
                      prefixIcon: Icons.description,
                      // maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a body';
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
                      selectedImage: _selectedImageFile,
                      imageUrl: _existingImageUrl,
                      onPickImage: _pickImageFromGallery,
                      onRemoveImage: _clearImage,
                      errorText: _imageError,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AppLocalizations.of(context)!.save,
                  width: double.infinity,
                  icon: Icons.save,
                  isLoading: _isSaving,
                  onPressed: _isSaving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _imageError = null;
    });
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    setState(() {
      _selectedImageFile = File(pickedFile.path);
      _existingImageUrl = null;
    });
  }

  void _clearImage() {
    setState(() {
      _selectedImageFile = null;
      _existingImageUrl = null;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImageFile == null &&
        (_existingImageUrl == null || _existingImageUrl!.isEmpty)) {
      setState(() {
        _imageError = 'Please select an image';
      });
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final newPost = PostEntity(
      userId: widget.post?.userId ?? 1,
      id: widget.post?.id ?? 0,
      title: _titleController.text,
      body: _bodyController.text,
      imageFile: _selectedImageFile,
      imageUrl: _selectedImageFile == null ? _existingImageUrl : null,
    );

    try {
      if (widget.post != null) {
        await ref.read(postsProvider.notifier).updatePost(newPost);
      } else {
        await ref.read(postsProvider.notifier).addPost(newPost);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    }
  }
}
