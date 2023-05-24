import 'dart:convert';

RegistrarConsultaParams registrarConsultaParamsFromJson(String str) =>
    RegistrarConsultaParams.fromJson(json.decode(str));

String registrarConsultaParamsToJson(RegistrarConsultaParams data) =>
    json.encode(data.toJson());

class RegistrarConsultaParams {
  RegistrarConsultaParams({
    required this.idAssunto,
    required this.consulta,
    required this.tipo,
    this.nmArquivo,
    required this.palavraChave,
  });

  int idAssunto;
  String consulta;
  int tipo;
  String? nmArquivo;
  PalavraChave palavraChave;

  factory RegistrarConsultaParams.fromJson(Map<String, dynamic> json) =>
      RegistrarConsultaParams(
        idAssunto: json["id_assunto"],
        consulta: json["consulta"],
        tipo: json["tipo"],
        nmArquivo: json["nm_arquivo"],
        palavraChave: PalavraChave.fromJson(json["palavra_chave"]),
      );

  Map<String, dynamic> toJson() => {
        "id_assunto": idAssunto,
        "consulta": consulta,
        "tipo": tipo,
        "nm_arquivo": nmArquivo,
        "palavra_chave": palavraChave.toJson(),
      };
}

class PalavraChave {
  PalavraChave({
    required this.chaves,
  });

  List<String> chaves;

  factory PalavraChave.fromJson(Map<String, dynamic> json) => PalavraChave(
        chaves: List<String>.from(json["chaves"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "chaves": List<dynamic>.from(chaves.map((x) => x)),
      };
}
