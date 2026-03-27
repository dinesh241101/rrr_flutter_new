import 'package:flutter/material.dart';

class CoinBalanceChip extends StatelessWidget {
  const CoinBalanceChip({super.key, required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, size: 18, color: Colors.amber),
          const SizedBox(width: 6),
          Text(
            '$coins',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
