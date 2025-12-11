import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

/// Confirmation dialog shown before deleting a task
class DeleteDialog extends StatelessWidget {
  final String taskTitle;
  final VoidCallback onConfirm;

  const DeleteDialog({
    super.key,
    required this.taskTitle,
    required this.onConfirm,
  });

  /// Show the delete confirmation dialog
  static Future<bool?> show({
    required BuildContext context,
    required String taskTitle,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteDialog(
        taskTitle: taskTitle,
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppConstants.deleteDialogTitle),
      content: Text(
        'Are you sure you want to delete "$taskTitle"? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppConstants.deleteDialogCancel),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: const Text(AppConstants.deleteDialogConfirm),
        ),
      ],
    );
  }
}
