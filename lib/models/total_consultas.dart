import 'dart:convert';

List<TotalConsultas> totalConsultasFromJson(String str) =>
    List<TotalConsultas>.from(
        json.decode(str).map((x) => TotalConsultas.fromJson(x)));

String totalConsultasToJson(List<TotalConsultas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TotalConsultas {
  TotalConsultas({
    this.totalAberta,
    this.totalAndamento,
    this.totalEncerrada,
    this.totalCancelada,
  });

  String? totalAberta;
  String? totalAndamento;
  String? totalEncerrada;
  String? totalCancelada;

  factory TotalConsultas.fromJson(Map<String, dynamic> json) => TotalConsultas(
        totalAberta: json["total_aberta"],
        totalAndamento: json["total_andamento"],
        totalEncerrada: json["total_encerrada"],
        totalCancelada: json["total_cancelada"],
      );

  Map<String, dynamic> toJson() => {
        "total_aberta": totalAberta,
        "total_andamento": totalAndamento,
        "total_encerrada": totalEncerrada,
        "total_cancelada": totalCancelada,
      };
}
