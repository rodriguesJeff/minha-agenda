import 'package:flutter/widgets.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/auth/usecases/do_login.dart';
import 'package:minha_agenda/src/modules/auth/usecases/do_register.dart';

class AuthStore extends ChangeNotifier {
  final DoLogin doLogin;
  final DoRegister doRegister;

  AuthStore({required this.doLogin, required this.doRegister});

  bool carregando = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  UsuarioModel? usuarioLogado;

  String erro = "";
  bool? usuarioCriadoComSucesso;
  bool estaCriandoConta = false;

  void login() async {
    carregando = true;
    notifyListeners();

    final result = await doLogin(
      email: emailController.text,
      senha: senhaController.text,
    );

    result.fold(
      (l) {
        erro = l;
      },
      (r) {
        usuarioLogado = r;
        erro = '';
      },
    );

    carregando = false;
    notifyListeners();
  }

  void cadastrarUsuario() async {
    carregando = true;
    notifyListeners();

    final result = await doRegister(
      email: emailController.text,
      senha: senhaController.text,
      nome: nomeController.text,
    );

    result.fold(
      (l) {
        erro = l;
      },
      (r) {
        usuarioCriadoComSucesso = r;
        erro = '';
      },
    );

    carregando = false;
    notifyListeners();
  }

  void setEstaCriandoConta() {
    estaCriandoConta = !estaCriandoConta;
    erro = '';
    notifyListeners();
  }
}
