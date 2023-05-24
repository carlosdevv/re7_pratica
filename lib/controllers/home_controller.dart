import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:re7_pratica/controllers/dashboard_controller.dart';
import 'package:re7_pratica/controllers/file_library_controller.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/controllers/re7_play_controller.dart';
import 'package:re7_pratica/models/anexos_params.dart';
import 'package:re7_pratica/models/assuntos.dart';
import 'package:re7_pratica/models/chip_data.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/models/profile.dart';
import 'package:re7_pratica/models/register__complement_consult_params.dart';
import 'package:re7_pratica/models/registrar_consulta_params.dart';
import 'package:re7_pratica/models/registrar_consulta_props.dart';
import 'package:re7_pratica/models/resposta_relampago.dart';
import 'package:re7_pratica/models/total_consultas.dart';
import 'package:re7_pratica/models/user_secure_storage.dart';
import 'package:re7_pratica/models/user_unity.dart';
import 'package:re7_pratica/providers/home_provider.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class HomeController extends GetxController {
  final dashboardController = Get.find<DashboardController>();

  Rx<String> idCliente = ''.obs;
  final userProps =
      ProfileProps(celular: '', codigo: -1, email: '', nome: '', usuario: '')
          .obs;
  final totalConsultas =
      TotalConsultas(totalAberta: '', totalAndamento: '', totalEncerrada: '')
          .obs;

  Rx<bool> onLoadingAssuntos = true.obs;
  Rx<bool> onLoadingUserUnity = true.obs;
  Rx<bool> onLoadingFAQ = true.obs;
  Rx<bool> onLoadingListConsultas = true.obs;
  Rx<bool> isSuccessConsult = false.obs;
  RxList assuntosList = [].obs;
  RxList userUnitiesList = [].obs;
  Assuntos? assunto = Assuntos(descricao: '', id: -1);
  Rx<String> unityName = ''.obs;

  Rx<int> idConsulta = (-1).obs;
  final anexo = PlatformFile(name: '', size: -1).obs;

  Rx<int> typeQuery = 1.obs;

  List<ChipData> chips = [];
  final respostasRelampagoList = RxList<RespostaRelampago>([]);
  List<Consulta> recentsConsultas = [];

  final consulta = TextEditingController();
  final palavraChave = TextEditingController();

  final homeScrollController = ScrollController();
  Rx<double> positionScroll = (0.0).obs;

  Rx<File> audioFile = File('').obs;

  @override
  void onInit() {
    super.onInit();
    getUserProps();
    idCliente.value = dashboardController.idClientCredential!.value;
    homeScrollController.addListener(homeScrollControllerListener);
  }

  Future<void> getUserProps() async {
    ProfileProps? response = await dashboardController.getUserProps();

    if (response != null) {
      userProps.value = response;
      getUserUnities();
      getTotalConsultas();
      getRecentListaConsultas();
    } else {
      showErrorSnackbar(
          'Erro ao buscar dados do usuário, reinicie o aplicativo.');
    }
  }

  Future<void> getUserUnities() async {
    onLoadingUserUnity.value = true;
    List<UserUnity> response =
        await HomeProvider.getUserUnities(userProps.value.codigo.toString());

    if (response.isEmpty) {
      onLoadingAssuntos.value = false;
      update();
    } else {
      userUnitiesList.clear();
      for (var item in response) {
        userUnitiesList.add(item);
      }

      unityName.value = userUnitiesList
          .where((item) => item.idcliente.toString() == idCliente.value)
          .first
          .nmcliente;

      onLoadingUserUnity.value = false;

      update();
    }
  }

  Future<void> handleChangeUnity(UserUnity unity) async {
    final fileLibraryController = Get.find<FileLibraryController>();
    final queryController = Get.find<QueryController>();
    final re7playController = Get.find<Re7PlayController>();

    UserSecureStorage.setCode(unity.idcliente.toString());
    dashboardController.idClientCredential!.value = unity.idcliente.toString();

    idCliente.value = unity.idcliente.toString();
    unityName.value = unity.nmcliente;
    getAssuntos();
    getTotalConsultas();
    getRecentListaConsultas();
    queryController.listConsultas.clear();
    fileLibraryController.listAssuntos.clear();
    re7playController.listVideos.clear();
    fileLibraryController.getListAssuntosBiblioteca();
    queryController.getListConsultas();
    re7playController.getListVideos();
  }

  Future<void> getTotalConsultas() async {
    TotalConsultas response = await dashboardController.getTotalConsultas();
    totalConsultas.value = response;
    update();
  }

  Future<void> getAssuntos() async {
    chips.clear();
    consulta.clear();
    palavraChave.clear();
    onLoadingAssuntos.value = true;
    try {
      List<Assuntos> response = await HomeProvider.getAssuntos(
          dashboardController.idClientCredential!.value);
      if (response.isEmpty) {
        onLoadingAssuntos.value = false;
        showWarningSnackbar('Nenhum assunto encontrado.');
        update();
      }

      if (response.isNotEmpty) {
        assuntosList.clear();
        for (var item in response) {
          assuntosList.add(item);
        }
        onLoadingAssuntos.value = false;
        update();
      }
    } catch (e) {
      onLoadingAssuntos.value = false;
      update();
      showErrorSnackbar(e.toString());
    }
  }

  Future<void> registerConsult() async {
    try {
      isSuccessConsult.value = false;
      if (assunto!.id == -1) {
        showErrorSnackbar('Campo assuntos obrigatório.');
      } else if (typeQuery.value == 1) {
        if (consulta.text != '') {
          showLoadingSnackbar('Registrando consulta...');
          RegistrarConsultaParams registrarConsultaParams =
              RegistrarConsultaParams(
            idAssunto: assunto!.id,
            consulta: consulta.text,
            tipo: typeQuery.value,
            palavraChave:
                PalavraChave(chaves: chips.map((e) => e.label).toList()),
          );

          String body = registrarConsultaParamsToJson(registrarConsultaParams);

          RegistrarConsultaProps response = await HomeProvider.registerConsult(
              dashboardController.idClientCredential!.value,
              userProps.value.codigo.toString(),
              body);

          if (response.statusCode == '201') {
            Get.closeCurrentSnackbar();
            idConsulta.value = response.idConsulta;
            showSuccessSnackbar('Consulta registrada com sucesso.',
                duration: 1000);
            consulta.clear();
            chips.clear();
            getRecentListaConsultas();
            getTotalConsultas();
            Get.closeAllSnackbars();
            isSuccessConsult.value = true;
          }

          update();
        } else {
          showErrorSnackbar('Preencha o campo consulta para continuar.');
        }
      } else if (typeQuery.value == 2) {
        if (audioFile.value.path != '') {
          showLoadingSnackbar('Registrando consulta...');

          final bytes = await File(audioFile.value.path).readAsBytes();
          final audioFileBase64 = base64Encode(bytes);

          final now = DateTime.now();
          String formattedName = DateFormat('yyyyMMddHHmmss').format(now);

          RegistrarConsultaParams registrarConsultaParams =
              RegistrarConsultaParams(
            idAssunto: assunto!.id,
            consulta: audioFileBase64,
            tipo: typeQuery.value,
            nmArquivo: '$formattedName.mp3',
            palavraChave:
                PalavraChave(chaves: chips.map((e) => e.label).toList()),
          );

          String body = registrarConsultaParamsToJson(registrarConsultaParams);

          RegistrarConsultaProps response = await HomeProvider.registerConsult(
              dashboardController.idClientCredential!.value,
              userProps.value.codigo.toString(),
              body);

          if (response.statusCode == '201') {
            Get.closeCurrentSnackbar();
            idConsulta.value = response.idConsulta;
            showSuccessSnackbar('Consulta registrada com sucesso.',
                duration: 1000);
            consulta.clear();
            chips.clear();
            audioFile.value = File('');
            getRecentListaConsultas();
            getTotalConsultas();
            Get.closeAllSnackbars();
            isSuccessConsult.value = true;
          }

          update();
        } else {
          showErrorSnackbar('É necessário gravar um áudio para continuar.');
        }
      }
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  Future<void> registerComplementConsult(int idConsult) async {
    try {
      isSuccessConsult.value = false;
      if (typeQuery.value == 1) {
        if (consulta.text != '') {
          showLoadingSnackbar('Registrando complemento da consulta...');
          RegisterComplementConsultParams registerComplementConsultParams =
              RegisterComplementConsultParams(
            complemento: consulta.text,
            tipo: typeQuery.value,
          );

          String body = registerComplementConsultParamsToJson(
              registerComplementConsultParams);

          int statusCode = await HomeProvider.registerComplementConsult(
              dashboardController.idClientCredential!.value,
              userProps.value.codigo.toString(),
              idConsult.toString(),
              body);

          if (statusCode == 201) {
            Get.closeCurrentSnackbar();
            showSuccessSnackbar(
                'Complemento da consulta registrada com sucesso.',
                duration: 1000);
            consulta.clear();
            getRecentListaConsultas();
            getTotalConsultas();
            Get.closeAllSnackbars();
            isSuccessConsult.value = true;
          }

          update();
        } else {
          showErrorSnackbar('Preencha todos os campos obrigatórios.');
        }
      } else if (typeQuery.value == 2) {
        if (audioFile.value.path != '') {
          showLoadingSnackbar('Registrando consulta...');

          final bytes = await File(audioFile.value.path).readAsBytes();
          final audioFileBase64 = base64Encode(bytes);

          final now = DateTime.now();
          String formattedName = DateFormat('yyyyMMddHHmmss').format(now);

          RegisterComplementConsultParams registerComplementConsultParams =
              RegisterComplementConsultParams(
            complemento: audioFileBase64,
            tipo: typeQuery.value,
            nmArquivo: '$formattedName.mp3',
          );

          String body = registerComplementConsultParamsToJson(
              registerComplementConsultParams);

          int statusCode = await HomeProvider.registerComplementConsult(
              dashboardController.idClientCredential!.value,
              userProps.value.codigo.toString(),
              idConsult.toString(),
              body);

          if (statusCode == 201) {
            Get.closeCurrentSnackbar();
            showSuccessSnackbar(
                'Complemento da consulta registrada com sucesso.',
                duration: 1000);
            consulta.clear();
            audioFile.value = File('');
            getRecentListaConsultas();
            getTotalConsultas();
            Get.closeAllSnackbars();
            isSuccessConsult.value = true;
          }

          update();
        } else {
          showErrorSnackbar('É necessário gravar um áudio para continuar.');
        }
      }
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  Future<void> insertAnexos({required int idOrigem}) async {
    Get.closeAllSnackbars();
    try {
      if (anexo.value.name != '') {
        final bytes = await File(anexo.value.path!).readAsBytes();
        final fileBase64 = base64Encode(bytes);
        AnexosParams anexosParams = AnexosParams(
          base64: fileBase64,
          descArquivo: '',
          idOrigem: idOrigem,
          nmArquivo: anexo.value.name,
        );

        String body = anexosParamsToJson(anexosParams);

        var response = await HomeProvider.inserirAnexo(
            idConsulta.value.toString(),
            dashboardController.idClientCredential!.value,
            userProps.value.codigo.toString(),
            body);

        if (response == 201) {
          isSuccessConsult.value = false;
          Get.back();
          Get.back();
        }
      } else {
        showErrorSnackbar('Selecione um arquivo.');
      }
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  void addChip() {
    if (palavraChave.text.isNotEmpty) {
      ChipData newChip = ChipData(label: palavraChave.text);
      chips.add(newChip);
      palavraChave.clear();
    }
  }

  Future<void> getRespostasRelampago() async {
    respostasRelampagoList.clear();
    onLoadingFAQ.value = true;
    try {
      List<RespostaRelampago> response =
          await HomeProvider.getRespostasRelampago(
              dashboardController.idClientCredential!.value);
      onLoadingFAQ.value = false;
      if (response.isNotEmpty) {
        for (var item in response) {
          respostasRelampagoList.add(item);
          update();
        }
      } else {
        onLoadingFAQ.value = false;
        showErrorSnackbar('Nenhuma pergunta encontrada.');
      }
    } catch (e) {
      onLoadingFAQ.value = false;
      showErrorSnackbar(e.toString());
    }
  }

  Future<void> getRecentListaConsultas() async {
    onLoadingListConsultas.value = true;
    List<Consulta> list = await dashboardController.getRecentListaConsultas(
      userProps.value.codigo.toString(),
      '0',
    );
    if (list.isNotEmpty) {
      recentsConsultas.clear();
      for (var item in list) {
        recentsConsultas.add(item);
      }
    }
    onLoadingListConsultas.value = false;
    update();
  }

  void homeScrollControllerListener() {
    if (homeScrollController.position.atEdge) {
      bool isMinScroll = homeScrollController.offset <= 0;
      isMinScroll ? positionScroll.value = 0 : positionScroll.value = 1;
    }
  }

  Future<void> refreshList() async {
    getRespostasRelampago();
    update();
  }

  String? searchFile(String value) {
    if (value.isEmpty) {
      refreshList();
    } else {
      final suggestions = respostasRelampagoList.where((question) {
        final questionTitle = question.descPergunta.toLowerCase();
        final input = value.toLowerCase();

        return questionTitle.contains(input);
      }).toList();

      respostasRelampagoList.value = suggestions;
    }

    return null;
  }
}
