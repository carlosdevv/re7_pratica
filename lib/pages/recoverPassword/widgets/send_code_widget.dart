import 'package:flutter/material.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/recover_password_controller.dart';
import 'package:re7_pratica/ui_control.dart';

class SendCodeWidget extends StatelessWidget {
  final RecoverPasswordController controller;
  const SendCodeWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Esqueceu sua senha?',
            style: TextStyle(
              fontSize: 25.wsz,
              fontWeight: FontWeight.w600,
            )),
        SizedBox(height: 10.hsz),
        Text('Insira o usuário associado a\nsua conta.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text100,
              fontSize: 14.wsz,
              fontWeight: FontWeight.w400,
            )),
        SizedBox(height: 36.hsz),
        Container(
          padding: EdgeInsets.all(30.wsz),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.wsz),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.07),
                offset: Offset(0, 4.wsz),
                blurRadius: 10.wsz,
              ),
            ],
          ),
          child: Column(
            children: [
              _emailInput(),
              SizedBox(height: 40.hsz),
              _sendCode(),
            ],
          ),
        )
      ],
    );
  }

  Row _sendCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Enviar',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 18.wsz,
              fontWeight: FontWeight.w600),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.handleSendCode();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.wsz,
              vertical: 13.wsz,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 24.wsz,
            ),
          ),
        )
      ],
    );
  }

  Column _emailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.wsz),
          child: Text(
            'Usuário',
            style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 16.wsz),
          ),
        ),
        SizedBox(height: 7.hsz),
        TextFormField(
          controller: controller.username,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Digite seu login',
            hintStyle: const TextStyle(
                color: AppColors.text100, fontWeight: FontWeight.w600),
            errorStyle: const TextStyle(height: 0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            fillColor: AppColors.containerInput,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.wsz, horizontal: 18.wsz),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ],
    );
  }
}
