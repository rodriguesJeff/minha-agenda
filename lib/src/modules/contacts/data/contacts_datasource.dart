import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class ContactsDatasource {
  final Database _db;
  final StoreRef<String, Map<String, dynamic>> _contatoInstancia =
      stringMapStoreFactory.store(AppStrings.Usuario);

  ContactsDatasource(this._db);

  Future<List<RecordSnapshot<String, Map<String, dynamic>>>>
  buscarTodosOsContatos(String userId) async {
    try {
      final finder = Finder(filter: Filter.equals('userId', userId));

      final usuarioExiste = await _contatoInstancia.find(_db, finder: finder);

      if (usuarioExiste.isNotEmpty) {
        final finderMeusContatos = Finder(
          filter: Filter.equals('usuarioId', userId),
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
      final finder = Finder(filter: Filter.equals('userId', payload['userId']));

      final usuarioExiste = await _contatoInstancia.find(_db, finder: finder);

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

  Future<bool> editarContato(Map<String, dynamic> payload) async {
    try {
      final finder = Finder(filter: Filter.equals('userId', payload['userId']));

      final usuarioExiste = await _contatoInstancia.find(_db, finder: finder);

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
            return true;
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
      final finder = Finder(filter: Filter.equals('userId', userId));

      final usuarioExiste = await _contatoInstancia.find(_db, finder: finder);

      if (usuarioExiste.isNotEmpty) {
        final finderPorId = Finder(filter: Filter.equals('id', contactId));

        final deletado = await _contatoInstancia.delete(
          _db,
          finder: finderPorId,
        );

        if (deletado == 1) {
          return true;
        } else {
          throw DBFailure(message: "Ocorreu um erro no delete do contato!");
        }
      } else {
        throw DBFailure(message: "Não existe usuário cadastrado com esse id!");
      }
    } on DBFailure {
      rethrow;
    } catch (e) {
      throw DBFailure(message: "Erro ao deletar contato");
    }
  }
}
