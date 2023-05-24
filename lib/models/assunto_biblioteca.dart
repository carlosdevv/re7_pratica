import 'dart:convert';

List<AssuntoBiblioteca> assuntoBibliotecaFromJson(String str) =>
    List<AssuntoBiblioteca>.from(
        json.decode(str).map((x) => AssuntoBiblioteca.fromJson(x)));

String assuntoBibliotecaToJson(List<AssuntoBiblioteca> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssuntoBiblioteca {
  AssuntoBiblioteca({
    required this.idAssunto,
    required this.descricao,
    required this.corPasta,
  });

  int idAssunto;
  String descricao;
  String corPasta;

  factory AssuntoBiblioteca.fromJson(Map<String, dynamic> json) =>
      AssuntoBiblioteca(
        idAssunto: json["id_assunto"],
        descricao: json["descricao"],
        corPasta: json["cor_pasta"],
      );

  Map<String, dynamic> toJson() => {
        "id_assunto": idAssunto,
        "descricao": descricao,
        "cor_pasta": corPasta,
      };
}
