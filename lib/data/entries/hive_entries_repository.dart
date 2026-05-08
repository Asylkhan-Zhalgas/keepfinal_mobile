import 'package:hive/hive.dart';

import '../../domain/entries/entities/entry.dart';
import '../../domain/entries/repositories/entries_repository.dart';
import 'entry_mapper.dart';

class HiveEntriesRepository implements EntriesRepository {
  final Box _box;
  HiveEntriesRepository({Box? box}) : _box = box ?? Hive.box('entries');

  @override
  Future<List<Entry>> getAll() async {
    final entries = <Entry>[];
    for (final value in _box.values) {
      if (value is Map) {
        entries.add(EntryMapper.fromMap(value));
      }
    }
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  @override
  Future<void> upsert(Entry entry) async {
    await _box.put(entry.id, EntryMapper.toMap(entry));
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

