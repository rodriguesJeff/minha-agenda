import 'package:flutter/material.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_store.dart';
import 'package:minha_agenda/src/modules/contacts/widgets/add_contact_dialog.dart';
import 'package:provider/provider.dart';

class ContatoWidget extends StatelessWidget {
  const ContatoWidget({
    super.key,
    required this.adjustedIndex,
    this.header = false,
  });

  final int adjustedIndex;
  final bool header;

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
                        CircleAvatar(radius: 30, child: Text("A")),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "nome $adjustedIndex",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "telefone $adjustedIndex",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "email $adjustedIndex",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }
}
