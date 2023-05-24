import 'dart:convert';

List<UserUnity> userUnityFromJson(String str) => List<UserUnity>.from(json.decode(str).map((x) => UserUnity.fromJson(x)));

String userUnityToJson(List<UserUnity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserUnity {
    UserUnity({
        required this.nmcliente,
        required this.idcliente,
    });

    String nmcliente;
    int idcliente;

    factory UserUnity.fromJson(Map<String, dynamic> json) => UserUnity(
        nmcliente: json["nmcliente"],
        idcliente: json["idcliente"],
    );

    Map<String, dynamic> toJson() => {
        "nmcliente": nmcliente,
        "idcliente": idcliente,
    };
}
