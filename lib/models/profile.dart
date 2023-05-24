import 'dart:convert';

List<ProfileProps> profilePropsFromJson(String str) => List<ProfileProps>.from(
    json.decode(str).map((x) => ProfileProps.fromJson(x)));

String profilePropsToJson(List<ProfileProps> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileProps {
  ProfileProps({
    required this.codigo,
    required this.usuario,
    this.foto,
    required this.nome,
    required this.email,
    required this.celular,
  });

  int codigo;
  String usuario;
  dynamic foto;
  String nome;
  String email;
  String celular;

  factory ProfileProps.fromJson(Map<String, dynamic> json) => ProfileProps(
        codigo: json["codigo"],
        usuario: json["usuario"],
        foto: json["foto"],
        nome: json["nome"],
        email: json["email"],
        celular: json["celular"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "usuario": usuario,
        "foto": foto,
        "nome": nome,
        "email": email,
        "celular": celular,
      };
}
