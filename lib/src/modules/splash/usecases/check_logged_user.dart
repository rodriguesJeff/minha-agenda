import 'package:localstorage/localstorage.dart';
import 'package:minha_agenda/src/utils/app_strings.dart';

class CheckLoggedUser {
  Future<bool> call() async {
    final loggedUser = localStorage.getItem(AppStrings.UsuarioLogadoId);

    return loggedUser != null;
  }
}
