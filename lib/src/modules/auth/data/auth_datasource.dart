import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';
import 'package:minha_agenda/src/utils/db_operations.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthDatasource {
  Future<bool> cadastrarUsuario(Map<String, dynamic> payload);
  Future<Map<String, dynamic>> login({required String email, required String senha});
}

class AuthDatasourceImpl implements AuthDatasource {
  final DataBaseOperations database;

  AuthDatasourceImpl(this.database);

  Future<Database> get _db async {
    await database.initOperations();
    return database.database;
  }

  @override
  Future<bool> cadastrarUsuario(Map<String, dynamic> payload) async {
    try {
      final db = await _db;

      final response = await db.insert(AppStrings.Usuario, payload);

      return response == 1;
    } catch (e) {
      throw DBFailure(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> login({required String email, required String senha}) async {
    try {
      final db = await _db;

      final usuarioEncontrado = await db.query(AppStrings.Usuario, where: 'email = ?', whereArgs: [email]);

      if (usuarioEncontrado.isNotEmpty && usuarioEncontrado.first["senha"] == senha) {
        return usuarioEncontrado.first;
      } else {
        throw DBFailure(message: "Usuário não existente");
      }
    } catch (e) {
      throw DBFailure(message: e.toString());
    }
  }
}
