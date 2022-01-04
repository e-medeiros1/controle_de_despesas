// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';
import './components/transaction_form.dart';

class Despesas extends StatefulWidget {
  const Despesas({Key? key}) : super(key: key);

  @override
  _DespesasState createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
  final _transaction = [
    Transaction(
      id: 't1',
      title: 'Notebook AVELL C62 MOB',
      value: 10935.20,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Monitor LG 29\'',
      value: 1360.10,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Headset Logitech',
      value: 1115.80,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Suporte para celular',
      value: 22.80,
      date: DateTime.now(),
    ),
  ];

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transaction.add(newTransaction);
    });
  }

  _openTransactionFormModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(null!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
        title: Text('Despesas pessoais'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
            TransactionList(transactions: _transaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
