import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_store.dart';
import 'package:provider/provider.dart';

class AddContactDialog extends StatelessWidget {
  AddContactDialog({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactStore>(
      builder: (context, store, child) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text("Adicionar contato"),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nome"),
                    controller: store.nomeController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Telefone"),
                    controller: store.telefoneController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      TelefoneInputFormatter(),
                    ],
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "CPF"),
                    controller: store.cpfController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      CpfInputFormatter(),
                    ],
                    enabled: !store.buscandoCep,
                    validator: (value) {
                      return CPFValidator.isValid(value)
                          ? null
                          : "CPF inválido";
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "CEP"),
                    controller: store.cepController,
                    onChanged: (s) {
                      if (s.length == 10) {
                        store.buscarEndereco(s);
                      }
                    },
                    enabled: !store.buscandoCep,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      CepInputFormatter(),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Logradouro"),
                    controller: store.logradouroController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Número"),
                    controller: store.numeroController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Bairro"),
                    controller: store.bairroController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Cidade"),
                    controller: store.localidadeController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Estado"),
                    controller: store.estadoController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Latitude",
                      errorText: store.localizationErro,
                    ),
                    controller: store.latitudeController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Longitude",
                      errorText: store.localizationErro,
                    ),
                    controller: store.longitudeController,
                    enabled: !store.buscandoCep,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() == true) {
                    await store.cadastrarContato();

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (store.erro.isNotEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(store.erro)));
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
                child: Text("Adicionar"),
              ),
            ],
          ),
        );
      },
    );
  }
}
