import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/models/assuntos.dart';
import 'package:re7_pratica/pages/query/widgets/table_queries.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class ConsultasPage extends StatefulWidget {
  const ConsultasPage({Key? key}) : super(key: key);

  @override
  State<ConsultasPage> createState() => _ConsultasPageState();
}

class _ConsultasPageState extends State<ConsultasPage> {
  final QueryController _queryController = Get.find<QueryController>();
  final HomeController _homeController = Get.find<HomeController>();
  Assuntos? _selectedValueAssunto;
  String? _selectedValueStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 45.hsz),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.wsz),
              child: Row(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 28.wsz,
                    color: AppColors.text,
                  ),
                  SizedBox(width: 10.wsz),
                  Text(
                    'Lista de Consultas',
                    style: TextStyle(
                      fontSize: 18.wsz,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 8.wsz),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        _queryController.refreshList();
                      },
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 26.wsz,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.hsz),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.wsz),
              child: _columnsTable(),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.wsz),
              child: const TableConsultasWidget(),
            )),
          ],
        ),
      ),
    );
  }

  Container _columnsTable() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.wsz, horizontal: 16.wsz),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            'Situação',
            style: TextStyle(
              fontSize: 14.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 15.wsz),
          Text(
            'Tipo',
            style: TextStyle(
              fontSize: 14.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 30.wsz),
          Text(
            'Data',
            style: TextStyle(
              fontSize: 14.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 45.wsz),
          Text(
            'Assunto',
            style: TextStyle(
              fontSize: 14.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container _header() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0.wsz, 30.0.wsz, 16.0.wsz, 20.0.wsz),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Painel de Consultas',
            style: TextStyle(
              fontSize: 25.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.wsz),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                _homeController.assunto!.id = -1;
                _selectedValueAssunto = null;
                _selectedValueStatus = null;
                _queryController.protocolo.text = '';
                _queryController.data.text = '';
                _queryController.consulta.text = '';
                _queryController.cardStatus.value = -1;
                Get.bottomSheet(
                  _filter(),
                  backgroundColor: Colors.white,
                  barrierColor: Colors.transparent,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.wsz),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.primary100),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                        color: AppColors.black.withOpacity(0.16),
                      ),
                    ]),
                child: Icon(
                  Icons.search,
                  color: AppColors.black,
                  size: 26.wsz,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _filter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.wsz, vertical: 20.wsz),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 6,
            color: AppColors.black.withOpacity(0.16),
          )
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.wsz),
            topRight: Radius.circular(20.wsz)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _queryController.formFilterConsultaKey,
          child: Column(
            children: [
              _headerBS(),
              SizedBox(height: 30.wsz),
              SizedBox(
                child: _inputBS(
                  'Consulta*',
                  'Digite a consulta',
                  _queryController.consulta,
                  TextInputType.text,
                ),
              ),
              SizedBox(height: 24.wsz),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.425,
                    child: _inputBS(
                      'Protocolo*',
                      '0000',
                      _queryController.protocolo,
                      TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.425,
                    child: _inputBS(
                      'Data*',
                      'dd/mm/aaaa',
                      _queryController.data,
                      TextInputType.datetime,
                      mask: MaskTextInputFormatter(mask: "##/##/####"),
                    ),
                  )
                ],
              ),
              SizedBox(height: 24.wsz),
              _selectAssuntoDropdown(),
              SizedBox(height: 24.wsz),
              _selectStatusDropdown(),
              SizedBox(height: 24.wsz),
              InkWell(
                onTap: () async {
                  await _queryController.getListConsultasFilter();
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.wsz),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryDark, AppColors.primary]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Aplicar',
                    style: TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectStatusDropdown() {
    List<String> statusOptions = [
      'Consultas Abertas',
      'Consultas em Andamento',
      'Consultas Encerradas',
      'Consultas Canceladas',
    ];
    return GetBuilder<QueryController>(
      init: QueryController(),
      initState: (_) {},
      builder: (controller) {
        return DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Status',
            labelStyle: TextStyle(
              color: AppColors.text100,
              fontWeight: FontWeight.w600,
              fontSize: 14.wsz,
            ),
            fillColor: AppColors.containerInput,
            filled: true,
            contentPadding: EdgeInsets.all(12.wsz),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary)),
          ),
          value: _selectedValueStatus,
          items: statusOptions
              .map((value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
              _selectedValueStatus = value;
              controller.cardStatus.value =
                  validateCardStatus(_selectedValueStatus);
            });
          },
        ));
      },
    );
  }

  GetBuilder<HomeController> _selectAssuntoDropdown() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        if (controller.onLoadingAssuntos.value) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: AppColors.containerInput,
              filled: true,
              labelText: 'Carregando...',
              labelStyle: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 12.wsz,
              ),
              contentPadding: EdgeInsets.all(12.wsz),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
            ),
            items: const [],
            style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.wsz),
            isExpanded: true,
            onChanged: (value) {},
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
            labelText: 'Assuntos',
            labelStyle: TextStyle(
              color: AppColors.text100,
              fontWeight: FontWeight.w600,
              fontSize: 14.wsz,
            ),
            fillColor: AppColors.containerInput,
            filled: true,
            contentPadding: EdgeInsets.all(12.wsz),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary)),
          ),
          value: _selectedValueAssunto,
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
              _selectedValueAssunto = value;
              controller.assunto = _selectedValueAssunto;
            });
          },
        ));
      },
    );
  }

  Column _inputBS(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType type, {
    TextInputFormatter? mask,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.wsz),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.text100,
              fontSize: 12.wsz,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 4.wsz),
        SizedBox(
          height: 50.hsz,
          child: TextFormField(
            controller: controller,
            keyboardType: type,
            inputFormatters: mask != null ? [mask] : [],
            decoration: InputDecoration(
              counterText: "",
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 14.wsz,
              ),
              errorStyle: const TextStyle(height: 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              fillColor: AppColors.containerInput,
              filled: true,
              contentPadding: EdgeInsets.all(12.hsz),
            ),
          ),
        )
      ],
    );
  }

  Row _headerBS() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Filtros',
            style: TextStyle(
              fontSize: 22.wsz,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            )),
        InkWell(
          onTap: () async {
            await _queryController.refreshList();
            Get.back();
          },
          child: Text('Limpar Filtros',
              style: TextStyle(
                fontSize: 16.wsz,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              )),
        ),
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Text('Fechar',
              style: TextStyle(
                fontSize: 16.wsz,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              )),
        ),
      ],
    );
  }

  validateCardStatus(String? value) {
    if (value == 'Consultas Abertas') {
      return 1;
    } else if (value == 'Consultas em Andamento') {
      return 2;
    } else if (value == 'Consultas Encerradas') {
      return 3;
    } else {
      return 4;
    }
  }
}
