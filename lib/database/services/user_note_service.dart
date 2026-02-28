import 'package:isar_community/isar.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/database/isar.dart';
import 'package:notes_vault/database/models/user_note.dart';

class UserNoteService {
  static Isar get _isar => IsarDb.isar;

  // ── Create ──────────────────────────────────────────────────────────────

  /// Creates a new [UserNote] and returns it with its assigned ID.
  static Future<UserNote> createNote({
    required String title,
    required String content,
    required NoteType noteType,
  }) async {
    final note = UserNote()
      ..title = title
      ..content = content
      ..noteType = noteType
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userNotes.put(note);
    });

    return note;
  }

  // ── Read ────────────────────────────────────────────────────────────────

  /// Returns all notes, sorted by [updatedAt] descending (newest first).
  static Future<List<UserNote>> getAllNotes() async {
    return _isar.userNotes.where().sortByUpdatedAtDesc().findAll();
  }

  /// Returns a single note by [id], or `null` if not found.
  static Future<UserNote?> getNoteById(int id) async {
    return _isar.userNotes.get(id);
  }

  /// Returns notes filtered by [noteType], sorted by [updatedAt] descending.
  static Future<List<UserNote>> getNotesByType(NoteType noteType) async {
    return _isar.userNotes
        .filter()
        .noteTypeEqualTo(noteType)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  /// Returns notes whose title or content contains the [query] string
  /// (case-insensitive).
  static Future<List<UserNote>> searchNotes(String query) async {
    return _isar.userNotes
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .contentContains(query, caseSensitive: false)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  // ── Update ──────────────────────────────────────────────────────────────

  /// Updates an existing note. Only non-null fields are changed.
  /// Returns `true` if the note was found and updated.
  static Future<bool> updateNote(
    int id, {
    String? title,
    String? content,
    NoteType? noteType,
  }) async {
    final note = await _isar.userNotes.get(id);
    if (note == null) return false;

    if (title != null) note.title = title;
    if (content != null) note.content = content;
    if (noteType != null) note.noteType = noteType;
    note.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userNotes.put(note);
    });

    return true;
  }

  // ── Delete ──────────────────────────────────────────────────────────────

  /// Deletes a note by [id]. Returns `true` if the note existed.
  static Future<bool> deleteNote(int id) async {
    return _isar.writeTxn(() async {
      return _isar.userNotes.delete(id);
    });
  }

  /// Deletes all notes. Returns the number of deleted notes.
  static Future<int> deleteAllNotes() async {
    return _isar.writeTxn(() async {
      return _isar.userNotes.where().deleteAll();
    });
  }
}
