import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re7_pratica/controllers/dashboard_controller.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/models/profile.dart';
import 'package:re7_pratica/models/social_network_props.dart';
import 'package:re7_pratica/models/terms_props.dart';
import 'package:re7_pratica/models/user_secure_storage.dart';
import 'package:re7_pratica/providers/profile_provider.dart';
import 'package:re7_pratica/providers/recover_password_provider.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class ProfileController extends GetxController {
  final dashboardController = Get.find<DashboardController>();
  final homeController = Get.find<HomeController>();

  final emailInput = TextEditingController();
  final nameInput = TextEditingController();
  final phoneInput = TextEditingController();

  Rx<bool> onLoadingUserInfos = true.obs;
  Rx<bool> onLoadingChangePassword = false.obs;
  Rx<bool> onLoadingListSocialNetwork = true.obs;

  Rx<String> email = ''.obs;
  Rx<String> name = ''.obs;
  Rx<String> phone = ''.obs;
  Rx<String> userLogin = ''.obs;
  Rx<String>? profilePhoto = ''.obs;
  Rx<String> test = ''.obs;
  Rx<int> codeClient = (-1).obs;

  List<SocialNetworkProps> listSocialNetwork = [];

  Rx<File>? imageFromGalery = File('').obs;

  Rx<bool> isEditMode = false.obs;
  Rx<bool> hasPhotoFromGallery = false.obs;

  Rx<bool> isObscure = true.obs;
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final newPasswordFormKey = GlobalKey<FormState>();

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    getListSocialNetwork();
  }

  Future<void> updateProfile() async {
    try {
      if (nameInput.text.isEmpty ||
          emailInput.text.isEmpty ||
          phoneInput.text.isEmpty) {
        showErrorSnackbar(
            'Preencha os campos obrigatórios para atualizar seus dados.');
      } else {
        if (imageFromGalery!.value.path.isNotEmpty) {
          final bytes = await File(imageFromGalery!.value.path).readAsBytes();
          final imgBase64 = base64Encode(bytes);
          showLoadingSnackbar('Atualizando Perfil...');
          var response = await ProfileProvider.updateProfileInfo(
            dashboardController.userCredential!.value,
            nameInput.text,
            emailInput.text,
            phoneFormatter.getUnmaskedText(),
            imgBase64,
          );
          Get.closeCurrentSnackbar();
          if (response == 200) {
            showSuccessSnackbar('Dados atualizados com sucesso!');
            homeController.userProps.value.nome = nameInput.text;
            name.value = nameInput.text;
            email.value = emailInput.text;
            phone.value = phoneFormatter.getUnmaskedText();
            isEditMode.value = false;
            hasPhotoFromGallery.value = true;
          }
        } else {
          showLoadingSnackbar('Atualizando Perfil...');
          var response = await ProfileProvider.updateProfileInfo(
            dashboardController.userCredential!.value,
            nameInput.text,
            emailInput.text,
            phoneFormatter.getUnmaskedText(),
            '',
          );
          Get.closeCurrentSnackbar();
          if (response == 200) {
            showSuccessSnackbar('Dados atualizados com sucesso!');
            homeController.userProps.value.nome = nameInput.text;
            name.value = nameInput.text;
            email.value = emailInput.text;
            phone.value = phoneFormatter.getUnmaskedText();
            isEditMode.value = false;
            hasPhotoFromGallery.value = true;
          }
        }
      }
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  void getUserInfo() {
    onLoadingUserInfos.value = true;
    ProfileProps response = homeController.userProps.value;

    name.value = response.nome;
    email.value = response.email;
    phone.value = response.celular;
    userLogin.value = response.usuario;
    codeClient.value = response.codigo;
    profilePhoto!.value = response.foto;
    onLoadingUserInfos.value = false;
    update();
  }

  void changeEditMode() {
    isEditMode.value = !isEditMode.value;
    if (isEditMode.value) {
      emailInput.text = email.value;
      nameInput.text = name.value;
      phoneInput.text = phone.value;
    }
  }

  Future getTerms() async {
    try {
      showLoadingSnackbar('Abrindo PDF...');
      TermsProps response = await ProfileProvider.getTerms();
      String url = response.caminho;

      final file = await downloadFile(url);
      if (file == null) {
        Get.closeAllSnackbars();
        return;
      }
      OpenFile.open(file.path);
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  Future<File?> downloadFile(String url) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/Termos.pdf');

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

  Future pickImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      imageFromGalery!.value = await saveImagePermanently(image.path);
      update();
    } on PlatformException catch (e) {
      showErrorSnackbar(
          'Ocorreu um erro ao selecionar imagem.\n${e.toString()}');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  void handleChangePassword() async {
    if (newPasswordFormKey.currentState!.validate()) {
      if (newPassword.text == confirmPassword.text) {
        onLoadingChangePassword.value = true;
        int status = await RecoverPasswordProvider.updatePassword(
            dashboardController.userCredential!.value, confirmPassword.text);

        if (status == 200) {
          newPassword.text = '';
          confirmPassword.text = '';
          showSuccessSnackbar('Senha atualizada com sucesso!');
          onLoadingChangePassword.value = false;
        }
      } else {
        onLoadingChangePassword.value = false;
        showErrorSnackbar('A senhas devem ser iguais.');
      }
    } else {
      showErrorSnackbar('Preencha todos os campos para continuar.');
    }
  }

  void showPassword() {
    isObscure.value = !isObscure.value;
    update();
  }

  Future<void> getListSocialNetwork() async {
    listSocialNetwork.clear();
    onLoadingListSocialNetwork.value = true;
    List<SocialNetworkProps>? list = await ProfileProvider.getListSocialNetwork(
      dashboardController.idClientCredential!.value,
    );

    if (list != null) {
      for (var item in list) {
        listSocialNetwork.add(item);
      }
      onLoadingListSocialNetwork.value = false;
    }

    onLoadingListSocialNetwork.value = false;
    update();
  }

  void logout() {
    UserSecureStorage.removeStorage();
    dashboardController.logout();
  }
}
