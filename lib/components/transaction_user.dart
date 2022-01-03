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
      title: 'Novo tênis de corrida',
      value: 300.10,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Novo celular',
      value: 999.80,
      date: DateTime.now(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionList(transactions: _transaction),
        TransactionForm(
          onSubmit: (title, value) {},
        ),
      ],
    );
  }
}
