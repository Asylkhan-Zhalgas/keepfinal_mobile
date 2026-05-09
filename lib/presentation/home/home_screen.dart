import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entries/entities/entry.dart';
import '../entries/entries_controller.dart';
import '../widgets/confirm_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _fmtDateTime(DateTime dt) {
    dt = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  String _fmtDate(DateTime dt) {
    dt = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year}';
  }

  List<Entry> _filter(List<Entry> entries, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return entries;
    return entries.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.content.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final entriesController = context.watch<EntriesController>();
    final entries = entriesController.entries;
    final filtered = _filter(entries, _searchCtrl.text);

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
              if (!entriesController.isLoading &&
                  entriesController.error == null &&
                  entries.isNotEmpty) ...[
                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Поиск по записям…',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
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
                    child: Text(
                      'Записей пока нет',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Ничего не найдено',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final e = filtered[index];
                      return _EntryTile(
                        entry: e,
                        entryDateText: _fmtDate(e.date),
                        createdAtText: _fmtDateTime(e.createdAt),
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
  final String entryDateText;
  final String createdAtText;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _EntryTile({
    required this.entry,
    required this.entryDateText,
    required this.createdAtText,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entry.title),
        subtitle: Text(
          'Дата записи: $entryDateText\nСоздано: $createdAtText\n${entry.content}',
          maxLines: 5,
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
