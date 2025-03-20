class UsuarioModel {
  String id;
  String nome;
  String email;
  String senha;

  UsuarioModel({required this.id, required this.nome, required this.email, required this.senha});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(id: json["id"], nome: json["nome"], email: json["email"], senha: json["senha"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "nome": nome, "email": email, "senha": senha};
  }
}
