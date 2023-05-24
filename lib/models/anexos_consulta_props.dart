import 'dart:convert';

AnexosConsultaProps anexosConsultaPropsFromJson(String str) =>
    AnexosConsultaProps.fromJson(json.decode(str));

String anexosConsultaPropsToJson(AnexosConsultaProps data) =>
    json.encode(data.toJson());

class AnexosConsultaProps {
  AnexosConsultaProps({
    required this.statusCode,
    required this.mensagem,
    required this.listaCaminho,
  });

  String statusCode;
  String mensagem;
  ListaCaminho listaCaminho;

  factory AnexosConsultaProps.fromJson(Map<String, dynamic> json) =>
      AnexosConsultaProps(
        statusCode: json["statusCode"],
        mensagem: json["mensagem"],
        listaCaminho: ListaCaminho.fromJson(json["lista_caminho"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "mensagem": mensagem,
        "lista_caminho": listaCaminho.toJson(),
      };
}

class ListaCaminho {
  ListaCaminho({
    required this.caminhos,
  });

  List<String> caminhos;

  factory ListaCaminho.fromJson(Map<String, dynamic> json) => ListaCaminho(
        caminhos: List<String>.from(json["caminhos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "caminhos": List<dynamic>.from(caminhos.map((x) => x)),
      };
}
