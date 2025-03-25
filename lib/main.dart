import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:minha_agenda/injection.dart';
import 'package:minha_agenda/src/modules/auth/presentation/auth_page.dart';
import 'package:minha_agenda/src/modules/auth/presentation/auth_store.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_page.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_store.dart';
import 'package:minha_agenda/src/modules/splash/presentation/splash_page.dart';
import 'package:minha_agenda/src/modules/splash/presentation/splash_store.dart';
import 'package:minha_agenda/src/modules/splash/usecases/check_logged_user.dart';
import 'package:minha_agenda/src/modules/splash/usecases/get_location_permission.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalStorage();
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
        ChangeNotifierProvider(
          create:
              (context) => ContactStore(
                doCreateContact: getIt(),
                doUpdateContact: getIt(),
                doFindAllContacts: getIt(),
                doDeleteContact: getIt(),
                doFindCep: getIt(),
                getLocationPermission: GetLocationPermission(),
                doFindCoordinates: getIt(),
                getLoggedUser: getIt(),
                deleteUserAccount: getIt(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => SplashStore(
                checkLoggedUser: CheckLoggedUser(),
                getLocationPermission: GetLocationPermission(),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Agenda',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
        initialRoute: '/splash',
        routes: <String, WidgetBuilder>{
          '/splash': (BuildContext context) => SplashPage(),
          '/auth': (BuildContext context) => AuthPage(),
          '/contacts': (BuildContext context) => ContactPage(),
        },
      ),
    );
  }
}
