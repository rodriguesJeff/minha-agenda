import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Container(width: width * .3, color: Colors.red)),
            Expanded(child: Container(width: width * .6, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
