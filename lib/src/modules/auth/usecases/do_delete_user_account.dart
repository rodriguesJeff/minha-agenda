import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';

class DoDeleteUserAccount {
  final AuthRepository _authRepository;

  DoDeleteUserAccount(this._authRepository);

  Future<Either<String, void>> call(String email, senha) async {
    final result = await _authRepository.login(email: email, senha: senha);

    if (result.isLeft()) {
      return Left('Erro ao apagar usuário');
    }

    return await _authRepository.apagarUsuario();
  }
}
