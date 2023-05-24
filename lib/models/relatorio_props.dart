import 'dart:convert';

RelatorioProps relatorioPropsFromJson(String str) =>
    RelatorioProps.fromJson(json.decode(str));

String relatorioPropsToJson(RelatorioProps data) => json.encode(data.toJson());

class RelatorioProps {
  RelatorioProps({
    required this.statusCode,
    required this.mensagem,
    required this.caminho,
  });

  String statusCode;
  String mensagem;
  String caminho;

  factory RelatorioProps.fromJson(Map<String, dynamic> json) => RelatorioProps(
        statusCode: json["statusCode"],
        mensagem: json["mensagem"],
        caminho: json["caminho"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "mensagem": mensagem,
        "caminho": caminho,
      };
}
