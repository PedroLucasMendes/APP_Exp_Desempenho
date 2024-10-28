// ignore_for_file: prefer_const_constructors

import 'package:echologger_exp/view/homeView.dart';
import 'package:flutter/material.dart';

void main() async {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
