// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/transaction_user.dart';

class Despesas extends StatefulWidget {
  const Despesas({Key? key}) : super(key: key);

  @override
  _DespesasState createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          title: Center(child: Text('Despesas pessoais')),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Center(
                child: Card(
                  child: Text(
                    'Gráfico',
                    style: TextStyle(fontSize: 20),
                  ),
                  elevation: 7,
                ),
              ),
            ),
            TransactionUser(),
          ],
        ));
  }
}
