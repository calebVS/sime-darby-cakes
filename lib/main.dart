import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CityTalkApp());
}

class CityTalkApp extends StatelessWidget {
  const CityTalkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityTalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2962FF),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainLayout(),
    );
  }
}