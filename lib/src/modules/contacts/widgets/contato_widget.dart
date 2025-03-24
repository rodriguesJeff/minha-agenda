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
            onTap: () {
              if (!header) {
                store.selecionarContato(contato!);
                showDialog(
                  context: context,
                  builder: (_) => AddContactDialog(),
                );
              }
            },
            trailing:
                header
                    ? IconButton(
                      onPressed: () {
                        store.ordenarContatos(
                          ordemCrescente: !store.estaOrdenadp,
                        );
                      },
                      icon: Icon(
                        store.estaOrdenadp
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                    )
                    : IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => SingleChildScrollView(
                                child: AlertDialog(
                                  title: Text(
                                    "Você deseja excluir este contato?",
                                  ),
                                  content: Column(
                                    children: [
                                      Text(
                                        "${contato!.nome} será excluído.",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
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
                                        store.apagarContato(contato!.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Excluir"),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
            subtitle:
                header
                    ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      onPressed: () {
                        store.resetarControllers();
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
                          backgroundColor: getColorFromName(contato!.nome),
                          radius: 30,
                          child: Text(
                            contato!.nome[0],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nome: ${contato!.nome}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "Telefone: ${contato!.telefone}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "CPF:${contato!.cpf}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Color getColorFromName(String name) {
    final String firstLetter = name.trim().toUpperCase().substring(0, 1);

    // Mapa de cores leves com letras
    final Map<String, Color> colorMap = {
      'A': Colors.amber,
      'B': Colors.blue,
      'C': Colors.cyan,
      'D': Colors.deepPurple,
      'E': Colors.orange, // cor clara substituta
      'F': Colors.teal,
      'G': Colors.green,
      'H': Colors.indigo,
      'I': Colors.purple,
      'J': Colors.lightBlue,
      'K': Colors.lightGreen,
      'L': Colors.lime,
      'M': Colors.pink.shade200,
      'N': Colors.orangeAccent,
      'O': Colors.blueAccent,
      'P': Colors.purpleAccent,
      'Q': Colors.tealAccent,
      'R': Colors.redAccent,
      'S': Colors.cyanAccent,
      'T': Colors.deepPurpleAccent,
      'U': Colors.lightGreenAccent,
      'V': Colors.amberAccent,
      'W': Colors.yellowAccent,
      'X': Colors.indigoAccent,
      'Y': Colors.greenAccent,
      'Z': Colors.pinkAccent,
    };

    return colorMap[firstLetter] ?? Colors.blue; // Azul padrão
  }
}
