import 'package:minha_agenda/src/utils/app_failures.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class AuthDatasource {
  final Database _db;
  final StoreRef<String, Map<String, dynamic>> _cadastroInstancia =
      stringMapStoreFactory.store(AppStrings.Usuario);

  AuthDatasource(this._db);

  Future<bool> cadastrarUsuario(Map<String, dynamic> payload) async {
    try {
      final finder = Finder(filter: Filter.equals('email', payload['email']));

      final existingUsers = await _cadastroInstancia.find(_db, finder: finder);

      if (existingUsers.first.value["email"] == payload["email"]) {
        throw DBFailure(message: "Já existe um usuário com esse email!");
      }

      await _cadastroInstancia.add(_db, payload);

      return true;
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
}
