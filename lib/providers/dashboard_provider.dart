import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:re7_pratica/models/arquivos.dart';
import 'package:re7_pratica/models/assunto_biblioteca.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/models/profile.dart';
import 'package:re7_pratica/models/videos.dart';

class DashboardProvider extends GetConnect {
  static var api = http.Client();

  static Future<List<ProfileProps>> getProfileInfos(String usuario) async {
    var response = await api.get(
        Uri.parse('${Environment.baseURL!}/wsMeuPerfil.rule?sys=ALM'),
        headers: {
          'token': Environment.apiToken!,
          'usuario': usuario,
        });

    if (response.statusCode != 200) {
      return Future.error('Erro ao buscar informações do perfil.');
    } else {
      return profilePropsFromJson(response.body);
    }
  }

  static Future<Consultas?> getListaConsultas(
      String idCliente, String codUsuario, String pagina) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsVisualizarConsultas.rule?sys=ALM'),
      headers: {
        'token': Environment.apiToken!,
        'id_cliente': idCliente,
        'cod_usuario': codUsuario,
        'pagina': pagina,
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter consultas.');
    } else {
      return consultasFromJson(response.body);
    }
  }

  static Future<Consultas?> getListaConsultasFilter(
    String idCliente,
    String codUsuario,
    String pagina,
    String? numProtocolo,
    String? idAssunto,
    String? dtConsulta,
    String? consulta,
    String? status,
  ) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsVisualizarConsultas.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json',
        'token': Environment.apiToken!,
        'id_cliente': idCliente,
        'cod_usuario': codUsuario,
        'pagina': pagina,
        'nu_protocolo': numProtocolo ?? '',
        'id_assunto': idAssunto ?? '',
        'dt_consulta': dtConsulta ?? '',
        'consulta': consulta ?? '',
        'status': status ?? '',
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter consultas.');
    } else {
      return consultasFromJson(response.body);
    }
  }

  static Future<Arquivos?> getListaArquivos(String idCliente, String pagina,
      String? idAssunto, String? content) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsListaArquivos.rule?sys=ALM'),
      headers: {
        'content-type': 'application/json; charset=latin1',
        'token': Environment.apiToken!,
        'id_cliente': idCliente,
        'pagina': pagina,
        'id_origem': '4',
        'id_assunto': idAssunto ?? (-1).toString(),
        'contendo': content ?? '',
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter arquivos.');
    } else {
      return arquivosFromJson(response.body);
    }
  }

  static Future<List<Videos>?> getListaVideos(String idCliente) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsRe7Play.rule?sys=ALM'),
      headers: {
        'token': Environment.apiToken!,
        'id_cliente': idCliente,
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter videos.');
    } else {
      return videosFromJson(response.body);
    }
  }

  static Future<List<Videos>?> getListaVideosFilter(
      String idCliente, String? titulo) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsRe7Play.rule?sys=ALM'),
      headers: {
        'token': Environment.apiToken!,
        'id_cliente': idCliente,
        'titulo': titulo ?? '',
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error('Erro ao tentar obter videos.');
    } else {
      return videosFromJson(response.body);
    }
  }

  static Future<List<AssuntoBiblioteca>?> getAssuntosBiblioteca(
      String idCliente) async {
    var response = await api.get(
      Uri.parse('${Environment.baseURL!}/wsAssuntosBiblioteca.rule?sys=ALM'),
      headers: {
        'token': Environment.apiToken!,
        'id_cliente': idCliente,
      },
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode != 200) {
      return Future.error(
          'Erro ao tentar obter assuntos da biblioteca de arquivos.');
    } else {
      return assuntoBibliotecaFromJson(response.body);
    }
  }
}
