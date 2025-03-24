import 'package:dartz/dartz.dart';
import 'package:minha_agenda/src/models/endereco_model.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';

class DoFindCep {
  final ContactsRepository repository;

  DoFindCep({required this.repository});

  Future<Either<String, EnderecoModel>> call(String cep) async {
    if (cep.isEmpty) {
      return Left("Este cep não é válido");
    }

    return await repository.buscarEndereco(cep);
  }
}
