import 'package:flutter_test/flutter_test.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/db_operations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

class MockDBOperations extends Mock implements DataBaseOperations {}

void main() {
  late MockDatabase mockDatabase;
  late MockDBOperations dbOperations;
  late AuthDatasource datasource;

  setUpAll(() {
    mockDatabase = MockDatabase();
    dbOperations = MockDBOperations();
    datasource = AuthDatasourceImpl(dbOperations);

    when(() => dbOperations.initOperations()).thenAnswer((_) async {});

    when(() => dbOperations.database).thenReturn(mockDatabase);

    datasource = AuthDatasourceImpl(dbOperations);
  });

  group("cadastrarUsuario", () {
    test("Deve retornar false quando acontecer algum conflito na criação do usuário", () async {
      when(() => mockDatabase.insert(any(), any())).thenAnswer((_) async => Future.value(0));

      final result = await datasource.cadastrarUsuario({});

      expect(result, isFalse);
    });

    test("Deve retornar DBFailure quando o Sqflite emitir alguma Exceção", () async {
      when(() => mockDatabase.insert(any(), any())).thenThrow(Exception('Erro simulado'));

      expect(() async => await datasource.cadastrarUsuario({}), throwsA(isA<DBFailure>()));
    });

    test("Deve retornar true quando o registro do usuario for feito com sucesso", () async {
      when(() => mockDatabase.insert(any(), any())).thenAnswer((_) async => Future.value(1));

      final result = await datasource.cadastrarUsuario({});

      expect(result, isTrue);
    });
  });

  group("login", () {
    test("Deve estourar DBFailure quando o Sqflite emitir uma exceção", () async {
      when(() => mockDatabase.query(any())).thenThrow(Exception('Erro simulado'));

      expect(() async => await datasource.login(email: 'email@teste.com', senha: '123456'), throwsA(isA<DBFailure>()));
    });

    test("Deve estourar DBFailure quando o email nao existir", () async {
      when(() => mockDatabase.query(any())).thenAnswer(
        (_) async => Future.value([
          {"email": "testando@gmail.com"},
        ]),
      );

      expect(() async => await datasource.login(email: 'email@teste.com', senha: '123456'), throwsA(isA<DBFailure>()));
    });

    test("Deve estourar DBFailure quando o email existir mas a senha não estiver correta", () async {
      when(() => mockDatabase.query(any())).thenAnswer(
        (_) async => Future.value([
          {"email": "testando@gmail.com", "senha": "1234"},
        ]),
      );

      expect(() async => await datasource.login(email: 'email@teste.com', senha: '123456'), throwsA(isA<DBFailure>()));
    });

    test("Deve permitir o usuário logar quando os dados estiverem corretos", () async {
      when(() => mockDatabase.query(any(), where: any(named: 'where'), whereArgs: any(named: 'whereArgs'))).thenAnswer(
        (_) async => Future.value([
          {"email": "email@teste.com", "senha": "123456"},
        ]),
      );

      final response = await datasource.login(email: 'email@teste.com', senha: '123456');

      expect(response, isA<Map<String, dynamic>>());
    });
  });
}
