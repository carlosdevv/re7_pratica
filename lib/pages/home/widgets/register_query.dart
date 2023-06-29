import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/models/assuntos.dart';
import 'package:re7_pratica/pages/home/widgets/record_audio.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/input.dart';
import 'package:re7_pratica/utils/loading.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class RegisterQueryDialog extends StatefulWidget {
  final String title;
  final bool hasWordKey;
  final bool hasSubject;
  final bool isComplementConsult;
  final dynamic Function()? onTap;

  const RegisterQueryDialog({
    Key? key,
    required this.title,
    this.hasWordKey = true,
    this.hasSubject = true,
    this.isComplementConsult = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<RegisterQueryDialog> createState() => _RegisterQueryDialogState();
}

class _RegisterQueryDialogState extends State<RegisterQueryDialog> {
  final HomeController homeController = Get.find<HomeController>();
  Assuntos? _selectedValue;

  @override
  void initState() {
    homeController.typeQuery.value = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
              child: Column(
                children: [
                  buildContentModal(context),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.wsz, vertical: 15.wsz),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Color(0xfff9f9fb),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _button(
                          text: 'Cancelar',
                          background: Colors.white,
                          color: AppColors.black,
                          onTap: () {
                            Get.back();
                          },
                        ),
                        SizedBox(width: 8.wsz),
                        _button(
                          text: 'Enviar',
                          hasGradient: true,
                          color: AppColors.white,
                          onTap: widget.isComplementConsult
                              ? widget.onTap
                              : () async {
                                  await homeController.registerConsult();
                                  if (homeController.isSuccessConsult.value) {
                                    await _pickFile();
                                  }
                                },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContentModal(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.wsz,
            right: 20.wsz,
            top: 30.wsz,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18.wsz,
                    fontWeight: FontWeight.w700,
                  ),
                  child: Text(widget.title)),
              DefaultTextStyle(
                  style: TextStyle(
                    color: AppColors.text100,
                    fontSize: 12.wsz,
                    fontWeight: FontWeight.w700,
                  ),
                  child: const Text('Preencha todos os campos obrigatórios')),
              SizedBox(height: 25.hsz),
              widget.hasSubject
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _selectAssuntoDropdown(),
                        SizedBox(height: 20.hsz),
                      ],
                    )
                  : Container(),
              _typeQueryOptions(),
              SizedBox(height: 10.hsz),
              Obx(
                () => homeController.typeQuery.value == 1
                    ? InputWidget(
                        controller: homeController.consulta,
                        hintText: '',
                        label: 'Consulta *',
                        readOnly: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 5,
                        padHorizontal: 18.hsz,
                        padVertical: 16.hsz,
                      )
                    : _audioTypeContainer(),
              ),
              widget.hasWordKey
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.hsz),
                        InputWidget(
                          controller: homeController.palavraChave,
                          hintText: '',
                          label: 'Palavras Chaves',
                          readOnly: false,
                          hasIcon: true,
                          padHorizontal: 18.hsz,
                          padVertical: 16.hsz,
                          icon: const Icon(
                            Icons.add_circle_outlined,
                            color: AppColors.primary,
                          ),
                          onPressedIcon: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            homeController.addChip();
                            currentFocus.unfocus();
                          },
                        ),
                        buildChips(),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Column _audioTypeContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enviar Áudio',
          style: TextStyle(
            color: AppColors.text100,
            fontSize: 16.wsz,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.hsz),
        const RecordAudioWidget()
      ],
    );
  }

  Obx _typeQueryOptions() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo',
              style: TextStyle(
                color: AppColors.text100,
                fontSize: 16.wsz,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: homeController.typeQuery.value,
                      activeColor: AppColors.primary,
                      onChanged: (int? newValue) =>
                          homeController.typeQuery.value = newValue!,
                    ),
                    Text(
                      'Texto',
                      style: TextStyle(
                        color: AppColors.text100,
                        fontSize: 16.wsz,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5.wsz),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: homeController.typeQuery.value,
                      activeColor: AppColors.primary,
                      onChanged: (int? newValue) =>
                          homeController.typeQuery.value = newValue!,
                    ),
                    Text(
                      'Áudio',
                      style: TextStyle(
                        color: AppColors.text100,
                        fontSize: 16.wsz,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Future<dynamic> _pickFile() {
    return Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(18.wsz),
      content: Column(
        children: [
          Icon(
            Icons.upload_rounded,
            color: AppColors.text100,
            size: 60.wsz,
          ),
          SizedBox(height: 20.hsz),
          Text(
            'Deseja inserir um anexo a essa consulta?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 18.wsz,
            ),
          ),
          SizedBox(height: 16.hsz),
        ],
      ),
      confirm: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () async {
          final result = await FilePicker.platform.pickFiles();
          if (result == null) {
            return;
          } else {
            homeController.anexo.value = result.files.first;
            _confirmationModal();
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(14.wsz),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            'Escolher arquivo',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16.wsz,
            ),
          ),
        ),
      ),
      cancel: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.back();
          Get.back();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(14.wsz),
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Sem anexo',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 16.wsz,
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _confirmationModal() {
    return Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(18.wsz),
      content: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 60.wsz,
          ),
          SizedBox(height: 20.hsz),
          Text(
            'Tem certeza que deseja anexar esse arquivo?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 18.wsz,
            ),
          ),
          SizedBox(height: 16.hsz),
        ],
      ),
      confirm: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () async {
          await homeController.insertAnexos(idOrigem: 1);
          showSuccessSnackbar('Anexo enviado com sucesso.');
        },
        child: Flexible(
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(14.wsz),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              'Confirmar',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.wsz,
              ),
            ),
          ),
        ),
      ),
      cancel: InkWell(
        splashColor: AppColors.error.withOpacity(0.35),
        highlightColor: AppColors.error.withOpacity(0.35),
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          PlatformFile emptyAnexo = PlatformFile(name: '', size: -1);
          homeController.anexo.value = emptyAnexo;

          Get.back();
        },
        child: Flexible(
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(14.wsz),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 16.wsz,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChips() => Wrap(
        spacing: 8.wsz,
        children: homeController.chips
            .map((chip) => Chip(
                  label: Text(chip.label),
                  backgroundColor: AppColors.primary,
                  labelStyle: const TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                  deleteIconColor: AppColors.white,
                  onDeleted: () =>
                      setState(() => homeController.chips.remove(chip)),
                ))
            .toList(),
      );

  GetBuilder<HomeController> _selectAssuntoDropdown() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        if (controller.onLoadingAssuntos.value) {
          return DropdownButtonFormField<String>(
            onChanged: (value) {},
            decoration: InputDecoration(
              fillColor: AppColors.containerInput,
              filled: true,
              labelText: 'Carregando...',
              labelStyle: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 16.wsz,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.wsz, horizontal: 18.wsz),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            items: const [],
            style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.wsz),
            isExpanded: true,
            icon: SizedBox(
              width: 16.wsz,
              height: 16.wsz,
              child: showLoading(AppColors.black, 2.wsz),
            ),
          );
        }
        return DropdownButtonHideUnderline(
            child: DropdownButtonFormField<Assuntos>(
          decoration: InputDecoration(
            labelText: 'Assuntos *',
            labelStyle: TextStyle(
              color: AppColors.text100,
              fontWeight: FontWeight.w600,
              fontSize: 16.wsz,
            ),
            fillColor: AppColors.containerInput,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 13.wsz, horizontal: 18.wsz),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
          value: _selectedValue,
          items: controller.assuntosList
              .map((value) => DropdownMenuItem<Assuntos>(
                    value: value,
                    child: Text(value.descricao),
                  ))
              .toList(),
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16.wsz,
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              controller.assunto = _selectedValue;
            });
          },
        ));
      },
    );
  }

  InkWell _button(
      {String? text,
      Color? background,
      Color? color,
      Function()? onTap,
      bool hasGradient = false}) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: 100.wsz,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15.wsz, vertical: 12.wsz),
        decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(6),
            gradient: hasGradient
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryDark, AppColors.primary])
                : null,
            boxShadow: [
              BoxShadow(
                offset: const Offset(1, 1),
                blurRadius: 6,
                color: AppColors.black.withOpacity(0.15),
              )
            ]),
        child: Text(
          text!,
          style: TextStyle(
            color: color,
            fontSize: 12.wsz,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
