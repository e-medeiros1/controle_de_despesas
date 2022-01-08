import 'package:flutter/material.dart';

class ChatBar extends StatelessWidget {
  const ChatBar({
    Key? key,
    required this.label,
    required this.value,
    required this.percentage,
  }) : super(key: key);

  final String label;
  final double value;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('\$${value.toStringAsFixed(2)}'),
        const SizedBox(height: 5),
        Container(
          height: 60,
          width: 10,
          child: null,
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
