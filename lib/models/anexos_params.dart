import 'dart:convert';

AnexosParams anexosParamsFromJson(String str) => AnexosParams.fromJson(json.decode(str));

String anexosParamsToJson(AnexosParams data) => json.encode(data.toJson());

class AnexosParams {
    AnexosParams({
        required this.nmArquivo,
        required this.descArquivo,
        required this.idOrigem,
        required this.base64,
    });

    String nmArquivo;
    String descArquivo;
    int idOrigem;
    String base64;

    factory AnexosParams.fromJson(Map<String, dynamic> json) => AnexosParams(
        nmArquivo: json["nm_arquivo"],
        descArquivo: json["desc_arquivo"],
        idOrigem: json["id_origem"],
        base64: json["base_64"],
    );

    Map<String, dynamic> toJson() => {
        "nm_arquivo": nmArquivo,
        "desc_arquivo": descArquivo,
        "id_origem": idOrigem,
        "base_64": base64,
    };
}
