// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/colors.dart';

import 'despesas.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas despesas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
      home: Despesas(),
    );
  }
}
