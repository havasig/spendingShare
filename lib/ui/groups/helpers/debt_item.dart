import 'package:flutter/material.dart';

class DebtItem extends StatelessWidget {
  const DebtItem({
    Key? key,
    required this.onTap,
    required this.from,
    required this.to,
    required this.value,
    required this.currency,
  }) : super(key: key);

  final VoidCallback onTap;
  final String from;
  final String to;
  final String value;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
