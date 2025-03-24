import 'package:flutter/material.dart';
import 'package:minha_agenda/src/modules/auth/presentation/auth_store.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Consumer<AuthStore>(
      builder: (context, store, child) {
        return Scaffold(
          body: Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width / 3,
              child: Builder(
                builder: (context) {
                  return AnimatedContainer(
                    height: store.estaCriandoConta ? height / 2 : height / 2.5,
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child:
                            store.carregando
                                ? CircularProgressIndicator()
                                : Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(height: 32),
                                      Text(
                                        "Bem vindo de volta!",
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      if (store.estaCriandoConta) ...[
                                        TextFormField(
                                          controller: store.nomeController,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person),
                                            hintText: "Nome",
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (store.estaCriandoConta &&
                                                value != null &&
                                                value.isEmpty) {
                                              return "Preencha o campo de Nome";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],

                                      TextFormField(
                                        controller: store.emailController,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.mail),
                                          hintText: "E-mail",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Preencha o campo de E-mail";
                                          } else if (!emailRegex.hasMatch(
                                            value,
                                          )) {
                                            return "Digite um e-mail válido";
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        controller: store.senhaController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          hintText: "Senha",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "Preencha o campo de Senha";
                                          }
                                          return null;
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                store.setEstaCriandoConta();
                                              },
                                              style: ButtonStyle(
                                                shadowColor:
                                                    WidgetStatePropertyAll(
                                                      Colors.transparent,
                                                    ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                    ),
                                                child: Text(
                                                  store.estaCriandoConta
                                                      ? "Acessar sua conta"
                                                      : "Criar conta",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }
                                                store
                                                    .setUsuarioCadastradoComSucesso(
                                                      false,
                                                    );
                                                if (store.estaCriandoConta) {
                                                  store.cadastrarUsuario();
                                                } else {
                                                  store.login();
                                                  if (store.usuarioLogado !=
                                                      null) {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/contacts',
                                                    );
                                                    store.resetarControllers();
                                                  }
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      Colors.black,
                                                    ),
                                                shape: WidgetStatePropertyAll<
                                                  RoundedRectangleBorder
                                                >(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                    ),
                                                child: Text(
                                                  store.estaCriandoConta
                                                      ? "CRIAR CONTA"
                                                      : "ENTRAR",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      if (store.erro.isNotEmpty) ...[
                                        SizedBox(height: 12),
                                        Text(
                                          store.erro,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                      ] else ...[
                                        if (store.usuarioCriadoComSucesso ==
                                            true)
                                          Text(
                                            "Cadastro realizado com sucesso, faça login para iniciar!",
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        SizedBox(height: 24),
                                      ],
                                    ],
                                  ),
                                ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
}
