import 'package:flutter/material.dart';

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
                  onPressed: () {},
                  child: Text(
                    "Adicionar contato",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  }
}
