import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_datasource.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/src/type.dart';

class MockContactsDatasource extends Mock implements ContactsDatasource {}

class FakeContatoMOdel extends Fake implements ContatoModel {
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class MockRecordRef<K, V> extends Mock implements RecordRef<K, V> {}

class FakeRecordSnapshot<K, V> extends RecordSnapshot<K, V> {
  final K _key;
  final V _value;

  FakeRecordSnapshot(this._key, this._value);

  @override
  K get key => _key;

  @override
  V get value => _value;

  @override
  RecordRef<K, V> get ref => MockRecordRef();

  @override
  Object? operator [](String field) {
    if (_value is Map<String, dynamic>) {
      return (_value as Map<String, dynamic>)[field];
    }
    return null;
  }

  @override
  RecordSnapshot<RK, RV> cast<RK extends Key?, RV extends Value?>() {
    return FakeRecordSnapshot<RK, RV>(_key as RK, _value as RV);
  }
}

void main() {
  late MockContactsDatasource contactsDatasource;
  late ContactsRepository repository;

  setUpAll(() {
    contactsDatasource = MockContactsDatasource();
    repository = ContactsRepository(datasource: contactsDatasource);
  });

  group("buscarTodosOsContatos", () {
    test(
      "Deve retornar Left(String) quando ocorrer algum erro na busca de contatos",
      () async {
        when(
          () => contactsDatasource.buscarTodosOsContatos("id"),
        ).thenThrow(DBFailure(message: 'Erro ao buscar todos os contato!'));

        final result = await repository.buscarTodosOsContatos("id");

        expect(result, Left('Erro ao buscar todos os contato!'));
      },
    );

    test(
      "Deve retornar Right com uma lista vazia quando não tiver contatos cadastrados para esse id",
      () async {
        when(
          () => contactsDatasource.buscarTodosOsContatos("id"),
        ).thenAnswer((_) async => []);

        final result = await repository.buscarTodosOsContatos("id");

        expect(result, isA<Right>());
      },
    );

    test(
      "Deve retornar Right com uma lista de contatos quando conseguir buscar os contatos do usuário",
      () async {
        when(() => contactsDatasource.buscarTodosOsContatos("id")).thenAnswer(
          (_) async => [
            FakeRecordSnapshot("1", {
              "id": "1",
              "nome": "Ana Silva",
              "cpf": "123.456.789-00",
              "telefone": "(11) 98765-4321",
              "endereco": {
                "cep": "01000-000",
                "logradouro": "Rua das Flores",
                "unidade": "001",
                "bairro": "Jardim Primavera",
                "localidade": "São Paulo",
                "uf": "SP",
                "numero": 123,
                "complemento": "Apto 101",
                "estado": "São Paulo",
                "regiao": "Sudeste",
                "ddd": "11",
              },
              "latitude": "-23.550520",
              "longitude": "-46.633308",
            }),
          ],
        );

        final result = await repository.buscarTodosOsContatos("id");

        expect(result.isRight(), isTrue);
        expect(result.getOrElse(() => []), isA<List<ContatoModel>>());
      },
    );
  });

  group("apagarContato", () {
    test(
      "Deve retornar Left(String) se ocorrer algum erro no datasource",
      () async {
        when(
          () => contactsDatasource.apagarContato("userid", "id"),
        ).thenThrow(DBFailure(message: "Erro ao apagar contato"));

        final result = await repository.apagarContato("userid", "id");

        expect(result.isLeft(), isTrue);
        expect(result, equals(Left("Erro ao apagar contato")));
      },
    );

    test(
      "Deve retornar Right(true) quando conseguir apagar sem erros",
      () async {
        when(
          () => contactsDatasource.apagarContato("userid", "id"),
        ).thenAnswer((_) async => Future.value(true));

        final result = await repository.apagarContato("userid", "id");

        expect(result.isRight(), isTrue);
        expect(result, equals(Right(true)));
      },
    );
  });

  group("editarContato", () {
    test(
      "Deve retornar Left(String) quando ocorrer algum erro na edição do contato",
      () async {
        when(
          () => contactsDatasource.editarContato({}),
        ).thenThrow(DBFailure(message: 'Erro ao atualizar contato'));

        final result = await repository.editarContato(FakeContatoMOdel());

        expect(result, equals(Left('Erro ao atualizar contato')));
      },
    );

    test(
      "Deve retornar Right(ContatoModel) quando a edição for um sucesso",
      () async {
        when(() => contactsDatasource.editarContato({})).thenAnswer(
          (_) async => FakeRecordSnapshot("1", {
            "id": "1",
            "nome": "Ana Silva",
            "cpf": "123.456.789-00",
            "telefone": "(11) 98765-4321",
            "endereco": {
              "cep": "01000-000",
              "logradouro": "Rua das Flores",
              "unidade": "001",
              "bairro": "Jardim Primavera",
              "localidade": "São Paulo",
              "uf": "SP",
              "numero": 123,
              "complemento": "Apto 101",
              "estado": "São Paulo",
              "regiao": "Sudeste",
              "ddd": "11",
            },
            "latitude": "-23.550520",
            "longitude": "-46.633308",
          }),
        );

        final result = await repository.editarContato(FakeContatoMOdel());

        expect(result.isRight(), isTrue);
        expect(result.getOrElse(() => FakeContatoMOdel()), isA<ContatoModel>());
      },
    );
  });

  group("cadastrarNovoContato", () {
    test(
      "Deve retornar Left(String) quando ocorrer um erro no cadastro de contato",
      () async {
        when(
          () => contactsDatasource.cadastrarNovoContato({}),
        ).thenThrow(DBFailure(message: 'Erro ao cadastro contato'));

        final result = await repository.cadastrarNovoContato(
          FakeContatoMOdel(),
        );

        expect(result, Left('Erro ao cadastro contato'));
      },
    );

    test(
      "Deve retornar Right(bool) quando o cadastro ocorrer sem erros",
      () async {
        when(
          () => contactsDatasource.cadastrarNovoContato({}),
        ).thenAnswer((_) async => Future.value(true));

        final result = await repository.cadastrarNovoContato(
          FakeContatoMOdel(),
        );

        expect(result, Right(true));
      },
    );
  });
}
