import 'package:hive/hive.dart';

import '../../models/entry.dart';

class HiveEntriesRepository {
  final Box _box;
  HiveEntriesRepository({Box? box}) : _box = box ?? Hive.box('entries');

  List<Entry> getAll() {
    final entries = <Entry>[];
    for (final value in _box.values) {
      if (value is Map) {
        entries.add(Entry.fromMap(value));
      }
    }
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<void> upsert(Entry entry) async {
    await _box.put(entry.id, entry.toMap());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }
}

