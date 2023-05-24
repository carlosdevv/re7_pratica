import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/recover_password_controller.dart';
import 'package:re7_pratica/ui_control.dart';

class ValidateCodeWidget extends StatefulWidget {
  final RecoverPasswordController controller;
  const ValidateCodeWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ValidateCodeWidget> createState() => _ValidateCodeWidgetState();
}

class _ValidateCodeWidgetState extends State<ValidateCodeWidget> {
  final _controller = Get.put(RecoverPasswordController());
  Duration duration = const Duration(seconds: 300);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final seconds = duration.inSeconds - 1;
        if (seconds < 0) {
          stopTimer();
          _controller.timeExpired.value = true;
        } else {
          duration = Duration(seconds: seconds);
        }
      });
    });
  }

  void resetTimer() {
    setState(() => duration = const Duration(seconds: 300));
    startTimer();
  }

  void stopTimer() {
    setState(() => timer?.cancel());
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Verifique seu código',
            style: TextStyle(
              fontSize: 25.wsz,
              fontWeight: FontWeight.w600,
            )),
        SizedBox(height: 10.hsz),
        Text(
            'Insira o código de verificação que enviamos para\no seu telefone.',
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
              Form(
                  key: widget.controller.passwordCodeKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _codeInput(
                        context,
                        widget.controller.pin1,
                        first: true,
                        last: false,
                      ),
                      _codeInput(
                        context,
                        widget.controller.pin2,
                        first: false,
                        last: false,
                      ),
                      _codeInput(
                        context,
                        widget.controller.pin3,
                        first: false,
                        last: false,
                      ),
                      _codeInput(
                        context,
                        widget.controller.pin4,
                        first: false,
                        last: false,
                      ),
                      _codeInput(
                        context,
                        widget.controller.pin5,
                        first: false,
                        last: true,
                      ),
                    ],
                  )),
              SizedBox(height: 36.wsz),
              _verifyCode(),
            ],
          ),
        ),
        SizedBox(height: 24.wsz),
        buildTime(),
        SizedBox(height: 24.wsz),
        timer!.isActive
            ? const Text(
                'Não recebeu seu código?',
                style: TextStyle(
                  color: AppColors.text100,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Container(),
        timer!.isActive ? SizedBox(height: 12.wsz) : const SizedBox(),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            widget.controller.handleResendPassword();
            widget.controller.timeExpired.value = false;
            resetTimer();
          },
          child: Text(
            'Reenviar Código',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18.wsz,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTime() {
    String twoDigits(int digit) => digit.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$minutes:$seconds',
      style: TextStyle(
          color: AppColors.primary,
          fontSize: 16.wsz,
          fontWeight: FontWeight.w700),
    );
  }

  Row _verifyCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Verficar Código',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 18.wsz,
              fontWeight: FontWeight.w600),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            widget.controller.handleVerifyCode();
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

  Container _codeInput(BuildContext context, TextEditingController controller,
      {bool? first, last}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8.wsz, vertical: 5.wsz),
      height: 50.wsz,
      width: 50.wsz,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.wsz),
        border: Border.all(
          color: AppColors.primary,
        ),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            fontSize: 22.wsz),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
