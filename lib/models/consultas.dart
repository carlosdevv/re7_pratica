import 'dart:convert';

Consultas consultasFromJson(String str) => Consultas.fromJson(json.decode(str));

String consultasToJson(Consultas data) => json.encode(data.toJson());

class Consultas {
  Consultas({
    required this.qtdRegistros,
    required this.qtdPaginas,
    required this.consultas,
  });

  int qtdRegistros;
  int qtdPaginas;
  List<Consulta> consultas;

  factory Consultas.fromJson(Map<String, dynamic> json) => Consultas(
        qtdRegistros: json["qtdRegistros"],
        qtdPaginas: json["qtdPaginas"],
        consultas: List<Consulta>.from(
            json["consultas"].map((x) => Consulta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "qtdRegistros": qtdRegistros,
        "qtdPaginas": qtdPaginas,
        "consultas": List<dynamic>.from(consultas.map((x) => x.toJson())),
      };
}

class Consulta {
  Consulta({
    this.linha,
    required this.id,
    required this.idAssunto,
    required this.consulta,
    required this.dtConsulta,
    required this.nuProtocolo,
    required this.codUsuario,
    required this.idCliente,
    required this.situacao,
    this.tipoPergunta,
    this.assunto,
  });

  String? linha;
  int id;
  int idAssunto;
  String consulta;
  String dtConsulta;
  String nuProtocolo;
  int codUsuario;
  int idCliente;
  String situacao;
  int? tipoPergunta;
  String? assunto;

  factory Consulta.fromJson(Map<String, dynamic> json) => Consulta(
        linha: json["linha"],
        id: json["id"],
        idAssunto: json["id_assunto"],
        consulta: json["consulta"],
        dtConsulta: json["dt_consulta"],
        nuProtocolo: json["nu_protocolo"],
        codUsuario: json["cod_usuario"],
        idCliente: json["id_cliente"],
        situacao: json["situacao"],
        tipoPergunta: json["tipo_pergunta"],
        assunto: json["assunto"],
      );

  Map<String, dynamic> toJson() => {
        "linha": linha,
        "id": id,
        "id_assunto": idAssunto,
        "consulta": consulta,
        "dt_consulta": dtConsulta,
        "nu_protocolo": nuProtocolo,
        "cod_usuario": codUsuario,
        "id_cliente": idCliente,
        "situacao": situacao,
        "tipo_pergunta": tipoPergunta,
        "assunto": assunto,
      };
}
