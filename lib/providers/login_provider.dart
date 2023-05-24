import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:re7_pratica/models/environment.dart';

class LoginProvider extends GetConnect {
  static var api = http.Client();

  Future<void> getAuth(String usuario, String senha, String idCliente) async {
    final response = await api.get(
        Uri.parse('${Environment.baseURL!}/wsAutenticacao.rule?sys=ALM'),
        headers: {
          'token': Environment.apiToken!,
          'usuario': usuario,
          'senha': senha,
          'id_cliente': idCliente,
        });

    if (response.statusCode == 401) {
      return Future.error(401);
    } else if (response.statusCode != 200) {
      return Future.error('Erro ao realizar autenticação');
    }
  }
}
