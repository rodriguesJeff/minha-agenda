import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseOperations {
  static final DataBaseOperations _instance = DataBaseOperations._internal();
  late Database database;
  bool _initialized = false;

  factory DataBaseOperations() {
    return _instance;
  }

  DataBaseOperations._internal();

  Future<void> initOperations() async {
    if (!_initialized) {
      database = await openDatabase(join(await getDatabasesPath(), 'minha_agenda.db'), version: 1, onCreate: (db, version) async {}, onUpgrade: (db, oldVersion, newVersion) async {});
      _initialized = true;
    }
  }
}
