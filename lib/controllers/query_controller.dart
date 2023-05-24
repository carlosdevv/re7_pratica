import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re7_pratica/controllers/dashboard_controller.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/models/anexos_consulta_props.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/models/relatorio_props.dart';
import 'package:re7_pratica/providers/consultas_provider.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class QueryController extends GetxController {
  final dashboardController = Get.find<DashboardController>();
  final homeController = Get.find<HomeController>();

  RxInt page = 1.obs;
  RxInt qtdRegistros = (-1).obs;
  RxInt qtdPaginas = (-1).obs;
  List<Consulta> listConsultas = [];
  List<Consulta> listQueryFiltered = [];
  List<String> listAnexos = [];
  List<String> listAudios = [];
  List<String> listAnswerAudios = [];

  RxBool onLoadingListConsultas = true.obs;
  RxBool isMoreItems = true.obs;
  RxBool loadMore = false.obs;
  RxBool hasAnexos = false.obs;
  RxInt cardStatus = (-1).obs;
  RxInt auxStatus = 1.obs;

  final consulta = TextEditingController();
  final protocolo = TextEditingController();
  final data = TextEditingController();

  final formFilterConsultaKey = GlobalKey<FormState>();

  final dateFormatter = MaskTextInputFormatter(
    mask: "##-##-####",
    type: MaskAutoCompletionType.lazy,
  );

  final consultaScrollController = ScrollController();
  final consultaScrollControllerForFilter = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getListConsultas();
    homeController.getAssuntos();
    consultaScrollController.addListener(consultaScrollControllerListener);
    consultaScrollControllerForFilter
        .addListener(consultaScrollControllerListenerForFilter);
  }

  void consultaScrollControllerListener() {
    paginate(consultaScrollController, false);
  }

  void consultaScrollControllerListenerForFilter() {
    paginate(consultaScrollControllerForFilter, true);
  }

  Future<void> getListConsultas() async {
    onLoadingListConsultas.value = true;
    await homeController.getUserProps();
    Consultas? list = await dashboardController.getConsultas(
        homeController.userProps.value.codigo.toString(),
        page.value.toString());

    if (list != null) {
      addConsultaToList(list.consultas);
      qtdRegistros.value = list.qtdRegistros;
      qtdPaginas.value = list.qtdPaginas;
      isMoreItems.value = true;
    } else {
      isMoreItems.value = false;
    }

    onLoadingListConsultas.value = false;
    update();
  }

  Future<void> getListConsultasFilter() async {
    if (consulta.text != '' ||
        data.text != '' ||
        protocolo.text != '' ||
        homeController.assunto!.id != -1 ||
        cardStatus.value != -1) {
      onLoadingListConsultas.value = true;
      Consultas? list = await dashboardController.getConsultasFilter(
          homeController.userProps.value.codigo.toString(),
          '1',
          protocolo.text == '' ? null : protocolo.text,
          homeController.assunto!.id == -1
              ? null
              : homeController.assunto!.id.toString(),
          data.text != '' ? dateFormatter.maskText(data.text.trim()) : null,
          consulta.text == '' ? null : consulta.text,
          cardStatus.value == -1 ? null : cardStatus.value.toString());

      if (list == null) {
        listConsultas.clear();
        isMoreItems.value = false;
      }

      if (list != null) {
        listConsultas.clear();
        addConsultaToList(list.consultas);
        qtdRegistros.value = list.qtdRegistros;
        qtdPaginas.value = list.qtdPaginas;
        onLoadingListConsultas.value = false;
        isMoreItems.value = true;
        if (listConsultas.length < 10) {
          isMoreItems.value = false;
        }
      } else {
        isMoreItems.value = false;
        onLoadingListConsultas.value = false;
      }

      update();
    } else {
      showErrorSnackbar('Preencha ao menos um campo obrigatório.');
    }
  }

  Future<void> getListConsultasFilterByStatus() async {
    onLoadingListConsultas.value = true;
    isMoreItems.value = true;

    if (auxStatus.value != cardStatus.value) {
      listQueryFiltered.clear();
      auxStatus.value = cardStatus.value;
    }

    Consultas? list = await dashboardController.getConsultasFilter(
        homeController.userProps.value.codigo.toString(),
        page.value.toString(),
        null,
        null,
        null,
        null,
        cardStatus.value.toString());

    if (list == null && page.value == 1) {
      listQueryFiltered.clear();
    }

    if (list != null) {
      addConsultToListFiltered(list.consultas);
      qtdRegistros.value = list.qtdRegistros;
      qtdPaginas.value = list.qtdPaginas;
      onLoadingListConsultas.value = false;

      if (listQueryFiltered.length < 10) {
        isMoreItems.value = false;
      }
    } else {
      isMoreItems.value = false;
      onLoadingListConsultas.value = false;
    }

    update();
  }

  void addConsultaToList(List<Consulta> list) {
    for (var item in list) {
      listConsultas.add(item);
    }
    update();
  }

  void addConsultToListFiltered(List<Consulta> list) {
    for (var item in list) {
      listQueryFiltered.add(item);
    }
    update();
  }

  void paginate(ScrollController scrollController, bool isFiltered) {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      loadMore.value = true;
      if (page.value > qtdPaginas.value) {
        isMoreItems.value = false;
        loadMore.value = false;
      } else {
        fetchMore(isFiltered);
      }
    }
  }

  Future<void> fetchMore(bool isFiltered) async {
    page.value++;
    isFiltered ? getListConsultasFilterByStatus() : getListConsultas();
  }

  Future<void> refreshList() async {
    onLoadingListConsultas.value = true;
    isMoreItems.value = true;
    page.value = 1;
    listConsultas.clear();
    update();
    getListConsultas();
  }

  Future openPDF(String idConsulta) async {
    try {
      showLoadingSnackbar('Carregando PDF...');
      RelatorioProps response =
          await ConsultasProvider.getRelatorioPDF(idConsulta);
      String url = response.caminho;

      final file = await downloadPDF(url);
      if (file == null) {
        return;
      }

      OpenFile.open(file.path);
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  Future<File?> downloadPDF(String url) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/relatorio.pdf');

      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      showErrorSnackbar(
          'Ocorreu um erro ao baixar o arquivo, tente novamente mais tarde.');
      return null;
    }
  }

  Future<bool?> getAnexos(String idConsulta) async {
    try {
      listAnexos.clear();

      AnexosConsultaProps? response =
          await ConsultasProvider.getAnexosConsulta(idConsulta, '1');

      if (response == null) {
        showWarningSnackbar('Não existem anexos para esta consulta.');
        return false;
      } else {
        for (var item in response.listaCaminho.caminhos) {
          listAnexos.add(item);
        }
        return true;
      }
    } catch (e) {
      showErrorSnackbar(e.toString());
    }

    return null;
  }

  Future<bool?> getAudios(String idConsulta) async {
    try {
      listAudios.clear();

      AnexosConsultaProps? response =
          await ConsultasProvider.getAnexosConsulta(idConsulta, '2');

      if (response == null) {
        showWarningSnackbar('Não existem áudios para esta consulta.');
        return false;
      } else {
        for (var item in response.listaCaminho.caminhos) {
          listAudios.add(item);
        }
        listAnswerAudios = listAudios.sublist(1);

        return true;
      }
    } catch (e) {
      showErrorSnackbar(e.toString());
    }

    return null;
  }

  Future openAnexo(String url) async {
    try {
      showLoadingSnackbar('Carregando anexo...');
      final file = await downloadAnexo(url);
      if (file == null) {
        return;
      }

      OpenFile.open(file.path);
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  Future<File?> downloadAnexo(String url) async {
    try {
      final name = url.split('/').last;
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/$name');

      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      showErrorSnackbar(
          'Ocorreu um erro ao baixar o anexo, tente novamente mais tarde.');
      return null;
    }
  }
}
