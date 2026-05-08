import '../repositories/entries_repository.dart';

class DeleteEntry {
  final EntriesRepository _repo;
  DeleteEntry(this._repo);

  Future<void> call(String id) => _repo.delete(id);
}

