import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';

class DoDeleteContact {
  final ContactsRepository repository;

  DoDeleteContact({required this.repository});

  Future<Either<String, bool>> call({required String userId, id}) async {
    return repository.apagarContato(userId, id);
  }
}
