import 'package:hive/hive.dart';
import '../models/task_model.dart';
import '../../../utils/constants.dart';

/// Service class that handles all business logic for task operations.
///
/// Provides CRUD operations and search functionality with proper error handling.
class TaskService {
  Box<Task>? _taskBox;

  /// Initialize the Hive box for tasks
  Future<void> initialize() async {
    _taskBox = await Hive.openBox<Task>(AppConstants.tasksBoxName);
  }

  /// Get the task box, throws if not initialized
  Box<Task> get _box {
    if (_taskBox == null) {
      throw Exception('TaskService not initialized. Call initialize() first.');
    }
    return _taskBox!;
  }

  /// Get all tasks as a list
  List<Task> getAllTasks() {
    try {
      return _box.values.toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  /// Get a task by ID
  Task? getTaskById(String id) {
    try {
      return _box.values.firstWhere(
        (task) => task.id == id,
        orElse: () => throw Exception('Task not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    try {
      await _box.put(task.id, task);
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      if (!_box.containsKey(task.id)) {
        throw Exception('Task not found');
      }
      await _box.put(task.id, task);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// Delete a task by ID
  Future<void> deleteTask(String id) async {
    try {
      if (!_box.containsKey(id)) {
        throw Exception('Task not found');
      }
      await _box.delete(id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    try {
      final task = getTaskById(id);
      if (task == null) {
        throw Exception('Task not found');
      }
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask);
    } catch (e) {
      throw Exception('Failed to toggle task: $e');
    }
  }

  /// Search tasks by query (searches in title and description)
  List<Task> searchTasks(String query) {
    try {
      if (query.isEmpty) {
        return getAllTasks();
      }

      final lowercaseQuery = query.toLowerCase();
      return _box.values.where((task) {
        return task.title.toLowerCase().contains(lowercaseQuery) ||
            task.description.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }

  /// Get completed tasks
  List<Task> getCompletedTasks() {
    try {
      return _box.values.where((task) => task.isCompleted).toList();
    } catch (e) {
      throw Exception('Failed to load completed tasks: $e');
    }
  }

  /// Get pending tasks
  List<Task> getPendingTasks() {
    try {
      return _box.values.where((task) => !task.isCompleted).toList();
    } catch (e) {
      throw Exception('Failed to load pending tasks: $e');
    }
  }

  /// Get task count
  int getTaskCount() {
    return _box.length;
  }

  /// Clear all tasks (useful for testing)
  Future<void> clearAllTasks() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('Failed to clear tasks: $e');
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _taskBox?.close();
  }
}
