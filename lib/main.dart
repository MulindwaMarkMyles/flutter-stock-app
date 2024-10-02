import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stockapp/login.dart';
import 'dart:io';
import 'package:stockapp/stock.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = Directory.current.path;
  Hive.init(path);

  // Register the Stock adapter
  Hive.registerAdapter(StockAdapter());
  


  // Open a Hive box for stocks
  await Hive.openBox<Stock>('thestocks');
  

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
