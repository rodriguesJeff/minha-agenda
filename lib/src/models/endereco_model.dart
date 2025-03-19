class EnderecoModel {
  String cep;
  String logradouro;
  String unidade;
  String bairro;
  String localidade;
  String uf;
  int? numero;
  String? complemento;
  String? estado;
  String? regiao;
  String? ddd;

  EnderecoModel({required this.cep, required this.logradouro, required this.unidade, required this.bairro, required this.localidade, required this.uf, this.numero, this.complemento, this.estado, this.regiao, this.ddd});

  Map<String, dynamic> toJson() {
    return {"cep": cep, "logradouro": logradouro, "unidade": unidade, "bairro": bairro, "localidade": localidade, "uf": uf, "numero": numero, "complemento": complemento, "estado": estado, "regiao": regiao, "ddd": ddd};
  }

  factory EnderecoModel.fromJson(dynamic json) {
    return EnderecoModel(cep: json["cep"], logradouro: json["logradouro"], unidade: json["unidade"], bairro: json["bairro"], localidade: json["localidade"], uf: json["uf"], numero: json["numero"], complemento: json["complemento"], estado: json["estado"], regiao: json["regiao"], ddd: json["ddd"]);
  }
}
