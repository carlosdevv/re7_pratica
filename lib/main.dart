import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/models/user_secure_storage.dart';
import 'package:re7_pratica/routes/app_pages.dart';
import 'package:re7_pratica/routes/app_routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'ui_control.dart';

Future<void> main() async {
  Animate.restartOnHotReload = true;
  await dotenv.load(fileName: Environment.fileName);
  await GetStorage.init();
  await Permission.microphone.request();

  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
    avAudioSessionCategoryOptions:
        AVAudioSessionCategoryOptions.allowBluetooth |
            AVAudioSessionCategoryOptions.defaultToSpeaker,
    avAudioSessionMode: AVAudioSessionMode.spokenAudio,
    avAudioSessionRouteSharingPolicy:
        AVAudioSessionRouteSharingPolicy.defaultPolicy,
    avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    androidAudioAttributes: const AndroidAudioAttributes(
      contentType: AndroidAudioContentType.speech,
      flags: AndroidAudioFlags.none,
      usage: AndroidAudioUsage.voiceCommunication,
    ),
    androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    androidWillPauseWhenDucked: true,
  ));

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UIControl.changeEmulatorSize = const Size(428, 926);
    UIControl.useWsz();
    UIControl.changeNavigatorKey = Get.key;

    return GetMaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        minWidth: 350,
        maxWidth: 6000,
        breakpoints: const [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
        ],
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      title: 'Re7 Prática',
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
      initialRoute: UserSecureStorage.getUser() == null
          ? AppPages.initial
          : Routes.dashboard,
      getPages: AppPages.routes,
      theme: ThemeData(
        dividerColor: Colors.transparent,
      ),
    );
  }
}
