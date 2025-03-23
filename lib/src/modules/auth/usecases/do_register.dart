import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';
import 'package:uuid/uuid.dart';

class DoRegister {
  final AuthRepository repository;

  DoRegister({required this.repository});

  Future<Either<String, bool>> call({
    required String nome,
    email,
    senha,
  }) async {
    final usuario = UsuarioModel(
      id: Uuid().v4(),
      nome: nome,
      email: email,
      senha: senha,
    );
    return repository.cadastrarUsuario(usuario);
  }
}
