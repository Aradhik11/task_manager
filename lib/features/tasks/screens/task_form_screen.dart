import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_list_provider.dart';
import '../../../utils/constants.dart';

/// Screen for adding a new task or editing an existing one
class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? taskToEdit;

  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if editing
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.taskToEdit != null;

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditing) {
        // Update existing task
        final updatedTask = widget.taskToEdit!.copyWith(
          title: title,
          description: description,
        );
        await ref.read(taskListProvider.notifier).updateTask(updatedTask);
      } else {
        // Create new task
        final newTask = Task.create(title: title, description: description);
        await ref.read(taskListProvider.notifier).addTask(newTask);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Task updated successfully'
                  : 'Task added successfully',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppConstants.saveError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? AppConstants.editTaskTitle : AppConstants.addTaskTitle,
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              onPressed: _saveTask,
              icon: const Icon(Icons.check),
              tooltip: AppConstants.saveButton,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppConstants.titleLabel,
                hintText: AppConstants.titleHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.title),
              ),
              maxLength: AppConstants.maxTitleLength,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppConstants.titleRequiredError;
                }
                if (value.trim().length > AppConstants.maxTitleLength) {
                  return AppConstants.titleTooLongError;
                }
                return null;
              },
              autofocus: !_isEditing,
            ),
            const SizedBox(height: 16),
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: AppConstants.descriptionLabel,
                hintText: AppConstants.descriptionHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: AppConstants.maxDescriptionLength,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value != null &&
                    value.trim().length > AppConstants.maxDescriptionLength) {
                  return AppConstants.descriptionTooLongError;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            // Save button (alternative to AppBar action)
            FilledButton.icon(
              onPressed: _isLoading ? null : _saveTask,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(AppConstants.saveButton),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }
}
