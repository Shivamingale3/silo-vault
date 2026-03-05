import 'package:isar_community/isar.dart';

part 'vault_item_entity.g.dart';

@collection
class VaultItemEntity {
  Id isarId = Isar.autoIncrement;

  /// UUID-based ID for cross-device sync identification.
  @Index(unique: true)
  late String itemId;

  /// 'note' or 'password' — stored as plain string for Isar indexing.
  @Index()
  @Enumerated(EnumType.name)
  late NoteTypeEnum type;

  // ── Encrypted fields (base64 ciphertext from EncryptionService) ──
  String? encryptedTitle;
  String? encryptedContent;
  String? encryptedUsername;
  String? encryptedPassword;
  String? encryptedWebsiteUrl;

  // ── Plain fields (needed for indexing / filtering) ──
  @Index()
  @Enumerated(EnumType.name)
  late NoteCategoryEnum category;

  List<String> tags;

  @Index()
  bool isFavorite;

  @Index()
  bool isTrashed;

  @Enumerated(EnumType.name)
  PasswordStrengthEnum? passwordStrength;

  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? lastAccessedAt;

  // ── Sync-ready fields ──
  DateTime? lastSyncedAt;
  bool isDirty;

  VaultItemEntity({
    this.encryptedTitle,
    this.encryptedContent,
    this.encryptedUsername,
    this.encryptedPassword,
    this.encryptedWebsiteUrl,
    this.tags = const [],
    this.isFavorite = false,
    this.isTrashed = false,
    this.passwordStrength,
    this.lastAccessedAt,
    this.lastSyncedAt,
    this.isDirty = true,
  });
}

/// Mirrors [NoteType] from db_enums.dart for Isar storage.
enum NoteTypeEnum { note, password }

/// Mirrors [NoteCategory] from db_enums.dart for Isar storage.
enum NoteCategoryEnum {
  personal,
  work,
  finance,
  social,
  development,
  entertainment,
  travel,
  health,
}

/// Mirrors [PasswordStrength] from db_enums.dart for Isar storage.
enum PasswordStrengthEnum { weak, fair, strong, veryStrong }
