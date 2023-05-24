import 'package:get/get.dart';
import 'package:re7_pratica/controllers/file_library_controller.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/controllers/dashboard_controller.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/controllers/re7_play_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<QueryController>(() => QueryController());
    Get.lazyPut<FileLibraryController>(() => FileLibraryController());
    Get.lazyPut<Re7PlayController>(() => Re7PlayController());
  }
}
