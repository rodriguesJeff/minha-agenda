import 'package:dartz/dartz.dart';
import 'package:localstorage/localstorage.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';

class DoLogin {
  final AuthRepository repository;

  DoLogin({required this.repository});

  Future<Either<String, UsuarioModel>> call({
    required String email,
    required String senha,
  }) async {
    final result = await repository.login(email: email, senha: senha);

    result.fold(
      (l) {},
      (u) => localStorage.setItem(AppStrings.UsuarioLogadoId, u.id),
    );

    return result;
  }
}
