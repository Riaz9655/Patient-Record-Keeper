import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:patient_record_generator/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Drawer Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Archivo_Narrow',
        primarySwatch: Colors.blue,
        appBarTheme:AppBarTheme(
          foregroundColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 69, 95, 83),),
      ),
      home: SplashScreen(),
    );
  }
}

