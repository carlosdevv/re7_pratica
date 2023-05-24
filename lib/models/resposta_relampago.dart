import 'dart:convert';

List<RespostaRelampago> respostaRelampagoFromJson(String str) =>
    List<RespostaRelampago>.from(
        json.decode(str).map((x) => RespostaRelampago.fromJson(x)));

String respostaRelampagoToJson(List<RespostaRelampago> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RespostaRelampago {
  RespostaRelampago({
    required this.idPergunta,
    required this.descPergunta,
    required this.descResposta,
  });

  int idPergunta;
  String descPergunta;
  String descResposta;

  factory RespostaRelampago.fromJson(Map<String, dynamic> json) =>
      RespostaRelampago(
        idPergunta: json["id_pergunta"],
        descPergunta: json["desc_pergunta"],
        descResposta: json["desc_resposta"],
      );

  Map<String, dynamic> toJson() => {
        "id_pergunta": idPergunta,
        "desc_pergunta": descPergunta,
        "desc_resposta": descResposta,
      };
}
