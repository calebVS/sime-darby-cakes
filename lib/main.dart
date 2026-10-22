import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'main_layout.dart'; // Adjust path to your main layout file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const CityTalkApp(),
    ),
  );
}

class CityTalkApp extends StatelessWidget {
  const CityTalkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to global app state
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'citytalk',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode, // Swaps between Light and Dark globally
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F7F5),
        primaryColor: const Color(0xFF2962FF),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF2962FF),
      ),
      home: const MainLayout(),
    );
  }
}