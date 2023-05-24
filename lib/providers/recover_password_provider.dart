import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:re7_pratica/models/code.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class RecoverPasswordProvider extends GetConnect {
  static var api = http.Client();

  static Future getCodeChangePassword(String user) async {
    var response = await api.get(
        Uri.parse('${Environment.baseURL!}/wsEsqueciSenha.rule?sys=ALM'),
        headers: {
          'token': Environment.apiToken!,
          'usuario': user,
          'Content-Type': 'application/json',
        });

    if (response.statusCode != 200) {
      return Future.error('Erro ao enviar o SMS');
    } else {
      return codePropsFromJson(response.body);
    }
  }

  static Future updatePassword(String user, String password) async {
    var response = await api.put(
        Uri.parse('${Environment.baseURL!}/wsAtualizarSenha.rule?sys=ALM'),
        headers: {
          'token': Environment.apiToken!,
          'usuario': user,
          'senha': password,
          'Content-Type': 'application/json',
        });

    if (response.statusCode != 200) {
      return showErrorSnackbar('Ocorreu um erro ao tentar atualizar a senha.');
    } else {
      return response.statusCode;
    }
  }
}
