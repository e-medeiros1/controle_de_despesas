// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  final void Function(String, double) _onSubmit;

  TransactionForm(this._onSubmit, {Key? key}) : super(key: key);

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      return;
    }

    _onSubmit(title, value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onSubmitted: (_) => _submitForm,
              decoration: InputDecoration(labelText: 'Nome do produto:'),
            ),
            TextField(
              controller: valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm,
              decoration: InputDecoration(labelText: 'Valor (R\$):'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Nova Transação',
                    style: TextStyle(color: Colors.purple, fontSize: 17),
                  ),
                  onPressed: _submitForm(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
