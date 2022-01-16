import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_despesas/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.tr,
    required this.onRemove,
  }) : super(key: key);

  final Transaction tr;
  final void Function(String p1) onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.tealAccent,
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 7,
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )),
          radius: 30,
        ),
        title: Text(
          tr.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat('MMM d, y').format(tr.date),
            style: const TextStyle(color: Colors.grey)),
        trailing: MediaQuery.of(context).size.width > 500
            ? TextButton.icon(
                onPressed: () {
                  return onRemove(tr.id);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                ),
                label: Text(
                  'Excluir',
                  style: TextStyle(color: Colors.teal.shade700),
                ),
              )
            : IconButton(
                onPressed: () {
                  return onRemove(tr.id);
                },
                icon: const Icon(Icons.delete_outline),
                color: Colors.black,
              ),
      ),
    );
  }
}
