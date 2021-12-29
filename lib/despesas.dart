// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:minhas_despesas/components/transaction_list.dart';

import 'package:minhas_despesas/models/transaction.dart';

class Despesas extends StatefulWidget {
  const Despesas({Key? key}) : super(key: key);

  @override
  _DespesasState createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  //Alimntando a classe Transaction 
  final _transaction = [
    Transaction(
      id: 't1',
      title: 'Novo tênis de corrida',
      value: 300.10,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Novo celular',
      value: 999.00,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          title: Center(child: Text('Despesas pessoais')),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Center(
                child: Card(
                  child: Text(
                    'Gráfico',
                    style: TextStyle(fontSize: 20),
                  ),
                  elevation: 7,
                ),
              ),
            ),
            //Chamando a classe e passando o parâmetro nomeado
            TransactionList(transactions: _transaction),
            Card(
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration:
                          InputDecoration(labelText: 'Nome do produto:'),
                    ),
                    TextField(
                      controller: valueController,
                      decoration: InputDecoration(labelText: 'Valor (R\$):'),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(360, 10, 10, 0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple)),
                          onPressed: () {
                            print(titleController.text);
                            print(valueController.text);
                          },
                          child: Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
