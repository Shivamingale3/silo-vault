import 'package:flutter/widgets.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notes_vault/database/models/vault_item_entity.dart';
import 'package:notes_vault/database/seed_service.dart';

class IsarDb {
  static late Isar isar;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [VaultItemEntitySchema],
      directory: dir.path,
      inspector: false,
    );
    await SeedService.seedIfEmpty();
  }
}
