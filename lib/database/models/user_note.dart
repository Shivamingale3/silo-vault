import 'package:isar_community/isar.dart';
import 'package:notes_vault/core/enums/db_enums.dart';

part 'user_note.g.dart';

@collection
class UserNote {
  Id noteId = Isar.autoIncrement;
  late String title;
  late String content;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  @enumerated
  late NoteType noteType;
}
