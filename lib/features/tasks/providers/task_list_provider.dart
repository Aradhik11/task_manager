import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

/// Provider for the TaskService singleton instance
final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

/// StateNotifier for managing the task list state
class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskService _taskService;

  TaskListNotifier(this._taskService) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  /// Load all tasks from storage
  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = _taskService.getAllTasks();
      // Sort by creation date, newest first
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = AsyncValue.data(tasks);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    try {
      await _taskService.addTask(task);
      await loadTasks(); // Reload tasks after adding
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
      await loadTasks(); // Reload tasks after updating
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _taskService.deleteTask(id);
      await loadTasks(); // Reload tasks after deleting
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    try {
      await _taskService.toggleTaskCompletion(id);
      await loadTasks(); // Reload tasks after toggling
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Provider for the task list
final taskListProvider =
    StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>((ref) {
      final taskService = ref.watch(taskServiceProvider);
      return TaskListNotifier(taskService);
    });

/// Provider for getting a specific task by ID
final taskByIdProvider = Provider.family<Task?, String>((ref, id) {
  final tasksAsync = ref.watch(taskListProvider);
  return tasksAsync.whenData((tasks) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }).value;
});

/// Provider for task statistics
final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  return tasksAsync.when(
    data: (tasks) {
      final total = tasks.length;
      final completed = tasks.where((task) => task.isCompleted).length;
      final pending = total - completed;
      return {'total': total, 'completed': completed, 'pending': pending};
    },
    loading: () => {'total': 0, 'completed': 0, 'pending': 0},
    error: (_, __) => {'total': 0, 'completed': 0, 'pending': 0},
  );
});
