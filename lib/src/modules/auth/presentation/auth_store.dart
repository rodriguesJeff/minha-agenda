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

  String _erro = "";
  bool _usuarioCriadoComSucesso = false;
  bool _estaCriandoConta = false;

  String get erro => _erro;
  bool get usuarioCriadoComSucesso => _usuarioCriadoComSucesso;
  bool get estaCriandoConta => _estaCriandoConta;

  void login() async {
    carregando = true;
    notifyListeners();

    final result = await doLogin(
      email: emailController.text,
      senha: senhaController.text,
    );

    result.fold(
      (l) {
        setErro(l);
      },
      (r) {
        usuarioLogado = r;
        setErro("");
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
        setErro(l);
      },
      (r) {
        setUsuarioCadastradoComSucesso(true);
        setErro("");
      },
    );

    carregando = false;
    notifyListeners();
  }

  void setErro(String e) {
    _erro = e;
  }

  void setEstaCriandoConta() {
    _estaCriandoConta = !_estaCriandoConta;
    setErro('');
    notifyListeners();
  }

  void setUsuarioCadastradoComSucesso(bool value) {
    _usuarioCriadoComSucesso = value;
    notifyListeners();
  }
}
