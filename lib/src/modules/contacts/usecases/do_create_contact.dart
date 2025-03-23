import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';
import 'package:uuid/uuid.dart';

class DoCreateContact {
  final ContactsRepository repository;

  DoCreateContact({required this.repository});

  Future<Either<String, bool>> call({required ContatoModel contato}) async {
    contato.id = Uuid().v4();
    return repository.cadastrarNovoContato(contato);
  }
}
