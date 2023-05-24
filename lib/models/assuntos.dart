import 'dart:convert';

List<Assuntos> assuntosFromJson(String str) =>
    List<Assuntos>.from(json.decode(str).map((x) => Assuntos.fromJson(x)));

String assuntosToJson(List<Assuntos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Assuntos {
  Assuntos({
    required this.descricao,
    required this.id,
  });

  String descricao;
  int id;

  void setId(int id) {
    this.id = id;
  }

  factory Assuntos.fromJson(Map<String, dynamic> json) => Assuntos(
        descricao: json["descricao"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "descricao": descricao,
        "id": id,
      };
}
