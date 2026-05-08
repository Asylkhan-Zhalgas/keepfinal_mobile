import '../entities/entry.dart';

abstract class EntriesRepository {
  Future<List<Entry>> getAll();
  Future<void> upsert(Entry entry);
  Future<void> delete(String id);
}

