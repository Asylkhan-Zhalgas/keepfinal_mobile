import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entries/entities/entry.dart';
import '../entries/entries_controller.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selected = DateTime.now();

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _fmtDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    dt = dt.toLocal();
    return '${two(dt.day)}.${two(dt.month)}.${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EntriesController>();
    final entries = controller.entries
        .where((e) => _sameDay(e.date.toLocal(), _selected.toLocal()))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Календарь')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CalendarDatePicker(
                  initialDate: _selected,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (d) => setState(() => _selected = d),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Записи за ${_fmtDate(_selected)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (controller.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: Text(
                    controller.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'Нет записей за выбранную дату',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _EntryCard(
                    entry: e,
                    onTap: () => context.push('/entry/edit', extra: e),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final Entry entry;
  final VoidCallback onTap;

  const _EntryCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entry.title),
        subtitle: Text(
          entry.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

