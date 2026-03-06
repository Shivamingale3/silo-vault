import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silo_vault/database/vault_repository.dart';
import 'package:silo_vault/features/models/vault_item.dart';

/// Holds all vault items in memory after decryption from DB.
/// UI reads from this provider; writes go through the notifier
/// which persists to DB and updates the in-memory list.
class VaultNotifier extends AsyncNotifier<List<VaultItem>> {
  late final VaultRepository _repository;

  @override
  Future<List<VaultItem>> build() async {
    _repository = VaultRepository();
    return _repository.getAllItems();
  }

  Future<void> addItem(VaultItem item) async {
    await _repository.addItem(item);
    state = AsyncData(await _repository.getAllItems());
  }

  Future<void> updateItem(VaultItem item) async {
    await _repository.updateItem(item);
    state = AsyncData(await _repository.getAllItems());
  }

  Future<void> deleteItem(String itemId) async {
    await _repository.deleteItem(itemId);
    state = AsyncData(await _repository.getAllItems());
  }

  Future<void> toggleFavorite(String itemId) async {
    await _repository.toggleFavorite(itemId);
    state = AsyncData(await _repository.getAllItems());
  }

  Future<void> trashItem(String itemId) async {
    await _repository.trashItem(itemId);
    state = AsyncData(await _repository.getAllItems());
  }

  Future<void> restoreItem(String itemId) async {
    await _repository.restoreItem(itemId);
    state = AsyncData(await _repository.getAllItems());
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(await _repository.getAllItems());
  }
}

final vaultProvider = AsyncNotifierProvider<VaultNotifier, List<VaultItem>>(
  VaultNotifier.new,
);

// ── Derived Providers ──

final activeItemsProvider = Provider<List<VaultItem>>((ref) {
  final items = ref.watch(vaultProvider).value ?? [];
  return items.where((i) => !i.isTrashed).toList();
});

final favoriteItemsProvider = Provider<List<VaultItem>>((ref) {
  final items = ref.watch(activeItemsProvider);
  return items.where((i) => i.isFavorite).toList();
});

final passwordItemsProvider = Provider<List<VaultItem>>((ref) {
  final items = ref.watch(activeItemsProvider);
  return items.where((i) => i.isPassword).toList();
});

final noteItemsProvider = Provider<List<VaultItem>>((ref) {
  final items = ref.watch(activeItemsProvider);
  return items.where((i) => i.isNote).toList();
});

final trashedItemsProvider = Provider<List<VaultItem>>((ref) {
  final items = ref.watch(vaultProvider).value ?? [];
  return items.where((i) => i.isTrashed).toList();
});

final recentItemsProvider = Provider.family<List<VaultItem>, int>((ref, count) {
  final items = List<VaultItem>.from(ref.watch(activeItemsProvider));
  items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return items.take(count).toList();
});

/// Stats used by StatsGrid and profile section.
class VaultStats {
  final int passwordCount;
  final int noteCount;
  final int favoriteCount;
  final int trashCount;

  const VaultStats({
    required this.passwordCount,
    required this.noteCount,
    required this.favoriteCount,
    required this.trashCount,
  });
}

final vaultStatsProvider = Provider<VaultStats>((ref) {
  return VaultStats(
    passwordCount: ref.watch(passwordItemsProvider).length,
    noteCount: ref.watch(noteItemsProvider).length,
    favoriteCount: ref.watch(favoriteItemsProvider).length,
    trashCount: ref.watch(trashedItemsProvider).length,
  );
});
