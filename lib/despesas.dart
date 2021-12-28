// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:minhas_despesas/models/transaction.dart';

class Despesas extends StatefulWidget {
  const Despesas({Key? key}) : super(key: key);

  @override
  _DespesasState createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
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
      value: 1200,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Despesas pessoais')),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            //Criando objetos visuais através do map
            Column(
              children: [
                ..._transaction.map((tr) {
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                          child: Text(
                            tr.value.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(tr.date.toString(),
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ],
            )
          ],
        ));
  }
}
