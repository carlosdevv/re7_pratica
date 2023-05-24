import 'dart:convert';

RegisterComplementConsultParams registerComplementConsultParamsFromJson(
        String str) =>
    RegisterComplementConsultParams.fromJson(json.decode(str));

String registerComplementConsultParamsToJson(
        RegisterComplementConsultParams data) =>
    json.encode(data.toJson());

class RegisterComplementConsultParams {
  RegisterComplementConsultParams({
    required this.complemento,
    required this.tipo,
    this.nmArquivo,
  });

  String complemento;
  int tipo;
  String? nmArquivo;

  factory RegisterComplementConsultParams.fromJson(Map<String, dynamic> json) =>
      RegisterComplementConsultParams(
        complemento: json["complemento"],
        tipo: json["tipo"],
        nmArquivo: json["nm_arquivo"],
      );

  Map<String, dynamic> toJson() => {
        "complemento": complemento,
        "tipo": tipo,
        "nm_arquivo": nmArquivo,
      };
}
