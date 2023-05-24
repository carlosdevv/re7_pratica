import 'dart:convert';

PathFileProps pathFilePropsFromJson(String str) => PathFileProps.fromJson(json.decode(str));

String pathFilePropsToJson(PathFileProps data) => json.encode(data.toJson());

class PathFileProps {
    PathFileProps({
        required this.statusCode,
        required this.mensagem,
        required this.caminho,
    });

    String statusCode;
    String mensagem;
    String caminho;

    factory PathFileProps.fromJson(Map<String, dynamic> json) => PathFileProps(
        statusCode: json["statusCode"],
        mensagem: json["mensagem"],
        caminho: json["caminho"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "mensagem": mensagem,
        "caminho": caminho,
    };
}
