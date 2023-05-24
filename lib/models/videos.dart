import 'dart:convert';

List<Videos> videosFromJson(String str) =>
    List<Videos>.from(json.decode(str).map((x) => Videos.fromJson(x)));

String videosToJson(List<Videos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Videos {
  Videos({
    required this.idVideo,
    required this.descricao,
    required this.linkVideo,
    this.thumbnail,
  });

  int idVideo;
  String descricao;
  String linkVideo;
  String? thumbnail;

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        idVideo: json["id_video"],
        descricao: json["descricao"],
        linkVideo: json["link_video"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id_video": idVideo,
        "descricao": descricao,
        "link_video": linkVideo,
        "thumbnail": thumbnail,
      };
}
