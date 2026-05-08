import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entries/entities/entry.dart';
import '../entries/entries_controller.dart';
import '../widgets/confirm_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entriesController = context.watch<EntriesController>();
    final entries = entriesController.entries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (entriesController.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (entriesController.error != null)
                Expanded(
                  child: Center(
                    child: Text(
                      entriesController.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (entries.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Записей пока нет',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      return _EntryTile(
                        entry: e,
                        onTap: () => context.push('/entry/edit', extra: e),
                        onDelete: () async {
                          final ok = await showConfirmBottomSheet(
                            context: context,
                            title: 'Удалить запись?',
                            confirmText: 'Удалить',
                            destructive: true,
                          );
                          if (!ok) return;
                          if (!context.mounted) return;
                          await context.read<EntriesController>().remove(e.id);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  final Entry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _EntryTile({
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${entry.date.day.toString().padLeft(2, '0')}.'
        '${entry.date.month.toString().padLeft(2, '0')}.'
        '${entry.date.year}';

    return Card(
      child: ListTile(
        title: Text(entry.title),
        subtitle: Text(
          '$dateText\n${entry.content}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        onTap: onTap,
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: 'Удалить',
        ),
      ),
    );
  }
}
