import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';

class DoUpdateContact {
  final ContactsRepository repository;

  DoUpdateContact({required this.repository});

  Future<Either<String, ContatoModel>> call({
    required ContatoModel contato,
  }) async {
    return repository.editarContato(contato);
  }
}
