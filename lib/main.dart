import 'package:flutter/material.dart';
import 'package:islami/Core/Services/LocalStorage.dart';
import 'package:islami/Core/theme/themenavgationbar.dart';
import 'package:islami/UI/Homescreen/Homescreen.dart';
import 'package:islami/UI/OnBorading/onboradingScreen.dart';
import 'package:islami/UI/Quran/Sura.dart';
import 'package:islami/UI/Quran/SuraData.dart';
import 'package:islami/UI/Splash/splashScreen.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
   

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const Splashscreen(),
        '/onboarding': (context) =>  Onboradingscreen(),
        '/home': (context) => const Homescreen(),
         '/sura': (context) {
           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            final suraData = args['suraData'] as SuraData;
            final index = args['index'] as int;
            return Sura(suraData: suraData, index: index);
          },


      },
      theme: themeManger.themeData,
    
    );
  }
}
