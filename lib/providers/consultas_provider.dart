import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:re7_pratica/models/anexos_consulta_props.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/models/relatorio_props.dart';

class ConsultasProvider extends GetConnect {
  static var api = http.Client();

  static Future<RelatorioProps> getRelatorioPDF(String idConsulta) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsRelatorioConsulta.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json',
        'token': Environment.apiToken!,
        'id_consulta': idConsulta,
      },
    );

    if (response.statusCode != 200) {
      return Future.error('Ocorreu um erro ao baixar relatório.');
    } else {
      return relatorioPropsFromJson(response.body);
    }
  }

  static Future<AnexosConsultaProps?> getAnexosConsulta(
      String idConsulta, String tipo) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsAnexosConsulta.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json',
        'token': Environment.apiToken!,
        'id_consulta': idConsulta,
        'tipo': tipo
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error('Ocorreu um erro ao buscar anexos.');
    } else {
      return anexosConsultaPropsFromJson(response.body);
    }
  }
}
