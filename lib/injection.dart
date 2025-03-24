import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_datasource.dart';
import 'package:minha_agenda/src/modules/auth/data/auth_repository.dart';
import 'package:minha_agenda/src/modules/auth/usecases/do_login.dart';
import 'package:minha_agenda/src/modules/auth/usecases/do_register.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_datasource.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_create_contact.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_delete_contact.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_find_all_contacts.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_find_cep.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_find_coordinates.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_update_contact.dart';
import 'package:sembast_web/sembast_web.dart';

final getIt = GetIt.instance;

injecDependencies() async {
  // Abre o banco
  final db = await databaseFactoryWeb.openDatabase('minha_agenda_web.db');

  // Datasources
  getIt.registerLazySingleton<AuthDatasource>(() => AuthDatasource(db));
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ContactsDatasource>(
    () => ContactsDatasource(db, getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(datasource: getIt()),
  );
  getIt.registerLazySingleton<ContactsRepository>(
    () => ContactsRepository(datasource: getIt()),
  );

  // Usecases
  getIt.registerFactory(() => DoLogin(repository: getIt()));
  getIt.registerFactory(() => DoRegister(repository: getIt()));
  getIt.registerFactory(() => DoCreateContact(repository: getIt()));
  getIt.registerFactory(() => DoUpdateContact(repository: getIt()));
  getIt.registerFactory(() => DoDeleteContact(repository: getIt()));
  getIt.registerFactory(() => DoFindAllContacts(repository: getIt()));
  getIt.registerFactory(() => DoFindCep(repository: getIt()));
  getIt.registerFactory(() => DoFindCoordinates(repository: getIt()));
}
