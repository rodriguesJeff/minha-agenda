import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:localstorage/localstorage.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';

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

      final usuario = UsuarioModel.fromJson(response);

      localStorage.setItem(AppStrings.Usuario, jsonEncode(usuario.toJson()));

      return Right(usuario);
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, UsuarioModel>> buscarUsuarioLogado() async {
    try {
      final response = localStorage.getItem(AppStrings.Usuario);

      if (response != null) {
        final usuario = UsuarioModel.fromJson(jsonDecode(response));

        return Right(usuario);
      } else {
        return Left('Usuário não encontrado');
      }
    } catch (e) {
      return Left("Erro na obtenção do usuário logado");
    }
  }

  Future<Either<String, bool>> apagarUsuario() async {
    try {
      final response = await datasource.apagarUsuario();

      if (response) {
        localStorage.clear();

        return Right(response);
      } else {
        return Left('Falha no processo de exclusão');
      }
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }
}
