import 'dart:convert';

List<SocialNetworkProps> socialNetworkPropsFromJson(String str) =>
    List<SocialNetworkProps>.from(
        json.decode(str).map((x) => SocialNetworkProps.fromJson(x)));

String socialNetworkPropsToJson(List<SocialNetworkProps> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SocialNetworkProps {
  SocialNetworkProps({
    required this.codConsultor,
    this.facebook,
    this.twitter,
    this.youtube,
    this.instagram,
    required this.nmConsultor,
  });

  int codConsultor;
  String? facebook;
  String? twitter;
  String? youtube;
  String? instagram;
  String nmConsultor;

  factory SocialNetworkProps.fromJson(Map<String, dynamic> json) =>
      SocialNetworkProps(
        codConsultor: json["cod_consultor"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        youtube: json["youtube"],
        instagram: json["instagram"],
        nmConsultor: json["nm_consultor"],
      );

  Map<String, dynamic> toJson() => {
        "cod_consultor": codConsultor,
        "facebook": facebook,
        "twitter": twitter,
        "youtube": youtube,
        "instagram": instagram,
        "nm_consultor": nmConsultor,
      };
}
