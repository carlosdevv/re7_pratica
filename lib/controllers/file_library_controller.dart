import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re7_pratica/controllers/dashboard_controller.dart';
import 'package:re7_pratica/models/arquivos.dart';
import 'package:re7_pratica/models/assunto_biblioteca.dart';
import 'package:re7_pratica/models/path_file_props.dart';
import 'package:re7_pratica/providers/biblioteca_provider.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class FileLibraryController extends GetxController {
  final dashboardController = Get.find<DashboardController>();

  var page = 1;
  Rx<int> qtdRegistros = (-1).obs;
  Rx<int> qtdPaginas = (-1).obs;

  final listFiles = RxList<Arquivo>([]);
  final listAssuntos = RxList<AssuntoBiblioteca>([]);
  final searchFilterValue = TextEditingController();

  Rx<bool> isMoreItems = true.obs;
  Rx<bool> onLoadingListFiles = true.obs;
  Rx<bool> onLoadingListAssuntos = true.obs;
  Rx<bool> loadMore = false.obs;
  Rx<bool> filteredByFile = false.obs;

  Rx<bool> isPdf = false.obs;
  Rx<bool> isPpt = false.obs;
  Rx<bool> isDoc = false.obs;
  Rx<bool> isXls = false.obs;

  Rx<int> searchType = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getListAssuntosBiblioteca();
  }

  Future<void> getListFiles(int? idAssunto, String? content) async {
    listFiles.clear();
    onLoadingListFiles.value = true;
    Arquivos? list = await dashboardController.getArquivos(
        page.toString(), idAssunto, content);

    if (list != null) {
      addArquivosToList(list.arquivos);
      qtdRegistros.value = list.qtdRegistros;
      qtdPaginas.value = list.qtdPaginas;
    } else {
      isMoreItems.value = false;
    }
    onLoadingListFiles.value = false;
    update();
  }

  Future<void> getListAssuntosBiblioteca() async {
    onLoadingListAssuntos.value = true;
    List<AssuntoBiblioteca>? listAssuntosBiblioteca =
        await dashboardController.getAssuntosBiblioteca();

    if (listAssuntosBiblioteca != null) {
      addAssuntosToList(listAssuntosBiblioteca);
    }

    onLoadingListAssuntos.value = false;
    update();
  }

  void addArquivosToList(List<Arquivo> list) {
    for (var item in list) {
      listFiles.add(item);
    }
    update();
  }

  void addAssuntosToList(List<AssuntoBiblioteca> list) {
    for (var item in list) {
      listAssuntos.add(item);
    }
    update();
  }

  void paginate(ScrollController scrollController) {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (page > qtdPaginas.value) {
        isMoreItems.value = false;
        loadMore.value = false;
      } else {
        loadMore.value = true;
        fetchMore();
      }
    }
  }

  Future<void> fetchMore() async {
    page++;
    getListAssuntosBiblioteca();
  }

  Future<void> refreshList() async {
    listAssuntos.clear();
    listFiles.clear();
    filteredByFile.value = false;
    getListAssuntosBiblioteca();
    update();
  }

  Future<String?> searchFile() async {
    filteredByFile.value = false;
    if (searchFilterValue.text.isEmpty) {
      refreshList();
    } else {
      if (searchType.value == 1) {
        final suggestions = listAssuntos.where((file) {
          final fileTitle = file.descricao.toLowerCase();
          final input = searchFilterValue.text.toLowerCase();

          return fileTitle.contains(input);
        }).toList();

        listAssuntos.value = suggestions;
      } else {
        filteredByFile.value = true;
        await getListFiles(null, searchFilterValue.text);
      }
    }

    return null;
  }

  Future openFile(String idArquivo, String name) async {
    try {
      PathFileProps response = await BibliotecaProvider.getPathFile(idArquivo);
      String url = response.caminho;

      final file = await downloadFile(url, name);
      if (file == null) {
        return;
      }

      OpenFile.open(file.path);
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  Future<File?> downloadFile(String url, String name) async {
    try {
      showWarningSnackbar('Baixando arquivo...');
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
      showSuccessSnackbar('Arquivo baixado com sucesso!');
      return file;
    } catch (e) {
      showErrorSnackbar(
          'Ocorreu um erro ao baixar o arquivo, tente novamente mais tarde.');
      return null;
    }
  }
}
