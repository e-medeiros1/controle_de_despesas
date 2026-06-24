// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minhas_despesas/models/transaction.dart';
import 'package:minhas_despesas/utils/currency_format.dart';
import 'package:minhas_despesas/utils/currency_input_formatter.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime?, TransactionKind) onSubmit;
  final VoidCallback? onDelete;
  final Transaction? transaction;

  const TransactionForm({
    Key? key,
    required this.onSubmit,
    this.onDelete,
    this.transaction,
  }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  TransactionKind _kind = TransactionKind.expense;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    if (transaction != null) {
      _titleController.text = transaction.title;
      _valueController.text = currencyFormat.format(transaction.value);
      _selectedDate = transaction.date;
      _kind = transaction.kind;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final title = _titleController.text.trim();
    final valueText = _valueController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final value = valueText.isEmpty ? 0.0 : double.parse(valueText) / 100;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate!, _kind);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            right: 18,
            left: 18,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6E2DE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _kind = TransactionKind.expense;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kind == TransactionKind.expense
                              ? const Color(0xFFef6e15)
                              : const Color(0xFFF3F4F6),
                          foregroundColor: _kind == TransactionKind.expense
                              ? Colors.white
                              : const Color(0xFF12332F),
                          elevation: 0,
                        ),
                        child: const Text('Nova despesa'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _kind = TransactionKind.income;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kind == TransactionKind.income
                              ? const Color(0xFF0F766E)
                              : const Color(0xFFF3F4F6),
                          foregroundColor: _kind == TransactionKind.income
                              ? Colors.white
                              : const Color(0xFF12332F),
                          elevation: 0,
                        ),
                        child: const Text('Nova entrada'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isEditing
                    ? (_kind == TransactionKind.expense
                        ? 'Edite a despesa'
                        : 'Edite a entrada')
                    : (_kind == TransactionKind.expense
                        ? 'Registre uma despesa'
                        : 'Registre uma entrada'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF12332F),
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _kind == TransactionKind.expense
                    ? 'Preencha o nome, o valor e a data da despesa.'
                    : 'Preencha o nome, o valor e a data da entrada.',
                style: const TextStyle(
                  color: Color(0xFF6E7E7A),
                  height: 1.15,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 13),
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  labelText: _kind == TransactionKind.expense
                      ? 'Nome do produto'
                      : 'Origem do ganho',
                  labelStyle: const TextStyle(fontSize: 12),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _valueController,
                style: const TextStyle(fontSize: 13),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  labelText: _kind == TransactionKind.expense
                      ? 'Valor da despesa'
                      : 'Valor da entrada',
                  labelStyle: const TextStyle(fontSize: 12),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE1E7E5)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF0F766E),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Nenhuma data selecionada'
                            : 'Data selecionada: ${DateFormat('MMM d, y').format(_selectedDate!)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF12332F),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _showDatePicker,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text(
                        'Selecionar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    isEditing ? 'Salvar alterações' : 'Adicionar',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              if (isEditing && widget.onDelete != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: widget.onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB91C1C),
                      side: const BorderSide(color: Color(0xFFB91C1C)),
                    ),
                    child: const Text('Excluir'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
