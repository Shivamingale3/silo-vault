import 'package:flutter/widgets.dart';
import 'package:isar_community/isar.dart';

class IsarDb {
  static late Isar isar;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // final dir = await getApplicationDocumentsDirectory();
    // isar = await Isar.open([], directory: dir.path, inspector: true);
  }
}
