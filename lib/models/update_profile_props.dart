import 'dart:convert';

UpdateProfileProps updateProfilePropsFromJson(String str) =>
    UpdateProfileProps.fromJson(json.decode(str));

String updateProfilePropsToJson(UpdateProfileProps data) =>
    json.encode(data.toJson());

class UpdateProfileProps {
  UpdateProfileProps({
    required this.nome,
    required this.email,
    required this.celular,
  });

  String nome;
  String email;
  String celular;

  factory UpdateProfileProps.fromJson(Map<String, dynamic> json) =>
      UpdateProfileProps(
        nome: json["nome"],
        email: json["email"],
        celular: json["celular"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "email": email,
        "celular": celular,
      };
}
