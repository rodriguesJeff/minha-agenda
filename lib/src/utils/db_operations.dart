import 'dart:developer';

import 'package:sembast_web/sembast_web.dart';

class DataBaseOperations {
  static final DataBaseOperations _instance = DataBaseOperations._internal();

  late Database _database;
  bool _initialized = false;

  factory DataBaseOperations() => _instance;

  DataBaseOperations._internal();

  Database get database => _database;

  Future<void> initOperations() async {
    if (_initialized) return;

    final dbFactory = databaseFactoryWeb;
    _database = await dbFactory.openDatabase('minha_agenda_web.db');

    _initialized = true;
    log("Banco de dados inicializado (Web)!");
  }

  Future<void> deleteDatabase() async {
    final dbFactory = databaseFactoryWeb;
    await dbFactory.deleteDatabase('minha_agenda_web.db');
    _initialized = false;
    log("Banco de dados deletado com sucesso (Web)!");
  }
}
