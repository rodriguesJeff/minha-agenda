import 'package:get_it/get_it.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';
import 'package:minha_agenda/src/modules/auth/usecases/do_login.dart';
import 'package:minha_agenda/src/modules/auth/usecases/do_register.dart';
import 'package:sembast_web/sembast_web.dart';

final getIt = GetIt.instance;

injecDependencies() async {
  // Abre o banco
  final db = await databaseFactoryWeb.openDatabase('minha_agenda_web.db');

  // Datasources
  getIt.registerLazySingleton<AuthDatasource>(() => AuthDatasource(db));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(datasource: getIt()),
  );

  // Usecases
  getIt.registerFactory(() => DoLogin(repository: getIt()));
  getIt.registerFactory(() => DoRegister(repository: getIt()));
}
