import 'package:minha_agenda/src/models/endereco_model.dart';

class ContatoModel {
  String userId;
  String id;
  String nome;
  String cpf;
  String telefone;
  EnderecoModel endereco;
  String latitude;
  String longitude;

  ContatoModel({
    required this.userId,
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.endereco,
    required this.latitude,
    required this.longitude,
  });

  factory ContatoModel.fromJson(Map<String, dynamic> json) {
    return ContatoModel(
      userId: json["userId"],
      id: json["id"],
      nome: json["nome"],
      cpf: json["cpf"],
      telefone: json["telefone"],
      endereco: EnderecoModel.fromJson(json["endereco"]),
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "id": id,
      "nome": nome,
      "cpf": cpf,
      "telefone": telefone,
      "endereco": endereco.toJson(),
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
