import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/transaction_form.dart';
import 'package:minhas_despesas/components/transaction_list.dart';
import 'package:minhas_despesas/models/transaction.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser({Key? key}) : super(key: key);

  @override
  _TransactionUserState createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TransactionForm(_addTransaction),
        TransactionList(transactions: _transaction),
      ],
    );
  }
}
