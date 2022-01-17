import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_despesas/models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.tr,
    required this.onRemove,
  }) : super(key: key);

  final Transaction tr;
  final void Function(String p1) onRemove;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  dynamic colors = [
    Colors.teal[50],
    Colors.teal[100],
    Colors.teal[200],
    Colors.teal[300],
    Colors.teal[400],
    Colors.tealAccent[100],
    Colors.tealAccent[400],
    Colors.tealAccent[700]
  ];

  Color? _backgroundColor;

  @override
  void initState() {
    super.initState();

    int i = Random().nextInt(8);
    _backgroundColor = colors[i];
  }

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
          backgroundColor: _backgroundColor,
          child: FittedBox(
              child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              '\$${widget.tr.value.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )),
          radius: 30,
        ),
        title: Text(
          widget.tr.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat('MMM d, y').format(widget.tr.date),
            style: const TextStyle(color: Colors.grey)),
        trailing: MediaQuery.of(context).size.width > 500
            ? TextButton.icon(
                onPressed: () {
                  return widget.onRemove(widget.tr.id);
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
                  return widget.onRemove(widget.tr.id);
                },
                icon: const Icon(Icons.delete_outline),
                color: Colors.black,
              ),
      ),
    );
  }
}
