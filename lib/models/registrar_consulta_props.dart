import 'dart:convert';

RegistrarConsultaProps registrarConsultaPropsFromJson(String str) =>
    RegistrarConsultaProps.fromJson(json.decode(str));

String registrarConsultaPropsToJson(RegistrarConsultaProps data) =>
    json.encode(data.toJson());

class RegistrarConsultaProps {
  RegistrarConsultaProps({
    required this.statusCode,
    required this.mensagem,
    required this.idConsulta,
  });

  String statusCode;
  String mensagem;
  int idConsulta;

  factory RegistrarConsultaProps.fromJson(Map<String, dynamic> json) =>
      RegistrarConsultaProps(
        statusCode: json["statusCode"],
        mensagem: json["mensagem"],
        idConsulta: json["id_consulta"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "mensagem": mensagem,
        "id_consulta": idConsulta,
      };
}
