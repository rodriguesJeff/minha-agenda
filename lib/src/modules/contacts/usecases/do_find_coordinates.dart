import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:minha_agenda/src/modules/contacts/data/contacts_repository.dart';

class DoFindCoordinates {
  final ContactsRepository repository;

  DoFindCoordinates({required this.repository});

  Future<Either<String, LatLng>> call({required String endereco}) async {
    return repository.buscarCoordenadas(endereco);
  }
}
