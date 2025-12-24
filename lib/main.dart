import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'theme/app_theme.dart';
import 'models/qumsnatat_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadMezmurData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mezmur App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
