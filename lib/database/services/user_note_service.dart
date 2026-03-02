import 'package:isar_community/isar.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/core/security/encryption_service.dart';
import 'package:notes_vault/database/isar.dart';
import 'package:notes_vault/database/models/user_note.dart';

class UserNoteService {
  static Isar get _isar => IsarDb.isar;

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Decrypts the [content] field of a single note in-place.
  static Future<UserNote> _decryptNote(UserNote note) async {
    note.content = await EncryptionService.decrypt(note.content);
    return note;
  }

  /// Decrypts [content] on every note in the list.
  static Future<List<UserNote>> _decryptNotes(List<UserNote> notes) async {
    for (final note in notes) {
      note.content = await EncryptionService.decrypt(note.content);
    }
    return notes;
  }

  // ── Create ──────────────────────────────────────────────────────────────

  /// Creates a new [UserNote] and returns it with its assigned ID.
  /// The [content] is encrypted before being stored.
  static Future<UserNote> createNote({
    required String title,
    required String content,
    required NoteType noteType,
  }) async {
    final encryptedContent = await EncryptionService.encrypt(content);

    final note = UserNote()
      ..title = title
      ..content = encryptedContent
      ..noteType = noteType
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userNotes.put(note);
    });

    // Return the note with plaintext content for immediate use.
    note.content = content;
    return note;
  }

  // ── Read ────────────────────────────────────────────────────────────────

  /// Returns all notes, sorted by [updatedAt] descending (newest first).
  /// Content is decrypted before returning.
  static Future<List<UserNote>> getAllNotes() async {
    final notes = await _isar.userNotes.where().sortByUpdatedAtDesc().findAll();
    return _decryptNotes(notes);
  }

  /// Returns a single note by [id], or `null` if not found.
  /// Content is decrypted before returning.
  static Future<UserNote?> getNoteById(int id) async {
    final note = await _isar.userNotes.get(id);
    if (note == null) return null;
    return _decryptNote(note);
  }

  /// Returns notes filtered by [noteType], sorted by [updatedAt] descending.
  /// Content is decrypted before returning.
  static Future<List<UserNote>> getNotesByType(NoteType noteType) async {
    final notes = await _isar.userNotes
        .filter()
        .noteTypeEqualTo(noteType)
        .sortByUpdatedAtDesc()
        .findAll();
    return _decryptNotes(notes);
  }

  /// Searches notes whose **title** contains the [query] string
  /// (case-insensitive). Content search is not supported on encrypted data;
  /// use client-side filtering after decryption if needed.
  static Future<List<UserNote>> searchNotes(String query) async {
    final notes = await _isar.userNotes
        .filter()
        .titleContains(query, caseSensitive: false)
        .sortByUpdatedAtDesc()
        .findAll();
    return _decryptNotes(notes);
  }

  // ── Update ──────────────────────────────────────────────────────────────

  /// Updates an existing note. Only non-null fields are changed.
  /// [content] is encrypted before storage.
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
    if (content != null) {
      note.content = await EncryptionService.encrypt(content);
    }
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
