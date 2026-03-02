import 'package:flutter/widgets.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDb {
  static late Isar isar;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    // isar = await Isar.open([], directory: dir.path, inspector: true);
  }
}
