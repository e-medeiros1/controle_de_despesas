// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minhas_despesas/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.transactions})
      : super(key: key);

  //Lista do tipo Transaction que guarda informações de _transacion dentro da variável transactions
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: transactions.isEmpty
          ? Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Não há nada por aqui ¯\\_(ツ)_/¯',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                final tr = transactions[index];
                return Card(
                  elevation: 7,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.cyanAccent.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                            child: Text(
                          '\$${tr.value}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                    title: Text(
                      tr.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(DateFormat('MMM d, y').format(tr.date),
                        style: TextStyle(color: Colors.grey)),
                  ),
                );
              },
            ),
    );
  }
}
