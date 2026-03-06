import 'package:isar_community/isar.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/security/encryption_service.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/core/services/auth_service.dart';
import 'package:notes_vault/core/services/connectivity_service.dart';
import 'package:notes_vault/database/firestore_repository.dart';
import 'package:notes_vault/database/isar.dart';
import 'package:notes_vault/database/models/vault_item_entity.dart';

/// Orchestrates push/pull sync between local Isar DB and Firestore.
/// All data is encrypted before upload — Firestore never sees plaintext.
class SyncService {
  // ── First-Time Sync Setup ──

  /// Initializes sync: wraps the device key → uploads to Firestore → pushes all data.
  static Future<SyncResult> initializeSync(String syncPassword) async {
    try {
      if (!await ConnectivityService.isOnline()) {
        return SyncResult(success: false, message: 'No internet connection');
      }

      if (!await AuthService.refreshTokenIfNeeded()) {
        return SyncResult(
          success: false,
          message: 'Authentication expired. Please sign in again.',
        );
      }

      // Wrap the device encryption key with the sync password
      final wrapped = await EncryptionService.wrapKey(syncPassword);

      // Upload wrapped key to Firestore
      await FirestoreRepository.uploadWrappedKey(
        wrappedKey: wrapped['wrappedKey']!,
        salt: wrapped['salt']!,
      );

      // Mark sync as enabled
      await SecureStorage.write(AppKeys.syncEnabled, 'true');

      // Push all items to Firestore
      final pushResult = await pushDirty(pushAll: true);

      return SyncResult(
        success: true,
        message: 'Sync initialized. ${pushResult.itemCount} items uploaded.',
        itemCount: pushResult.itemCount,
      );
    } catch (e) {
      return SyncResult(success: false, message: 'Sync init failed: $e');
    }
  }

  // ── New Device Setup ──

  /// Sets up sync on a new device: downloads wrapped key → unwraps → pulls all data.
  static Future<SyncResult> setupFromRemote(String syncPassword) async {
    try {
      if (!await ConnectivityService.isOnline()) {
        return SyncResult(success: false, message: 'No internet connection');
      }

      if (!await AuthService.refreshTokenIfNeeded()) {
        return SyncResult(success: false, message: 'Authentication expired');
      }

      // Download wrapped key
      final keyData = await FirestoreRepository.downloadWrappedKey();
      if (keyData == null) {
        return SyncResult(
          success: false,
          message:
              'No sync key found. Set up sync on your primary device first.',
        );
      }

      // Unwrap the key using the sync password
      final success = await EncryptionService.unwrapKey(
        wrappedKeyBase64: keyData['wrappedKey']!,
        saltBase64: keyData['salt']!,
        syncPassword: syncPassword,
      );

      if (!success) {
        return SyncResult(
          success: false,
          message: 'Wrong sync password. Please try again.',
        );
      }

      // Mark sync as enabled
      await SecureStorage.write(AppKeys.syncEnabled, 'true');

      // Pull all items from Firestore
      final pullResult = await pullRemote();

      return SyncResult(
        success: true,
        message: 'Sync setup complete. ${pullResult.itemCount} items synced.',
        itemCount: pullResult.itemCount,
      );
    } catch (e) {
      return SyncResult(success: false, message: 'Setup failed: $e');
    }
  }

  // ── Push (Upload dirty items) ──

  /// Uploads items with `isDirty == true` to Firestore.
  /// If [pushAll] is true, pushes everything regardless of dirty flag.
  static Future<SyncResult> pushDirty({bool pushAll = false}) async {
    try {
      if (!await _preflightCheck()) {
        return SyncResult(success: false, message: 'Sync not ready');
      }

      final isar = IsarDb.isar;
      List<VaultItemEntity> entities;

      if (pushAll) {
        entities = await isar.vaultItemEntitys.where().findAll();
      } else {
        entities = await isar.vaultItemEntitys
            .filter()
            .isDirtyEqualTo(true)
            .findAll();
      }

      if (entities.isEmpty) {
        return SyncResult(
          success: true,
          message: 'Nothing to push',
          itemCount: 0,
        );
      }

      // Batch upload in chunks of 450 (Firestore batch limit is 500)
      const batchSize = 450;
      for (var i = 0; i < entities.length; i += batchSize) {
        final end = (i + batchSize < entities.length)
            ? i + batchSize
            : entities.length;
        final batch = entities.sublist(i, end);
        await FirestoreRepository.batchUpsert(batch);
      }

      // Mark all pushed items as clean
      await isar.writeTxn(() async {
        for (final entity in entities) {
          entity.isDirty = false;
          entity.lastSyncedAt = DateTime.now();
          await isar.vaultItemEntitys.put(entity);
        }
      });

      return SyncResult(
        success: true,
        message: '${entities.length} items pushed',
        itemCount: entities.length,
      );
    } catch (e) {
      return SyncResult(success: false, message: 'Push failed: $e');
    }
  }

