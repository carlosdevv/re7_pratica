import 'dart:convert';

Arquivos arquivosFromJson(String str) => Arquivos.fromJson(json.decode(str));

String arquivosToJson(Arquivos data) => json.encode(data.toJson());

class Arquivos {
  Arquivos({
    required this.qtdRegistros,
    required this.qtdPaginas,
    required this.arquivos,
  });

  int qtdRegistros;
  int qtdPaginas;
  List<Arquivo> arquivos;

  factory Arquivos.fromJson(Map<String, dynamic> json) => Arquivos(
        qtdRegistros: json["qtdRegistros"],
        qtdPaginas: json["qtdPaginas"],
        arquivos: List<Arquivo>.from(
            json["arquivos"].map((x) => Arquivo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "qtdRegistros": qtdRegistros,
        "qtdPaginas": qtdPaginas,
        "arquivos": List<dynamic>.from(arquivos.map((x) => x.toJson())),
      };
}

class Arquivo {
  Arquivo({
    this.linha,
    required this.idArquivo,
    required this.nmArquivo,
    required this.dtCadastro,
    this.descArquivo,
    required this.idAssunto,
    required this.assunto,
  });

  String? linha;
  int idArquivo;
  String nmArquivo;
  DateTime dtCadastro;
  String? descArquivo;
  int idAssunto;
  String assunto;

  factory Arquivo.fromJson(Map<String, dynamic> json) => Arquivo(
        linha: json["linha"],
        idArquivo: json["id_arquivo"],
        nmArquivo: json["nm_arquivo"],
        dtCadastro: DateTime.parse(json["dt_cadastro"]),
        descArquivo: json["desc_arquivo"],
        idAssunto: json["id_assunto"],
        assunto: json["assunto"],
      );

  Map<String, dynamic> toJson() => {
        "linha": linha,
        "id_arquivo": idArquivo,
        "nm_arquivo": nmArquivo,
        "dt_cadastro": dtCadastro.toIso8601String(),
        "desc_arquivo": descArquivo,
        "id_assunto": idAssunto,
        "assunto": assunto,
      };
}
