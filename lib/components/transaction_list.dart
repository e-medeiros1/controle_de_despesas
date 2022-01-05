// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/colors.dart';
import 'package:minhas_despesas/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.transactions})
      : super(key: key);

  //Lista do tipo Transaction que guarda informações de _transacion dentro da variável transactions
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          final tr = transactions[index];
          return Card(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Palette.kToDark),
                  ),
                  //Valor da compra
                  child: Text('R\$ ${tr.value.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Palette.kToDark)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Título da compra
                    Text(tr.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    //Data da compra
                    Text(DateFormat('MMM d, y').format(tr.date),
                        style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
