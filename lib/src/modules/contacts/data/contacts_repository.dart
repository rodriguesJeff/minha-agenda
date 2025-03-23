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
    try {
      List<ContatoModel> contatos = [];
      final response = await datasource.buscarTodosOsContatos(userId);

      if (response.isEmpty) {
        return Right(contatos);
      }

      for (final i in response) {
        contatos.add(ContatoModel.fromJson(i.value));
      }

      return Right(contatos);
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> apagarContato(String userId, contactId) async {
    try {
      final result = await datasource.apagarContato(userId, contactId);

      return Right(result);
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }
}
