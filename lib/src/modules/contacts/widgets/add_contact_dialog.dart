import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_store.dart';
import 'package:provider/provider.dart';

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactStore>(
      builder: (context, store, child) {
        return SingleChildScrollView(
          child: Dialog(
            child: SizedBox(
              width: 800,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (store.sucessoNoCadastro != true)
                      Center(
                        child: Text(
                          "Adicionar contato",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children:
                            store.sucessoNoCadastro == true
                                ? [
                                  SizedBox(height: 12),
                                  Text(
                                    "Contato cadastrado com sucesso!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  SizedBox(height: 12),
                                  Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 48,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  TextButton(
                                    onPressed: () {
                                      store.resetarControllers();

                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Fechar"),
                                  ),
                                ]
                                : [
                                  if (store.erro.isNotEmpty) ...[
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        store.erro,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Nome",
                                    ),
                                    controller: store.nomeController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Nome obrigatório";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Telefone",
                                    ),
                                    controller: store.telefoneController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                      TelefoneInputFormatter(),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Telefone obrigatório";
                                      }
                                      if (value.length < 14) {
                                        return "Telefone inválido";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "CPF",
                                    ),
                                    controller: store.cpfController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                      CpfInputFormatter(),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "CPF obrigatório";
                                      }
                                      if (!CPFValidator.isValid(value)) {
                                        return "CPF inválido";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "CEP",
                                    ),
                                    controller: store.cepController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "CEP obrigatório";
                                      }
                                      if (value.length < 9) {
                                        return "CEP incompleto";
                                      }
                                      return null;
                                    },
                                    onChanged: (s) {
                                      if (s.length < 10 && store.jaBuscouCep) {
                                        store.resetarBuscaCep();
                                      }
                                      if (s.length == 10 &&
                                          !store.jaBuscouCep) {
                                        store.buscarEndereco(s);
                                      }
                                    },
                                    enabled: !store.buscandoCep,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                      CepInputFormatter(),
                                    ],
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Logradouro",
                                    ),
                                    controller: store.logradouroController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Logradouro obrigatório";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Número",
                                    ),
                                    controller: store.numeroController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Número obrigatório";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Bairro",
                                    ),
                                    controller: store.bairroController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Bairro obrigatório";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Cidade",
                                    ),
                                    controller: store.localidadeController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Cidade obrigatória";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Estado",
                                    ),
                                    controller: store.estadoController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Estado obrigatório";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Complemento",
                                    ),
                                    controller: store.complementoController,
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Latitude",
                                      errorText: store.localizationErro,
                                    ),
                                    controller: store.latitudeController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Latitude obrigatória";
                                      }
                                      if (double.tryParse(value) == null) {
                                        return "Latitude inválida";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                  SizedBox(height: 12),

                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Longitude",
                                      errorText: store.localizationErro,
                                    ),
                                    controller: store.longitudeController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Longitude obrigatória";
                                      }
                                      if (double.tryParse(value) == null) {
                                        return "Longitude inválida";
                                      }
                                      return null;
                                    },
                                    enabled: !store.buscandoCep,
                                  ),
                                ],
                      ),
                    ),
                    SizedBox(height: 12),
                    if (store.sucessoNoCadastro != true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                store.resetarControllers();
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                shadowColor: WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() == true) {
                                  store.contatoSelecionado != null
                                      ? store.editarContato()
                                      : store.cadastrarContato();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.black,
                                ),
                                shape: WidgetStatePropertyAll<
                                  RoundedRectangleBorder
                                >(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  store.contatoSelecionado != null
                                      ? "EDITAR"
                                      : "ADICIONAR",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
