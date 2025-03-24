import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/models/endereco_model.dart';
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

  Future<Either<String, ContatoModel>> editarContato(
    ContatoModel contato,
  ) async {
    try {
      final result = await datasource.editarContato(contato.toJson());

      return Right(ContatoModel.fromJson(result.value));
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, bool>> cadastrarNovoContato(
    ContatoModel contato,
  ) async {
    try {
      final response = await datasource.cadastrarNovoContato(contato.toJson());

      return Right(response);
    } on DBFailure catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, EnderecoModel>> buscarEndereco(String cep) async {
    try {
      final response = await datasource.buscarEndereco(cep);

      return Right(EnderecoModel.fromJson(response));
    } on ServerFailure catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, LatLng>> buscarCoordenadas(String endereco) async {
    try {
      final Response response = await datasource.buscarCoordenadas(endereco);

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          final String lat = response.data.first['lat'];
          final String lon = response.data.first['lon'];

          return Right(LatLng(double.tryParse(lat)!, double.tryParse(lon)!));
        } else {
          return Left('Endereço não encontrado!');
        }
      } else {
        return Left('Erro ao buscar coordenadas!');
      }
    } on ServerFailure catch (e) {
      return Left(e.message);
    }
  }
}