  // ── Pull (Download remote changes) ──

  /// Downloads items from Firestore that are newer than our latest sync.
  static Future<SyncResult> pullRemote() async {
    try {
      if (!await _preflightCheck()) {
        return SyncResult(success: false, message: 'Sync not ready');
      }

      final isar = IsarDb.isar;

      // Find the latest lastSyncedAt across all local items
      final latestSynced = await isar.vaultItemEntitys
          .where()
          .sortByLastSyncedAtDesc()
          .findFirst();

      final since =
          latestSynced?.lastSyncedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      List<Map<String, dynamic>> remoteMaps;
      if (latestSynced == null) {
        // First pull — get everything
        remoteMaps = await FirestoreRepository.getAllItems();
      } else {
        remoteMaps = await FirestoreRepository.getModifiedSince(since);
      }

      if (remoteMaps.isEmpty) {
        return SyncResult(success: true, message: 'Up to date', itemCount: 0);
      }

      int merged = 0;
      await isar.writeTxn(() async {
        for (final map in remoteMaps) {
          final isDeleted = map['isDeleted'] as bool? ?? false;
          final remoteItemId = map['itemId'] as String;

          if (isDeleted) {
            await isar.vaultItemEntitys.deleteByItemId(remoteItemId);
            merged++;
            continue;
          }

          final remoteEntity = FirestoreRepository.mapToEntity(map);
          final localEntity = await isar.vaultItemEntitys.getByItemId(
            remoteItemId,
          );

          if (localEntity == null) {
            // New item from remote
            await isar.vaultItemEntitys.put(remoteEntity);
            merged++;
          } else {
            // Conflict resolution: last-write-wins
            if (remoteEntity.updatedAt.isAfter(localEntity.updatedAt)) {
              remoteEntity.isarId = localEntity.isarId;
              await isar.vaultItemEntitys.put(remoteEntity);
              merged++;
            }
            // else: local is newer, skip (it will be pushed next)
          }
        }
      });

      return SyncResult(
        success: true,
        message: '$merged items pulled',
        itemCount: merged,
      );
    } catch (e) {
      return SyncResult(success: false, message: 'Pull failed: $e');
    }
  }

  // ── Full Sync ──

  /// Performs a full push + pull cycle.
  static Future<SyncResult> fullSync() async {
    final pushResult = await pushDirty();
    if (!pushResult.success) return pushResult;

    final pullResult = await pullRemote();
    if (!pullResult.success) return pullResult;

    return SyncResult(
      success: true,
      message:
          'Synced: ${pushResult.itemCount} pushed, ${pullResult.itemCount} pulled',
      itemCount: (pushResult.itemCount ?? 0) + (pullResult.itemCount ?? 0),
    );
  }

  // ── Helpers ──

  /// Checks if sync is enabled in SecureStorage.
  static Future<bool> isSyncEnabled() async {
    final val = await SecureStorage.read(AppKeys.syncEnabled);
    return val == 'true';
  }

  /// Disables sync (keeps local data).
  static Future<void> disableSync() async {
    await SecureStorage.write(AppKeys.syncEnabled, 'false');
  }

  /// Pre-flight check for sync operations.
  static Future<bool> _preflightCheck() async {
    if (!await isSyncEnabled()) return false;
    if (!await ConnectivityService.isOnline()) return false;
    if (!AuthService.isAuthenticated) return false;
    return await AuthService.refreshTokenIfNeeded();
  }
}

/// Result of a sync operation.
class SyncResult {
  final bool success;
  final String message;
  final int? itemCount;

  const SyncResult({
    required this.success,
    required this.message,
    this.itemCount,
  });
}
