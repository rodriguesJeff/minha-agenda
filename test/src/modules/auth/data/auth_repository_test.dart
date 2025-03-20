import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDatasource extends Mock implements AuthDatasource {}

class FakeUsuarioModel extends Fake implements UsuarioModel {
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

void main() {
  late MockAuthDatasource datasource;
  late AuthRepository repository;

  setUp(() {
    datasource = MockAuthDatasource();
    repository = AuthRepository(datasource: datasource);
  });

  group("cadastrarUsuario", () {
    test("Deve retornar Left(String) quando ocorrer algum erro no registro de usuario", () async {
      when(() => datasource.cadastrarUsuario(any())).thenThrow(DBFailure(message: 'Erro ao registrar usuario'));

      final result = await repository.cadastrarUsuario(FakeUsuarioModel());

      expect(result, equals(Left('Erro ao registrar usuario')));
    });

    test("Deve retornar Left(String) quando ocorrer o datasource retornar false", () async {
      when(() => datasource.cadastrarUsuario(any())).thenAnswer((_) => Future.value(false));

      final result = await repository.cadastrarUsuario(FakeUsuarioModel());

      expect(result, equals(Left('Falha no processo do registro')));
    });

    test("Deve retornar Right(bool) quando o cadastro for realizado com suesso", () async {
      when(() => datasource.cadastrarUsuario(any())).thenAnswer((_) => Future.value(true));

      final result = await repository.cadastrarUsuario(FakeUsuarioModel());

      expect(result, equals(Right(true)));
    });
  });

  group("login", () {
    test("Deve retornar Left(String) quando ocorrer algum erro no login", () async {
      when(() => datasource.login(email: any(named: 'email'), senha: any(named: 'senha'))).thenThrow(DBFailure(message: 'Erro na busca do email'));

      final result = await repository.login(email: 'teste', senha: 'senha');

      expect(result, equals(Left('Erro na busca do email')));
    });

    test("Deve retornar Right(UsuarioMOdel) quando o login for efetuado com sucesso", () async {
      when(() => datasource.login(email: any(named: 'email'), senha: any(named: 'senha'))).thenAnswer((_) async => {"id": 'id', "nome": 'nome', "email": 'email', "senha": 'senha'});

      final result = await repository.login(email: 'teste', senha: 'senha');

      expect(result, isA<Right>());
    });
  });
}
