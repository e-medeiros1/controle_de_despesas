// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:minhas_despesas/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(
      {Key? key, required this.transactions, required this.onRemove})
      : super(key: key);

  //Lista do tipo Transaction que guarda informações de _transacion dentro da variável transactions
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 620,
      child: transactions.isEmpty
          ? Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Nenhuma transação cadastrada!',
                  // 'Não há nada por aqui ¯\\_(ツ)_/¯',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 50),
                SizedBox(
                  height: 300,
                  child: Image.asset(
                    'assets/images/nothing-found.png',
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
                  shadowColor: Colors.tealAccent,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: FittedBox(
                          child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          '\$${tr.value.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      )),
                      radius: 30,
                    ),
                    title: Text(
                      tr.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(DateFormat('MMM d, y').format(tr.date),
                        style: TextStyle(color: Colors.grey)),
                    trailing: IconButton(
                      onPressed: () {
                        return onRemove(tr.id);
                      },
                      icon: Icon(Icons.delete_outline),
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
