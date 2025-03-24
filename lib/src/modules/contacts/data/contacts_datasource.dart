import 'package:dio/dio.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class ContactsDatasource {
  final Database _db;
  final Dio dio;
  final StoreRef<String, Map<String, dynamic>> _usuarioInstancia =
      stringMapStoreFactory.store(AppStrings.Usuario);
  final StoreRef<String, Map<String, dynamic>> _contatoInstancia =
      stringMapStoreFactory.store(AppStrings.Contato);

  ContactsDatasource(this._db, this.dio);

  Future<List<RecordSnapshot<String, Map<String, dynamic>>>>
  buscarTodosOsContatos(String userId) async {
    try {
      final finder = Finder(filter: Filter.equals('id', userId));

      final usuarioExiste = await _usuarioInstancia.find(_db, finder: finder);

      if (usuarioExiste.isNotEmpty) {
        final finderMeusContatos = Finder(
          filter: Filter.equals('userId', userId),
        );

        final contatosSalvos = await _contatoInstancia.find(
          _db,
          finder: finderMeusContatos,
        );

        if (contatosSalvos.isNotEmpty) {
          return contatosSalvos;
        } else {
          return [];
        }
      } else {
        throw DBFailure(message: "Não existe usuário cadastrado com esse id!");
      }
    } on DBFailure {
      rethrow;
    } catch (e) {
      throw DBFailure(message: "Erro ao buscar todos os usuários");
    }
  }

  Future<bool> cadastrarNovoContato(Map<String, dynamic> payload) async {
    try {
      final finder = Finder(filter: Filter.equals('id', payload['userId']));

      final usuarioExiste = await _usuarioInstancia.find(_db, finder: finder);

      if (usuarioExiste.isNotEmpty) {
        final finderPorCpf = Finder(
          filter: Filter.equals('cpf', payload['cpf']),
        );

        final buscarContatoPreexistente = await _contatoInstancia.find(
          _db,
          finder: finderPorCpf,
        );

        if (buscarContatoPreexistente.isEmpty) {
          await _contatoInstancia.add(_db, payload);

          return true;
        } else {
          throw DBFailure(
            message: "Já existe um contato cadastrado com esse cpf!",
          );
        }
      } else {
        throw DBFailure(message: "Não existe usuário cadastrado com esse id!");
      }
    } on DBFailure {
      rethrow;
    } catch (e) {
      throw DBFailure(message: "Erro ao cadastrar contato");
    }
  }

  Future<RecordSnapshot<String, Map<String, dynamic>>> editarContato(
    Map<String, dynamic> payload,
  ) async {
    try {
      final finder = Finder(filter: Filter.equals('userId', payload['userId']));

      final usuarioExiste = await _usuarioInstancia.find(_db, finder: finder);

      if (usuarioExiste.isNotEmpty) {
        final finderPorCpf = Finder(
          filter: Filter.equals('cpf', payload['cpf']),
        );

        final buscarContatoPreexistente = await _contatoInstancia.find(
          _db,
          finder: finderPorCpf,
        );

        if (buscarContatoPreexistente.isNotEmpty) {
          final atualizacao = await _contatoInstancia.update(_db, payload);

          if (atualizacao == 1) {
            final finder = Finder(filter: Filter.equals('id', payload['id']));
            final usuarioExiste = await _contatoInstancia.find(
              _db,
              finder: finder,
            );

            return usuarioExiste.first;
          } else {
            throw DBFailure(
              message: "Ocorreu um erro na atualização do contato!",
            );
          }
        } else {
          throw DBFailure(
            message: "Não existe um contato cadastrado com esse cpf!",
          );
        }
      } else {
        throw DBFailure(message: "Não existe contato cadastrado com esse id!");
      }
    } on DBFailure {
      rethrow;
    } catch (e) {
      throw DBFailure(message: "Erro ao atualizar contato");
    }
  }

  Future<bool> apagarContato(String userId, contactId) async {
    try {
      final finder = Finder(filter: Filter.equals('id', userId));

      final usuarioExiste = await _usuarioInstancia.find(_db, finder: finder);

      if (usuarioExiste.isNotEmpty) {
        final finderPorId = Finder(filter: Filter.equals('id', contactId));

        final deletado = await _contatoInstancia.delete(
          _db,
          finder: finderPorId,
        );

        if (deletado == 1) {
          return true;
        } else {
          throw DBFailure(message: "Ocorreu um erro ao apagar contato!");
        }
      } else {
        throw DBFailure(message: "Não existe usuário cadastrado com esse id!");
      }
    } on DBFailure {
      rethrow;
    } catch (e) {
      throw DBFailure(message: "Erro ao apagar contato");
    }
  }

  Future<Map<String, dynamic>> buscarEndereco(String cep) async {
    try {
      final response = await dio.get("https://viacep.com.br/ws/$cep/json/");
      return response.data;
    } on DioException catch (e) {
      throw ServerFailure(message: e.message ?? "Erro na requisição");
    }
  }

  Future<Response> buscarCoordenadas(String endereco) async {
    try {
      final response = await dio.get(
        "https://nominatim.openstreetmap.org/search?q=$endereco&format=json",
        options: Options(
          headers: {
            "User-Agent":
                "MinhaAgendaFlutterWeb/1.0 (https://minhaagenda.teste; jeffersondavid179@gmail.com)",
          },
        ),
      );

      return response;
    } on DioException {
      throw ServerFailure(message: "Erro na requisição");
    }
  }
}
