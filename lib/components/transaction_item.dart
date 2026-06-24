// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_despesas/models/transaction.dart';
import 'package:minhas_despesas/utils/currency_format.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.tr,
    required this.onEdit,
  }) : super(key: key);

  final Transaction tr;
  final VoidCallback onEdit;

  void _handleEdit() {
    // Adia a abertura do sheet para o próximo frame, permitindo que o
    // feedback visual do toque conclua antes da animação do modal.
    WidgetsBinding.instance.addPostFrameCallback((_) => onEdit());
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 500;
    final isIncome = tr.kind == TransactionKind.income;
    final accentColor = isIncome ? const Color(0xFF0F766E) : const Color(0xFFB91C1C);
    final backgroundTone = isIncome ? const Color(0xFFEAF5F3) : const Color(0xFFFDECEC);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          width: 90,
          height: 56,
          decoration: BoxDecoration(
            color: backgroundTone,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              currencyFormat.format(tr.value),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontSize: 13,
              ),
            ),
          ),
        ),
        title: Text(
          tr.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF12332F),
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isIncome ? 'Entrada' : 'Despesa',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMM d, y').format(tr.date),
                style: const TextStyle(
                  color: Color(0xFF6E7E7A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        trailing: isWide
            ? TextButton.icon(
                onPressed: _handleEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              )
            : IconButton(
                onPressed: _handleEdit,
                icon: const Icon(Icons.edit_outlined),
                color: const Color(0xFF0F766E),
              ),
      ),
    );
  }
}
