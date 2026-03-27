import 'package:flutter/material.dart';

class DailyBonusDialog extends StatelessWidget {
  const DailyBonusDialog({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Daily Bonus'),
      content: Text('You earned $amount coins for opening the app today.'),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Claim'),
        ),
      ],
    );
  }
}
