import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/tasks/models/task_model.dart';
import 'features/tasks/services/task_service.dart';
import 'features/tasks/providers/task_list_provider.dart';
import 'features/tasks/screens/task_list_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive type adapters
  Hive.registerAdapter(TaskAdapter());

  // Initialize TaskService
  final taskService = TaskService();
  await taskService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Override the taskServiceProvider with the initialized instance
        taskServiceProvider.overrideWithValue(taskService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Material Design 3
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        // Card theme
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        // AppBar theme
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
      ),
      home: const TaskListScreen(),
    );
  }
}
