import 'package:isar_community/isar.dart';
import 'package:notes_vault/core/security/encryption_service.dart';
import 'package:notes_vault/database/isar.dart';
import 'package:notes_vault/database/models/vault_item_entity.dart';
import 'package:notes_vault/features/models/vault_item.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:uuid/uuid.dart';

class VaultRepository {
  static const _uuid = Uuid();

  // ── CRUD Operations ──

  Future<void> addItem(VaultItem item) async {
    final entity = await _toEntity(item);
    await IsarDb.isar.writeTxn(() async {
      await IsarDb.isar.vaultItemEntitys.put(entity);
    });
  }

  Future<void> addAllItems(List<VaultItem> items) async {
    final entities = await Future.wait(items.map(_toEntity));
    await IsarDb.isar.writeTxn(() async {
      await IsarDb.isar.vaultItemEntitys.putAll(entities);
    });
  }

  Future<void> updateItem(VaultItem item) async {
    final existing = await IsarDb.isar.vaultItemEntitys.getByItemId(item.id);
    if (existing == null) return;

    final entity = await _toEntity(item);
    entity.isarId = existing.isarId;
    entity.updatedAt = DateTime.now();
    entity.isDirty = true;

    await IsarDb.isar.writeTxn(() async {
      await IsarDb.isar.vaultItemEntitys.put(entity);
    });
  }

  Future<void> deleteItem(String itemId) async {
    await IsarDb.isar.writeTxn(() async {
      await IsarDb.isar.vaultItemEntitys.deleteByItemId(itemId);
    });
  }

  Future<List<VaultItem>> getAllItems() async {
    final entities = await IsarDb.isar.vaultItemEntitys.where().findAll();
    return Future.wait(entities.map(_fromEntity));
  }

  Future<VaultItem?> getById(String itemId) async {
    final entity = await IsarDb.isar.vaultItemEntitys.getByItemId(itemId);
    if (entity == null) return null;
    return _fromEntity(entity);
  }

  // ── Convenience Operations ──

  Future<void> toggleFavorite(String itemId) async {
    final entity = await IsarDb.isar.vaultItemEntitys.getByItemId(itemId);
    if (entity == null) return;

    entity.isFavorite = !entity.isFavorite;
    entity.isDirty = true;

    await IsarDb.isar.writeTxn(() async {
      await IsarDb.isar.vaultItemEntitys.put(entity);
    });
  }

  Future<void> trashItem(String itemId) async {
    final entity = await IsarDb.isar.vaultItemEntitys.getByItemId(itemId);
    if (entity == null) return;

    entity.isTrashed = true;
    entity.isDirty = true;

    await IsarDb.isar.writeTxn(() async {
      await IsarDb.isar.vaultItemEntitys.put(entity);
    });
  }

  Future<void> restoreItem(String itemId) async {
    final entity = await IsarDb.isar.vaultItemEntitys.getByItemId(itemId);
    if (entity == null) return;

    entity.isTrashed = false;
    entity.isDirty = true;

    await IsarDb.isar.writeTxn(() async {
      await IsarDb.isar.vaultItemEntitys.put(entity);
    });
  }

  Future<int> getItemCount() async {
    return IsarDb.isar.vaultItemEntitys.count();
  }

  /// Returns raw entities (for DB viewer — shows encrypted data).
  Future<List<VaultItemEntity>> getAllRawEntities() async {
    return IsarDb.isar.vaultItemEntitys.where().findAll();
  }

  // ── Entity ↔ VaultItem Mappers (encrypt/decrypt bridge) ──

  Future<VaultItemEntity> _toEntity(VaultItem item) async {
    final entity = VaultItemEntity()
      ..itemId = item.id.isEmpty ? _uuid.v4() : item.id
      ..type = _noteTypeToEnum(item.type)
      ..encryptedTitle = await EncryptionService.encrypt(item.title)
      ..encryptedContent = item.content != null
          ? await EncryptionService.encrypt(item.content!)
          : null
      ..encryptedUsername = item.username != null
          ? await EncryptionService.encrypt(item.username!)
          : null
      ..encryptedPassword = item.password != null
          ? await EncryptionService.encrypt(item.password!)
          : null
      ..encryptedWebsiteUrl = item.websiteUrl != null
          ? await EncryptionService.encrypt(item.websiteUrl!)
          : null
      ..category = _categoryToEnum(item.category)
      ..tags = item.tags.map((t) => t.name).toList()
      ..isFavorite = item.isFavorite
      ..isTrashed = item.isTrashed
      ..passwordStrength = item.passwordStrength != null
          ? _strengthToEnum(item.passwordStrength!)
          : null
      ..createdAt = item.createdAt
      ..updatedAt = item.updatedAt
      ..lastAccessedAt = item.lastAccessedAt
      ..isDirty = true;

    return entity;
  }

  Future<VaultItem> _fromEntity(VaultItemEntity entity) async {
    return VaultItem(
      id: entity.itemId,
      type: _enumToNoteType(entity.type),
      title: entity.encryptedTitle != null
          ? await EncryptionService.decrypt(entity.encryptedTitle!)
          : '',
      content: entity.encryptedContent != null
          ? await EncryptionService.decrypt(entity.encryptedContent!)
          : null,
      username: entity.encryptedUsername != null
          ? await EncryptionService.decrypt(entity.encryptedUsername!)
          : null,
      password: entity.encryptedPassword != null
          ? await EncryptionService.decrypt(entity.encryptedPassword!)
          : null,
      websiteUrl: entity.encryptedWebsiteUrl != null
          ? await EncryptionService.decrypt(entity.encryptedWebsiteUrl!)
          : null,
      category: _enumToCategory(entity.category),
      tags: entity.tags
          .map(
            (name) => ItemTag.values.firstWhere(
              (t) => t.name == name,
              orElse: () => ItemTag.important,
            ),
          )
          .toList(),
      isFavorite: entity.isFavorite,
      isTrashed: entity.isTrashed,
      passwordStrength: entity.passwordStrength != null
          ? _enumToStrength(entity.passwordStrength!)
          : null,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastAccessedAt: entity.lastAccessedAt,
    );
  }

  // ── Enum Converters ──

  static NoteTypeEnum _noteTypeToEnum(NoteType t) =>
      NoteTypeEnum.values.byName(t.name);

  static NoteType _enumToNoteType(NoteTypeEnum e) =>
      NoteType.values.byName(e.name);

  static NoteCategoryEnum _categoryToEnum(NoteCategory c) =>
      NoteCategoryEnum.values.byName(c.name);

  static NoteCategory _enumToCategory(NoteCategoryEnum e) =>
      NoteCategory.values.byName(e.name);

  static PasswordStrengthEnum _strengthToEnum(PasswordStrength s) =>
      PasswordStrengthEnum.values.byName(s.name);

  static PasswordStrength _enumToStrength(PasswordStrengthEnum e) =>
      PasswordStrength.values.byName(e.name);
}
