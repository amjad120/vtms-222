import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/HomePage.dart';
import 'package:flutter_application_1/ReportPage.dart';
import 'package:flutter_application_1/Settings.dart';
import 'package:flutter_application_1/action/AddVehicle.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/auth/signup.dart';
import 'package:provider/provider.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCe6FOXAiEirg4HYOHJdhN_V_e-xtcOHZA", 
      appId: "1:643393523819:android:a3857c74dc1cb1ae58e12e", 
      messagingSenderId: "643393523819", 
      projectId: "vtms-e3714"
    )
  );
  runApp(
    ChangeNotifierProvider( // <-- تغليف التطبيق بـ Provider
      create: (context) => ThemeNotifier(),
      child: const myapp(),
    ),
  );
}

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark; // أضف هذه الخاصية

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class myapp extends StatefulWidget {
  const myapp({super.key});

  @override
  State<myapp> createState() => _myappStates();
}

class _myappStates extends State<myapp> {
  @override
  void initState() {
    FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>( // <-- استخدام Consumer لتتبع تغييرات الثيم
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(), // الثيم الفاتح
          darkTheme: ThemeData.dark(), // الثيم المظلم
          themeMode: themeNotifier.themeMode, // تحديد الثيم الحالي
          home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) 
              ? Login() 
              : Homepage(),
          routes: {
            "signup": (context) => Signup(),
            "login": (context) => Login(),
            "homepage": (context) => Homepage(),
            "addVehicle": (context) => AddVehicle(),
            "settings": (context) => Settings(),
            "reportpage":(context)=> ReportPage(),
          },
        );
      },
    );
  }
}