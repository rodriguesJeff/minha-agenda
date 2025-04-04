import 'package:localstorage/localstorage.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class AuthDatasource {
  final Database _db;
  final StoreRef<String, Map<String, dynamic>> _cadastroInstancia =
      stringMapStoreFactory.store(AppStrings.Usuario);

  final StoreRef<String, Map<String, dynamic>> _contatoInstancia =
      stringMapStoreFactory.store(AppStrings.Contato);

  AuthDatasource(this._db);

  Future<bool> cadastrarUsuario(Map<String, dynamic> payload) async {
    try {
      final finder = Finder(filter: Filter.equals('email', payload['email']));

      final existingUsers = await _cadastroInstancia.find(_db, finder: finder);

      if (existingUsers.isNotEmpty) {
        throw DBFailure(message: "Já existe um usuário com esse email!");
      }

      await _cadastroInstancia.add(_db, payload);

      return true;
    } on DBFailure {
      rethrow;
    } catch (e) {
      throw DBFailure(message: "Erro no registro de usuário!");
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final finder = Finder(filter: Filter.equals('email', email));
      final usuarioEncontrado = await _cadastroInstancia.find(
        _db,
        finder: finder,
      );

      if (usuarioEncontrado.isNotEmpty &&
          usuarioEncontrado.first.value['senha'] == senha) {
        return usuarioEncontrado.first.value;
      } else {
        throw DBFailure(message: "Usuário não existente");
      }
    } catch (e) {
      throw DBFailure(
        message: "Erro: Verifique suas credenciais e tente novamente!",
      );
    }
  }

  Future<bool> apagarUsuario() async {
    try {
      final finder = Finder(
        filter: Filter.equals(
          'id',
          localStorage.getItem(AppStrings.UsuarioLogadoId),
        ),
      );
      final usuarioEncontrado = await _cadastroInstancia.find(
        _db,
        finder: finder,
      );

      if (usuarioEncontrado.isNotEmpty) {
        final contatoFinder = Finder(
          filter: Filter.equals(
            'userId',
            localStorage.getItem(AppStrings.UsuarioLogadoId),
          ),
        );
        final contatos = await _contatoInstancia.find(
          _db,
          finder: contatoFinder,
        );

        if (contatos.isNotEmpty) {
          await _contatoInstancia.delete(_db, finder: contatoFinder);
        }
        await _cadastroInstancia.delete(_db, finder: finder);

        return true;
      } else {
        throw DBFailure(message: "Usuário não existente");
      }
    } catch (e) {
      throw DBFailure(message: "Erro ao apagar usuário!");
    }
  }
}
