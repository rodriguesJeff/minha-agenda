import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';

class DoLogin {
  final AuthRepository repository;

  DoLogin({required this.repository});

  Future<Either<String, UsuarioModel>> call({
    required String email,
    required String senha,
  }) async {
    return repository.login(email: email, senha: senha);
  }
}
