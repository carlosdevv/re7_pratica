import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:re7_pratica/models/assuntos.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/models/registrar_consulta_props.dart';
import 'package:re7_pratica/models/resposta_relampago.dart';
import 'package:re7_pratica/models/total_consultas.dart';
import 'package:re7_pratica/models/user_unity.dart';

class HomeProvider extends GetConnect {
  static var api = http.Client();

  static Future<List<TotalConsultas>> getTotalConsultas(String idClient) async {
    var response = await api.get(
        Uri.parse('${Environment.baseURL!}/wsTotalConsultas.rule?sys=ALM'),
        headers: {
          'token': Environment.apiToken!,
          'id_cliente': idClient,
        });

    if (response.statusCode != 200) {
      return Future.error('Erro ao buscar total de consultas.');
    } else {
      return totalConsultasFromJson(response.body);
    }
  }

  static Future<List<Assuntos>> getAssuntos(String idClient) async {
    var response = await api.get(
        Uri.parse('${Environment.baseURL!}/wsAssuntos.rule?sys=ALM'),
        headers: {
          'token': Environment.apiToken!,
          'id_cliente': idClient,
        });

    if (response.statusCode != 204 && response.statusCode != 200) {
      return Future.error('Erro ao buscar assuntos de registro');
    } else {
      if (response.body.isEmpty) {
        return [];
      } else {
        return assuntosFromJson(response.body);
      }
    }
  }

  static Future<RegistrarConsultaProps> registerConsult(
      String idClient, String codeUser, String body) async {
    var response = await api.post(
        Uri.parse('${Environment.baseURL!}/wsRegistrarConsultas.rule?sys=ALM'),
        headers: {
          'content-type': 'application/json',
          'token': Environment.apiToken!,
          'id_cliente': idClient,
          'cod_usuario': codeUser,
        },
        body: body);

    if (response.statusCode != 201) {
      return Future.error('Erro ao tentar registrar consulta.');
    } else {
      return registrarConsultaPropsFromJson(response.body);
    }
  }

  static Future<int> registerComplementConsult(
      String idClient, String codeUser, String idConsult, String body) async {
    var response = await api.post(
        Uri.parse(
            '${Environment.baseURL!}/wsRegistrarComplemento.rule?sys=ALM'),
        headers: {
          'content-type': 'application/json',
          'token': Environment.apiToken!,
          'id_cliente': idClient,
          'cod_usuario': codeUser,
          'id_consulta': idConsult,
        },
        body: body);

    if (response.statusCode != 201) {
      return Future.error('Erro ao tentar registrar consulta.');
    } else {
      return response.statusCode;
    }
  }

  static Future<List<RespostaRelampago>> getRespostasRelampago(
      String idClient) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsRespostaRelampago.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json; charset=latin1',
        'token': Environment.apiToken!,
        'id_cliente': idClient,
      },
    );

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter perguntas relâmpagos.');
    } else {
      return respostaRelampagoFromJson(response.body);
    }
  }

  static Future inserirAnexo(
      String idConsulta, String idClient, String codeUser, String body) async {
    var response = await api.post(
        Uri.parse('${Environment.baseURL!}/wsInserirAnexo.rule?sys=ALM'),
        headers: {
          'content-type': 'application/json',
          'token': Environment.apiToken!,
          'id_cliente': idClient,
          'id_consulta': idConsulta,
          'cod_usuario': codeUser,
        },
        body: body);

    if (response.statusCode != 201) {
      return Future.error('Erro ao tentar adicionar anexo.');
    } else {
      return response.statusCode;
    }
  }

  static Future<List<UserUnity>> getUserUnities(String userCode) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsUnidadesUsuario.rule?sys=ALM'),
      headers: {
        'token': Environment.apiToken!,
        'cod_usuario': userCode,
      },
    );

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter as unidades do usuário.');
    } else {
      return userUnityFromJson(response.body);
    }
  }
}
