import 'package:flutter_test/flutter_test.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast_memory.dart';

class MockDatabase extends Mock implements Database {}

class MockStoreRef extends Mock
    implements StoreRef<String, Map<String, dynamic>> {}

class FakeRecordSnapshot extends Fake
    implements RecordSnapshot<String, Map<String, dynamic>> {
  @override
  final String key;

  @override
  final Map<String, dynamic> value;

  FakeRecordSnapshot(this.key, this.value);
}

class FakeDatabaseClient extends Fake implements DatabaseClient {}

void main() {
  late Database db;
  late AuthDatasource datasource;

  setUp(() async {
    db = await databaseFactoryMemory.openDatabase('test.db');
    datasource = AuthDatasource(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AuthDatasource com Sembast Memory', () {
    test('Deve cadastrar um usuário com sucesso', () async {
      final payload = {'email': 'email@teste.com', 'senha': '123456'};

      final result = await datasource.cadastrarUsuario(payload);

      expect(result, isTrue);
    });

    test('Deve lançar DBFailure se o email já estiver sendo usado', () async {
      final payload = {'email': 'email@teste.com', 'senha': '123456'};

      await datasource.cadastrarUsuario(payload);

      expect(
        () => datasource.cadastrarUsuario(payload),
        throwsA(isA<DBFailure>()),
      );
    });

    test('Deve realizar login com sucesso', () async {
      final payload = {'email': 'email@teste.com', 'senha': '123456'};

      await datasource.cadastrarUsuario(payload);

      final result = await datasource.login(
        email: payload['email']!,
        senha: payload['senha']!,
      );

      expect(result['email'], payload['email']);
    });

    test('Deve lançar DBFailure se a senha estiver incorreta', () async {
      final payload = {'email': 'email@teste.com', 'senha': '123456'};

      await datasource.cadastrarUsuario(payload);

      expect(
        () => datasource.login(email: payload['email']!, senha: 'senha_errada'),
        throwsA(isA<DBFailure>()),
      );
    });

    test('Deve lançar DBFailure se o usuário não existir', () async {
      expect(
        () => datasource.login(email: 'naoexiste@teste.com', senha: '123456'),
        throwsA(isA<DBFailure>()),
      );
    });
  });
}
