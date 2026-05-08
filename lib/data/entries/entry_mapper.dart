import '../../domain/entries/entities/entry.dart';

class EntryMapper {
  static Map<String, Object?> toMap(Entry entry) => {
        'id': entry.id,
        'title': entry.title,
        'content': entry.content,
        'date': entry.date.toIso8601String(),
        'createdAt': entry.createdAt.toIso8601String(),
        'updatedAt': entry.updatedAt.toIso8601String(),
      };

  static Entry fromMap(Map<dynamic, dynamic> map) {
    return Entry(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}

