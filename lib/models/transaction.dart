import 'dart:convert';

enum TransactionKind {
  expense,
  income,
}

String transactionKindToString(TransactionKind kind) {
  switch (kind) {
    case TransactionKind.income:
      return 'income';
    case TransactionKind.expense:
      return 'expense';
  }
}

class Transaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;
  final TransactionKind kind;
 
  const Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
    this.kind = TransactionKind.expense,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'date': date.toIso8601String(),
      'kind': transactionKindToString(kind),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      value: (json['value'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      kind: (json['kind'] as String?) == 'income'
          ? TransactionKind.income
          : TransactionKind.expense,
    );
  }

  static String encodeList(List<Transaction> transactions) {
    return json.encode(transactions.map((tr) => tr.toJson()).toList());
  }

  static List<Transaction> decodeList(String encoded) {
    final decoded = json.decode(encoded) as List<dynamic>;
    return decoded
        .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
