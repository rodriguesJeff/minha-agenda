import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_store.dart';
import 'package:minha_agenda/src/modules/contacts/widgets/add_contact_dialog.dart';
import 'package:provider/provider.dart';

class ContatoWidget extends StatelessWidget {
  const ContatoWidget({
    super.key,
    required this.adjustedIndex,
    this.header = false,
    this.contato,
  });

  final int adjustedIndex;
  final bool header;
  final ContatoModel? contato;

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactStore>(
      builder: (context, store, child) {
        return Card(
          margin: EdgeInsets.only(top: 2, bottom: 8),
          child: ListTile(
            subtitle:
                header
                    ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AddContactDialog();
                          },
                        );
                      },
                      child: Text(
                        "Adicionar contato",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: getRandomColor(),
                          child: Text(contato!.nome[0]),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contato!.nome, style: TextStyle(fontSize: 20)),
                            Text(
                              contato!.telefone,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(contato!.cpf, style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Color getRandomColor() {
    final List<Color> availableColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.deepPurple,
    ];

    final random = Random();
    return availableColors[random.nextInt(availableColors.length)];
  }
}
