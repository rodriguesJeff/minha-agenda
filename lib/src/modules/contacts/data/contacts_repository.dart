import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_datasource.dart';
import 'package:minha_agenda/src/utils/app_failures.dart';

class ContactsRepository {
  final ContactsDatasource datasource;

  ContactsRepository({required this.datasource});

  Future<Either<String, List<ContatoModel>>> buscarTodosOsContatos(
    String userId,
  ) async {
    try {} on DBFailure catch (e) {
      return Left(e.message);
    }
  }
}
