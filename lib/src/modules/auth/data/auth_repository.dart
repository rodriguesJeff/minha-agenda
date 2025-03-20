import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';

class AuthRepository {
  final AuthDatasource datasource;

  AuthRepository({required this.datasource});

  Future<Either<String, bool>> cadastrarUsuario(UsuarioModel usuario) async {
    try {
      final response = await datasource.cadastrarUsuario(usuario.toJson());

      if (response) {
        return Right(response);
      } else {
        return Left('Falha no processo do registro');
      }
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, UsuarioModel>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await datasource.login(email: email, senha: senha);

      return Right(UsuarioModel.fromJson(response));
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }
}
