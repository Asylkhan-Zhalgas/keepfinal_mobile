import 'package:flutter/foundation.dart';

import '../../domain/entries/entities/entry.dart';
import '../../domain/entries/usecases/delete_entry.dart';
import '../../domain/entries/usecases/get_entries.dart';
import '../../domain/entries/usecases/save_entry.dart';

class EntriesController extends ChangeNotifier {
  final GetEntries _getEntries;
  final SaveEntry _saveEntry;
  final DeleteEntry _deleteEntry;

  EntriesController({
    required GetEntries getEntries,
    required SaveEntry saveEntry,
    required DeleteEntry deleteEntry,
  })  : _getEntries = getEntries,
        _saveEntry = saveEntry,
        _deleteEntry = deleteEntry;

  bool _isLoading = false;
  String? _error;
  List<Entry> _entries = const [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Entry> get entries => _entries;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _entries = await _getEntries();
    } catch (_) {
      _error = 'Не удалось загрузить записи';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save({
    Entry? existing,
    required String title,
    required String content,
    required DateTime date,
  }) async {
    final now = DateTime.now();
    final entry = (existing ??
            Entry(
              id: now.microsecondsSinceEpoch.toString(),
              title: '',
              content: '',
              date: date,
              createdAt: now,
              updatedAt: now,
            ))
        .copyWith(
          title: title.trim(),
          content: content.trim(),
          date: date,
          updatedAt: now,
        );

    await _saveEntry(entry);
    await load();
  }

  Future<void> remove(String id) async {
    await _deleteEntry(id);
    await load();
  }
}

