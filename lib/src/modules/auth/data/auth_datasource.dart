import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';
import 'package:minha_agenda/src/utils/db_operations.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthDatasource {
  Future<bool> cadastrarUsuario(Map<String, dynamic> payload);
  Future<Either<AppFailures, UsuarioModel>> login();
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
      throw (DBFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailures, UsuarioModel>> login() {
    // TODO: implement login
    throw UnimplementedError();
  }
}
