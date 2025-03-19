import 'dart:developer';

import 'package:minha_agenda/src/utils/app_strings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseOperations {
  static final DataBaseOperations _instance = DataBaseOperations._internal();
  late Database _database;
  bool _initialized = false;

  factory DataBaseOperations() => _instance;

  DataBaseOperations._internal();

  Database get database => _database;

  Future<void> initOperations() async {
    if (!_initialized) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'minha_agenda.db'),
        version: 1,
        onCreate: (db, version) async {
          await _createTables(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 1) {
            await _createTables(db);
          }
        },
      );
      _initialized = true;
      log("Banco de dados inicializado!");
    }
  }

  Future<void> _createTables(Database db) async {
    log("Criando tabelas...");

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${AppStrings.Usuario} (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        senha TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${AppStrings.Contato} (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        cpf TEXT UNIQUE NOT NULL,
        telefone TEXT NOT NULL,
        latitude TEXT,
        longitude TEXT,
        cep TEXT,
        logradouro TEXT,
        unidade TEXT,
        bairro TEXT,
        localidade TEXT,
        uf TEXT,
        numero INTEGER,
        complemento TEXT,
        estado TEXT,
        regiao TEXT,
        ddd TEXT
      );
    ''');

    log("Tabelas criadas com sucesso!");
  }

  Future<void> deleteDatabasew() async {
    final databasePath = join(await getDatabasesPath(), 'minha_agenda.db');
    await deleteDatabase(databasePath);
    _initialized = false;
    log("Banco de dados deletado com sucesso!");
  }
}
