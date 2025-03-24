import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_store.dart';
import 'package:provider/provider.dart';

class AddContactDialog extends StatelessWidget {
  const AddContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactStore>(
      builder: (context, store, child) {
        return AlertDialog(
          title: Text("Adicionar contato"),
          content: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Nome"),
                  controller: store.nomeController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Telefone"),
                  controller: store.telefoneController,
                  inputFormatters: [TelefoneInputFormatter()],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "CPF"),
                  controller: store.cpfController,
                  inputFormatters: [CpfInputFormatter()],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Endereço"),
                  controller: store.cepController,
                ),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }
}
