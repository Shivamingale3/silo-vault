import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silo_vault/core/services/auth_service.dart';
import 'package:silo_vault/database/models/vault_item_entity.dart';

/// Handles all Firestore CRUD for encrypted vault items and sync config.
/// Data stored here is already encrypted — Firestore never sees plaintext.
class FirestoreRepository {
  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Base path for the current user's data.
  static String get _userPath {
    final uid = AuthService.uid;
    if (uid == null) throw Exception('User not authenticated');
    return 'users/$uid';
  }

  static CollectionReference<Map<String, dynamic>> get _vaultCollection =>
      _db.collection('$_userPath/vault_items');

  static DocumentReference<Map<String, dynamic>> get _configDoc =>
      _db.doc('$_userPath/config/encryption');

  // ── Vault Item CRUD ──

  /// Upserts an encrypted entity to Firestore.
  static Future<void> upsertItem(VaultItemEntity entity) async {
    await _vaultCollection
        .doc(entity.itemId)
        .set(_entityToMap(entity), SetOptions(merge: true));
  }

  /// Batch upsert multiple entities (Firestore limit: 500 per batch).
  static Future<void> batchUpsert(List<VaultItemEntity> entities) async {
    final batch = _db.batch();
    for (final entity in entities) {
      batch.set(
        _vaultCollection.doc(entity.itemId),
        _entityToMap(entity),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }

  /// Soft-deletes an item in Firestore (sets isDeleted flag).
  static Future<void> softDeleteItem(String itemId) async {
    await _vaultCollection.doc(itemId).set({
      'isDeleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Gets all vault items from Firestore (excludes soft-deleted).
  static Future<List<Map<String, dynamic>>> getAllItems() async {
    final snapshot = await _vaultCollection
        .where('isDeleted', isEqualTo: false)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Gets items modified after a given timestamp.
  static Future<List<Map<String, dynamic>>> getModifiedSince(
    DateTime since,
  ) async {
    final snapshot = await _vaultCollection
        .where('updatedAt', isGreaterThan: Timestamp.fromDate(since))
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ── Encryption Config ──

  /// Uploads the wrapped encryption key and salt for cross-device sync.
  static Future<void> uploadWrappedKey({
    required String wrappedKey,
    required String salt,
  }) async {
    await _configDoc.set({
      'wrappedKey': wrappedKey,
      'salt': salt,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Downloads the wrapped key and salt. Returns null if not set.
  static Future<Map<String, String>?> downloadWrappedKey() async {
    final doc = await _configDoc.get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return {
      'wrappedKey': data['wrappedKey'] as String,
      'salt': data['salt'] as String,
    };
  }

  /// Checks if wrapped key exists in Firestore.
  static Future<bool> hasWrappedKey() async {
    final doc = await _configDoc.get();
    return doc.exists;
  }

  // ── Entity ↔ Map Conversion ──

  static Map<String, dynamic> _entityToMap(VaultItemEntity entity) {
    return {
      'itemId': entity.itemId,
      'type': entity.type.name,
      'encryptedTitle': entity.encryptedTitle,
      'encryptedContent': entity.encryptedContent,
      'encryptedUsername': entity.encryptedUsername,
      'encryptedPassword': entity.encryptedPassword,
      'encryptedWebsiteUrl': entity.encryptedWebsiteUrl,
      'category': entity.category.name,
      'tags': entity.tags,
      'isFavorite': entity.isFavorite,
      'isTrashed': entity.isTrashed,
      'passwordStrength': entity.passwordStrength?.name,
      'createdAt': Timestamp.fromDate(entity.createdAt),
      'updatedAt': Timestamp.fromDate(entity.updatedAt),
      'isDeleted': false,
    };
  }

  /// Converts a Firestore map back to a VaultItemEntity.
  static VaultItemEntity mapToEntity(Map<String, dynamic> map) {
    return VaultItemEntity(
        encryptedTitle: map['encryptedTitle'] as String?,
        encryptedContent: map['encryptedContent'] as String?,
        encryptedUsername: map['encryptedUsername'] as String?,
        encryptedPassword: map['encryptedPassword'] as String?,
        encryptedWebsiteUrl: map['encryptedWebsiteUrl'] as String?,
        tags:
            (map['tags'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        isFavorite: map['isFavorite'] as bool? ?? false,
        isTrashed: map['isTrashed'] as bool? ?? false,
        passwordStrength: map['passwordStrength'] != null
            ? PasswordStrengthEnum.values.byName(
                map['passwordStrength'] as String,
              )
            : null,
      )
      ..itemId = map['itemId'] as String
      ..type = NoteTypeEnum.values.byName(map['type'] as String)
      ..category = NoteCategoryEnum.values.byName(map['category'] as String)
      ..createdAt = (map['createdAt'] as Timestamp).toDate()
      ..updatedAt = (map['updatedAt'] as Timestamp).toDate()
      ..isDirty = false
      ..lastSyncedAt = DateTime.now();
  }
}
