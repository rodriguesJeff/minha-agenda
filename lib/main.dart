import 'package:flutter/material.dart';
import 'package:minha_agenda/injection.dart';
import 'package:minha_agenda/src/modules/auth/presentation/auth_page.dart';
import 'package:minha_agenda/src/modules/auth/presentation/auth_store.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await injecDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthStore(doLogin: getIt(), doRegister: getIt()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Agenda',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
        home: const AuthPage(),
      ),
    );
  }
}
