import '../entities/entry.dart';
import '../repositories/entries_repository.dart';

class SaveEntry {
  final EntriesRepository _repo;
  SaveEntry(this._repo);

  Future<void> call(Entry entry) => _repo.upsert(entry);
}

