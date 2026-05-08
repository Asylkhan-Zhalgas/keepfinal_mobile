import '../entities/entry.dart';
import '../repositories/entries_repository.dart';

class GetEntries {
  final EntriesRepository _repo;
  GetEntries(this._repo);

  Future<List<Entry>> call() => _repo.getAll();
}

