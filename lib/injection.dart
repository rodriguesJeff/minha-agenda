import 'package:get_it/get_it.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';
import 'package:minha_agenda/src/utils/db_operations.dart';

final getIt = GetIt.instance;

void injecDependencies() {
  getIt.registerSingleton(DataBaseOperations());
  getIt.registerLazySingleton<AuthDatasource>(() => AuthDatasourceImpl(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(datasource: getIt()));
}
