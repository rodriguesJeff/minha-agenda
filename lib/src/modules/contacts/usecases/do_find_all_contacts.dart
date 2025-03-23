import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';

class DoFindAllContacts {
  final ContactsRepository repository;

  DoFindAllContacts({required this.repository});

  Future<Either<String, List<ContatoModel>>> call({
    required String userId,
  }) async {
    return repository.buscarTodosOsContatos(userId);
  }
}
