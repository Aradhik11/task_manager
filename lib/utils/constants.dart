/// App-wide constants and strings
class AppConstants {
  // App Info
  static const String appName = 'Task Manager';
  static const String appVersion = '1.0.0';

  // Hive Box Names
  static const String tasksBoxName = 'tasks';

  // Validation Rules
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;

  // UI Strings
  static const String emptyStateTitle = 'No Tasks Yet';
  static const String emptyStateMessage =
      'Tap the + button to create your first task';
  static const String noSearchResultsTitle = 'No Results Found';
  static const String noSearchResultsMessage = 'Try a different search term';

  // Dialog Strings
  static const String deleteDialogTitle = 'Delete Task';
  static const String deleteDialogCancel = 'Cancel';
  static const String deleteDialogConfirm = 'Delete';

  // Form Labels
  static const String titleLabel = 'Title';
  static const String titleHint = 'Enter task title';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Enter task description';
  static const String saveButton = 'Save';

  // Error Messages
  static const String titleRequiredError = 'Title is required';
  static const String titleTooLongError =
      'Title is too long (max $maxTitleLength characters)';
  static const String descriptionTooLongError =
      'Description is too long (max $maxDescriptionLength characters)';
  static const String loadingError = 'Failed to load tasks';
  static const String saveError = 'Failed to save task';
  static const String deleteError = 'Failed to delete task';

  // Screen Titles
  static const String taskListTitle = 'My Tasks';
  static const String addTaskTitle = 'Add Task';
  static const String editTaskTitle = 'Edit Task';

  // Search
  static const String searchHint = 'Search tasks...';
}
