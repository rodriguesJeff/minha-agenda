import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';

class GetLoggedUser {
  final AuthRepository _userRepository;

  GetLoggedUser(this._userRepository);

  Future<Either<String, UsuarioModel>> call() async {
    return await _userRepository.buscarUsuarioLogado();
  }
}
