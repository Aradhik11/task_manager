import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import 'task_list_provider.dart';

/// Provider for the search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for filtered tasks based on search query
final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return tasksAsync.when(
    data: (tasks) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(tasks);
      }

      final lowercaseQuery = searchQuery.toLowerCase();
      final filtered = tasks.where((task) {
        return task.title.toLowerCase().contains(lowercaseQuery) ||
            task.description.toLowerCase().contains(lowercaseQuery);
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

/// Provider for checking if search is active
final isSearchActiveProvider = Provider<bool>((ref) {
  final query = ref.watch(searchQueryProvider);
  return query.isNotEmpty;
});
