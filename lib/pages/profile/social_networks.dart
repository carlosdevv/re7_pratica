import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/pages/profile/widgets/table_social_network.dart';
import 'package:re7_pratica/ui_control.dart';

class SocialNetworksPage extends StatefulWidget {
  const SocialNetworksPage({Key? key}) : super(key: key);

  @override
  State<SocialNetworksPage> createState() => _SocialNetworksPageState();
}

class _SocialNetworksPageState extends State<SocialNetworksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0.wsz, 30.0.wsz, 16.0.wsz, 20.0.wsz),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              SizedBox(height: 60.hsz),
              Text(
                'Lista de Consultores',
                style: TextStyle(
                  fontSize: 18.wsz,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 10.hsz),
              _columnsTable(),
              const Expanded(child: TableSocialNetwork()),
            ],
          ),
        ),
      ),
    );
  }

  Stack _header() {
    return Stack(
      children: [
        InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 26.wsz,
            )),
        Center(
            child: Text(
          'Redes Sociais',
          style: TextStyle(fontSize: 25.wsz),
        )),
      ],
    );
  }

  Container _columnsTable() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.wsz, 16.wsz, 16.wsz, 16.wsz),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Nome',
            style: TextStyle(
              fontSize: 15.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          Text(
            'Redes',
            style: TextStyle(
              fontSize: 15.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
