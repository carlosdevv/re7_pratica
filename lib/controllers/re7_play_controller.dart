import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/controllers/dashboard_controller.dart';
import 'package:re7_pratica/models/videos.dart';

class Re7PlayController extends GetxController {
  final dashboardController = Get.find<DashboardController>();

  final listVideos = RxList<Videos>([]);

  final titulo = TextEditingController();

  Rx<bool> onLoadingListVideos = true.obs;

  @override
  void onInit() {
    super.onInit();
    getListVideos();
  }

  Future<void> getListVideos() async {
    onLoadingListVideos.value = true;
    List<Videos>? list = await dashboardController.getVideos();

    if (list != null) {
      addVideosToList(list);
    }
    onLoadingListVideos.value = false;
    update();
  }

  Future<void> getListVideosFilter() async {
    if (titulo.text.isNotEmpty) {
      onLoadingListVideos.value = true;
      List<Videos>? list =
          await dashboardController.getVideosFilter(titulo.text);

      if (list != null) {
        listVideos.clear();
        addVideosToList(list);
        onLoadingListVideos.value = false;
      } else {
        onLoadingListVideos.value = false;
      }

      update();
    } else {
      refreshListVideos();
    }
  }

  void addVideosToList(List<Videos> list) {
    for (var item in list) {
      listVideos.add(item);
    }
    update();
  }

  Future<void> refreshListVideos() async {
    onLoadingListVideos.value = true;

    listVideos.clear();
    onLoadingListVideos.value = false;
    update();
    getListVideos();
  }
}
