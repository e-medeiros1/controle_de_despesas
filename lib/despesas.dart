// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_despesas/components/transaction_form.dart';
import 'package:minhas_despesas/components/transaction_list.dart';
import 'package:minhas_despesas/models/transaction.dart';
import 'package:minhas_despesas/utils/currency_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TransactionFilterPreset {
  all,
  income,
  expense,
  customRange,
}

class Despesas extends StatefulWidget {
  const Despesas({Key? key}) : super(key: key);

  @override
  _DespesasState createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
  static const String _storageKey = 'transactions_v1';
  final List<Transaction> _transaction = [];
  TransactionFilterPreset _activeFilter = TransactionFilterPreset.all;
  DateTimeRange? _customRange;
  String? _editingTransactionId;
  int? _editingTransactionIndex;

  DateTime _startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  List<Transaction> get _filteredTransactions {
    switch (_activeFilter) {
      case TransactionFilterPreset.all:
        return List<Transaction>.from(_transaction);
      case TransactionFilterPreset.income:
        return _transaction.where((tr) => tr.kind == TransactionKind.income).toList();
      case TransactionFilterPreset.expense:
        return _transaction.where((tr) => tr.kind == TransactionKind.expense).toList();
      case TransactionFilterPreset.customRange:
        if (_customRange == null) {
          return List<Transaction>.from(_transaction);
        }
        final start = _startOfDay(_customRange!.start);
        final end = _endOfDay(_customRange!.end);
        return _transaction
            .where((tr) => !tr.date.isBefore(start) && !tr.date.isAfter(end))
            .toList();
    }
  }

  double get _filteredExpenseTotal {
    return _filteredTransactions
        .where((tr) => tr.kind == TransactionKind.expense)
        .fold(0.0, (sum, tr) => sum + tr.value);
  }

  double get _filteredIncomeTotal {
    return _filteredTransactions
        .where((tr) => tr.kind == TransactionKind.income)
        .fold(0.0, (sum, tr) => sum + tr.value);
  }

  double get _filteredBalance {
    return _filteredIncomeTotal - _filteredExpenseTotal;
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_storageKey);
    if (encoded == null || encoded.isEmpty) {
      return;
    }

    final loaded = Transaction.decodeList(encoded);
    if (!mounted) {
      return;
    }

    setState(() {
      _transaction
        ..clear()
        ..addAll(loaded);
    });
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, Transaction.encodeList(_transaction));
  }

  Future<void> _selectCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      initialDateRange: _customRange,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _customRange = picked;
      _activeFilter = TransactionFilterPreset.customRange;
    });
  }

  void _setPreset(TransactionFilterPreset preset) {
    setState(() {
      _activeFilter = preset;
    });
  }

  String _filterLabel() {
    switch (_activeFilter) {
      case TransactionFilterPreset.all:
        return 'Todos os registros';
      case TransactionFilterPreset.income:
        return 'Entradas';
      case TransactionFilterPreset.expense:
        return 'Saídas';
      case TransactionFilterPreset.customRange:
        if (_customRange == null) {
          return 'Intervalo personalizado';
        }
        final start = DateFormat('dd/MM').format(_customRange!.start);
        final end = DateFormat('dd/MM').format(_customRange!.end);
        return '$start - $end';
    }
  }

  Future<void> _openTransactionFormModal({
    Transaction? transaction,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return TransactionForm(
          transaction: transaction,
          onSubmit: _saveTransactionFromForm,
          onDelete: transaction == null
              ? null
              : () {
                  _deleteTransaction(transaction.id);
                  Navigator.of(context).pop();
                },
        );
      },
    );
  }

  void _saveTransactionFromForm(
    String title,
    double value,
    DateTime? date,
    TransactionKind kind,
  ) {
    if (date == null) {
      return;
    }

    final updatedTransaction = Transaction(
      id: _editingTransactionId ?? Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
      kind: kind,
    );

    setState(() {
      if (_editingTransactionIndex == null) {
        _transaction.add(updatedTransaction);
      } else {
        _transaction[_editingTransactionIndex!] = updatedTransaction;
      }
    });

    _saveTransactions();
    _clearEditingState();
    Navigator.of(context).pop();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transaction.removeWhere((tr) => tr.id == id);
    });

    _saveTransactions();
  }

  void _clearEditingState() {
    _editingTransactionId = null;
    _editingTransactionIndex = null;
  }

  void _editTransaction(Transaction transaction) {
    _editingTransactionId = transaction.id;
    _editingTransactionIndex = _transaction.indexWhere((tr) => tr.id == transaction.id);
    _openTransactionFormModal(transaction: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 20,
      centerTitle: false,
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFEAF5F3),
                Color(0xFFF4F7FB),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color(0xFF0F766E),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F766E).withOpacity(0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Acompanhe suas finanças',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Colors.white,
                                      fontSize: 15,
                                      height: 1.1,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Adicione valores, compare e encontre padrões rapidamente.',
                                style: TextStyle(
                                  color: Color(0xFFE8FFFC),
                                  height: 1.2,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Todos'),
                        selected: _activeFilter == TransactionFilterPreset.all,
                        onSelected: (_) => _setPreset(TransactionFilterPreset.all),
                      ),
                      ChoiceChip(
                        label: const Text('Entradas'),
                        selected: _activeFilter == TransactionFilterPreset.income,
                        onSelected: (_) => _setPreset(TransactionFilterPreset.income),
                      ),
                      ChoiceChip(
                        label: const Text('Saídas'),
                        selected: _activeFilter == TransactionFilterPreset.expense,
                        onSelected: (_) => _setPreset(TransactionFilterPreset.expense),
                      ),
                      ActionChip(
                        label: Text(
                          _activeFilter == TransactionFilterPreset.customRange &&
                                  _customRange != null
                              ? 'Período: ${_filterLabel()}'
                              : 'Intervalo',
                        ),
                        onPressed: _selectCustomRange,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
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
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF5F3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.payments_outlined,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Saldo do filtro',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6E7E7A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormat.format(_filteredBalance),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF12332F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Entradas: ${currencyFormat.format(_filteredIncomeTotal)}  Saídas: ${currencyFormat.format(_filteredExpenseTotal)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6E7E7A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: availableHeight * (isLandscape ? 0.95 : 0.72),
                  child: TransactionList(
                    transactions: _filteredTransactions,
                    onEdit: _editTransaction,
                  ),
                ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _clearEditingState();
            _openTransactionFormModal();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
