import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';
import 'package:rrr_flutter_new/services/coins_repository.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class CoinsTransactionScreen extends StatefulWidget {
  final String userId;

  const CoinsTransactionScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<CoinsTransactionScreen> createState() => _CoinsTransactionScreenState();
}

class _CoinsTransactionScreenState extends State<CoinsTransactionScreen> {
  late Future<List<CoinTransaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = CoinsRepository.getUserTransactions(
      userId: widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const ResponsiveHeading('Coin Transactions'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1F3A),
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<List<CoinTransaction>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F0FF)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: ResponsiveBody('Error loading transactions'),
              );
            }

            final transactions = snapshot.data ?? [];

            if (transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.white30),
                    const SizedBox(height: 16),
                    const ResponsiveBody(
                      'No transactions yet',
                      color: Colors.white70,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(context),
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionCard(context, transaction);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    CoinTransaction transaction,
  ) {
    final isEarn = transaction.type.toLowerCase() == 'earn';
    final amountColor = isEarn
        ? const Color(0xFF39FF14)
        : const Color(0xFFFF006E);
    final icon = isEarn ? Icons.arrow_downward : Icons.arrow_upward;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(context, mobilePadding: 12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12, width: 1),
        color: Colors.white.withOpacity(0.03),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: amountColor.withOpacity(0.2),
            ),
            child: Icon(icon, color: amountColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveSubheading(transaction.reason, maxLines: 1),
                const SizedBox(height: 4),
                ResponsiveCaption(
                  '${transaction.createdAt.hour.toString().padLeft(2, '0')}:${transaction.createdAt.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ResponsiveSubheading(
                '${isEarn ? '+' : '-'}${transaction.amount}',
                color: amountColor,
              ),
              if (transaction.gameName != null)
                ResponsiveCaption(transaction.gameName ?? ''),
            ],
          ),
        ],
      ),
    );
  }
}
