import 'package:flutter/widgets.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/usecases/do_login.dart';

class AuthStore extends ChangeNotifier {
  final DoLogin doLogin;

  AuthStore({required this.doLogin});

  bool carregando = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  late UsuarioModel usuarioLogado;

  String erroLogin = "";

  void login() async {
    carregando = true;
    notifyListeners();

    final result = await doLogin(email: emailController.text, senha: senhaController.text);

    result.fold(
      (l) {
        erroLogin = l;
      },
      (r) {
        usuarioLogado = r;
      },
    );

    carregando = false;
    notifyListeners();
  }
}
