import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

/// Widget displayed when the task list is empty
class EmptyState extends StatelessWidget {
  final bool isSearchResult;

  const EmptyState({super.key, this.isSearchResult = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchResult ? Icons.search_off : Icons.task_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              isSearchResult
                  ? AppConstants.noSearchResultsTitle
                  : AppConstants.emptyStateTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isSearchResult
                  ? AppConstants.noSearchResultsMessage
                  : AppConstants.emptyStateMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
