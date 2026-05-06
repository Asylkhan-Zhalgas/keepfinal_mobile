import 'package:flutter/foundation.dart';

import '../../data/entries/hive_entries_repository.dart';
import '../../models/entry.dart';

class EntriesController extends ChangeNotifier {
  final HiveEntriesRepository _repo;
  EntriesController({HiveEntriesRepository? repo})
      : _repo = repo ?? HiveEntriesRepository();

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
      _entries = _repo.getAll();
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

    await _repo.upsert(entry);
    await load();
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    await load();
  }
}

