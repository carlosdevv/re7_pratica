import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/models/path_file_props.dart';

class BibliotecaProvider extends GetConnect {
  static var api = http.Client();

  static Future<PathFileProps> getPathFile(String idArquivo) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsCaminhoArquivos.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json',
        'token': Environment.apiToken!,
        'id_arquivo': idArquivo,
      },
    );

    if (response.statusCode != 200) {
      return Future.error('Ocorreu um erro ao baixar arquivo.');
    } else {
      return pathFilePropsFromJson(response.body);
    }
  }
}
