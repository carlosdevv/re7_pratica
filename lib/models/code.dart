import 'dart:convert';

CodeProps codePropsFromJson(String str) => CodeProps.fromJson(json.decode(str));

String codePropsToJson(CodeProps data) => json.encode(data.toJson());

class CodeProps {
  CodeProps({
    required this.statusCode,
    required this.mensagem,
    required this.codigo,
  });

  String statusCode;
  String mensagem;
  String codigo;

  factory CodeProps.fromJson(Map<String, dynamic> json) => CodeProps(
        statusCode: json["statusCode"],
        mensagem: json["mensagem"],
        codigo: json["codigo"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "mensagem": mensagem,
        "codigo": codigo,
      };
}
