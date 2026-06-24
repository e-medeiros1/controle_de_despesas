import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/transaction_item.dart';
import 'package:minhas_despesas/models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key? key,
    required this.transactions,
    required this.onEdit,
  }) : super(key: key);

  final List<Transaction> transactions;
  final void Function(Transaction) onEdit;

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: constraints.maxHeight * 0.08,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * (isLandscape ? 0.34 : 0.28),
                        child: Image.asset(
                          'assets/images/nothing-found.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nenhuma transação cadastrada!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF12332F),
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Toque no botão + para adicionar sua primeira despesa e começar a acompanhar seus gastos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF6E7E7A),
                          height: 1.2,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[transactions.length - 1 - index];
              return TransactionItem(
                key: ValueKey(tr.id),
                tr: tr,
                onEdit: () => onEdit(tr),
              );
            },
          );
  }
}
