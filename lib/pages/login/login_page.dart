import 'package:flutter/material.dart';
import 'package:re7_pratica/constants/app_images.dart';
import 'package:re7_pratica/pages/login/widgets/form_login_widget.dart';
import 'package:re7_pratica/ui_control.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _imageLayout(context),
          Padding(
            padding: EdgeInsets.only(left: 50.wsz, right: 50.wsz),
            child: SizedBox(
              height: 72.wsz,
              child: Image.asset(AppImages.logoApp),
            ),
          ),
          SizedBox(height: 16.hsz),
          Text('Faça seu Login',
              style: TextStyle(fontSize: 25.wsz, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.hsz),
          Text('Insira suas informações para acessar o sistema.',
              style: TextStyle(
                  fontSize: 14.wsz,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffa9a9a9))),
          SizedBox(height: 40.hsz),
          const FormLoginWidget()
        ],
      ),
    );
  }

  Stack _imageLayout(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300.hsz,
            child: Image.asset(
              AppImages.backgroundHome,
              fit: BoxFit.cover,
            )),
        Positioned(
          bottom: -5.hsz,
          child: Container(
            height: 20.wsz,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
          ),
        ),
      ],
    );
  }
}
