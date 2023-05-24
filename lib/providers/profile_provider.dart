import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/models/social_network_props.dart';
import 'package:re7_pratica/models/terms_props.dart';

class ProfileProvider extends GetConnect {
  static var api = http.Client();

  static Future updateProfileInfo(String usuario, String nome, String email,
      String celular, String foto) async {
    var response = await api.put(
      Uri.parse('${Environment.baseURL!}/wsAtualizarPerfil.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json',
        'token': Environment.apiToken!,
        'usuario': usuario,
        'nome': nome,
        'email': email,
        'celular': celular,
        'foto': foto,
      },
    );

    if (response.statusCode != 200) {
      return Future.error('Erro ao atualizar informações do perfil.');
    } else {
      return response.statusCode;
    }
  }

  static Future<TermsProps> getTerms() async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsTermoUso.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json',
        'token': Environment.apiToken!,
      },
    );

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar abrir termos e condições de uso.');
    } else {
      return termsPropsFromJson(response.body);
    }
  }

  static Future<List<SocialNetworkProps>?> getListSocialNetwork(
      String idCliente) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsRedeSocial.rule?sys=ALM'),
      headers: {
        'token': Environment.apiToken!,
        'id_cliente': idCliente,
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter consultores.');
    } else {
      return socialNetworkPropsFromJson(response.body);
    }
  }
}
