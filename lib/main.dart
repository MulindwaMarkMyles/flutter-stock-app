import 'package:flutter/material.dart';
import 'package:stockapp/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TheStockApp());
}

class TheStockApp extends StatelessWidget {
  const TheStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
    );
  }
}
