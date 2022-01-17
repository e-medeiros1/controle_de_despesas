import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/transaction_item.dart';
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
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  SizedBox(
                      height:
                          constraints.maxHeight * (isLandscape ? 0.10 : 0.05)),
                  SizedBox(
                    height: constraints.maxHeight * 0.10,
                    child: Text(
                      'Nenhuma transação cadastrada!',
                      // 'Não há nada por aqui ¯\\_(ツ)_/¯',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                      height:
                          constraints.maxHeight * (isLandscape ? 0.10 : 0.05)),
                  SizedBox(
                    height: constraints.maxHeight * 0.49,
                    child: Image.asset(
                      'assets/images/nothing-found.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return TransactionItem(
                key: GlobalObjectKey(tr),
                tr: tr,
                onRemove: onRemove,
              );
            },
          );
  }
}
