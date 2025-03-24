import 'package:flutter/material.dart';
import 'package:minha_agenda/src/modules/splash/presentation/splash_store.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashStore>(
      builder: (context, store, child) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPersistentFrameCallback((_) {
                if (!store.estaLogado) {
                  Navigator.pushNamed(context, '/auth');
                } else {
                  Navigator.pushNamed(context, '/contacts');
                }
              });
              return Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}
