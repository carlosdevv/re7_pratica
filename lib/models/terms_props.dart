import 'dart:convert';

TermsProps termsPropsFromJson(String str) => TermsProps.fromJson(json.decode(str));

String termsPropsToJson(TermsProps data) => json.encode(data.toJson());

class TermsProps {
    TermsProps({
        required this.statusCode,
        required this.mensagem,
        required this.caminho,
    });

    String statusCode;
    String mensagem;
    String caminho;

    factory TermsProps.fromJson(Map<String, dynamic> json) => TermsProps(
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
