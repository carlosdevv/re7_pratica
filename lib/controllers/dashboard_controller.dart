import 'package:get/get.dart';
import 'package:re7_pratica/models/arquivos.dart';
import 'package:re7_pratica/models/assunto_biblioteca.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/models/profile.dart';
import 'package:re7_pratica/models/total_consultas.dart';
import 'package:re7_pratica/models/user_secure_storage.dart';
import 'package:re7_pratica/models/videos.dart';
import 'package:re7_pratica/providers/dashboard_provider.dart';
import 'package:re7_pratica/providers/home_provider.dart';
import 'package:re7_pratica/routes/app_routes.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class DashboardController extends GetxController {
  final totalConsultas =
      TotalConsultas(totalAberta: '', totalAndamento: '', totalEncerrada: '')
          .obs;

  var tabIndex = 0;
  Rx<String>? userCredential = ''.obs;
  Rx<String>? idClientCredential = ''.obs;

  Rx<int> registrosAmount = (-1).obs;
  Rx<int> pagesAmount = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    getCredentials(
      UserSecureStorage.getUser()!,
      UserSecureStorage.getCode()!,
    );
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  void getCredentials(String username, String idClient) {
    userCredential!.value = username;
    idClientCredential!.value = idClient;
    update();
  }

  Future<ProfileProps?> getUserProps() async {
    List<ProfileProps> response =
        await DashboardProvider.getProfileInfos(userCredential!.value);

    for (var userInfo in response) {
      return ProfileProps(
          celular: userInfo.celular,
          codigo: userInfo.codigo,
          email: userInfo.email,
          nome: userInfo.nome,
          usuario: userInfo.usuario,
          foto: userInfo.foto);
    }

    return null;
  }

  Future<TotalConsultas> getTotalConsultas() async {
    List<TotalConsultas> response =
        await HomeProvider.getTotalConsultas(idClientCredential!.value);

    for (var totalConsulta in response) {
      return totalConsultas.value = TotalConsultas(
          totalAberta: totalConsulta.totalAberta,
          totalAndamento: totalConsulta.totalAndamento,
          totalEncerrada: totalConsulta.totalEncerrada,
          totalCancelada: totalConsulta.totalCancelada);
    }

    return totalConsultas.value;
  }

  Future<List<Consulta>> getRecentListaConsultas(
      String codigo, String page) async {
    try {
      Consultas? response = await DashboardProvider.getListaConsultas(
          idClientCredential!.value, codigo, page);

      if (response!.consultas.isNotEmpty) {
        return response.consultas;
      } else {
        return [];
      }
    } catch (e) {
      return showErrorSnackbar(e.toString());
    }
  }

  Future<Consultas?> getConsultas(String codigo, String page) async {
    try {
      Consultas? response = await DashboardProvider.getListaConsultas(
          idClientCredential!.value, codigo, page);

      if (response != null) {
        return response;
      } else {
        return showWarningSnackbar('Não há mais consultas.');
      }
    } catch (e) {
      return showErrorSnackbar(e.toString());
    }
  }

  Future<Consultas?> getConsultasFilter(
    String codigo,
    String page,
    String? numProtocolo,
    String? idAssunto,
    String? dtConsulta,
    String? consulta,
    String? status,
  ) async {
    try {
      Consultas? response = await DashboardProvider.getListaConsultasFilter(
        idClientCredential!.value,
        codigo,
        page,
        numProtocolo,
        idAssunto,
        dtConsulta,
        consulta,
        status,
      );

      if (response != null) {
        return response;
      } else {
        return showWarningSnackbar('Consulta não encontrada.');
      }
    } catch (e) {
      return showErrorSnackbar(e.toString());
    }
  }

  Future<Arquivos?> getArquivos(
      String page, int? idAssunto, String? content) async {
    try {
      Arquivos? response = await DashboardProvider.getListaArquivos(
          idClientCredential!.value, page, idAssunto.toString(), content);

      if (response != null) {
        return response;
      } else {
        return showWarningSnackbar('Não há mais arquivos.');
      }
    } catch (e) {
      return showErrorSnackbar(e.toString());
    }
  }

  Future<List<AssuntoBiblioteca>?> getAssuntosBiblioteca() async {
    try {
      List<AssuntoBiblioteca>? response =
          await DashboardProvider.getAssuntosBiblioteca(
              idClientCredential!.value);

      if (response != null) {
        return response;
      }
    } catch (e) {
      return showErrorSnackbar(e.toString());
    }

    return null;
  }

  Future<List<Videos>?> getVideos() async {
    try {
      List<Videos>? listVideos =
          await DashboardProvider.getListaVideos(idClientCredential!.value);

      if (listVideos != null) {
        return listVideos;
      }
    } catch (e) {
      return showErrorSnackbar(e.toString());
    }

    return null;
  }

  Future<List<Videos>?> getVideosFilter(String? titulo) async {
    try {
      List<Videos>? listVideos = await DashboardProvider.getListaVideosFilter(
        idClientCredential!.value,
        titulo,
      );

      if (listVideos != null) {
        return listVideos;
      } else {
        return showWarningSnackbar('Video não encontrado.');
      }
    } catch (e) {
      return showErrorSnackbar(e.toString());
    }
  }

  void logout() {
    Get.offAllNamed(Routes.login);
  }
}
