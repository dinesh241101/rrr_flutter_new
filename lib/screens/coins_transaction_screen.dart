import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';

class CoinsTransactionScreen extends StatefulWidget {
  final String userId;

  const CoinsTransactionScreen({super.key, required this.userId});

  @override
  State<CoinsTransactionScreen> createState() => _CoinsTransactionScreenState();
}

class _CoinsTransactionScreenState extends State<CoinsTransactionScreen> {
  String _activeTab = 'All';

  final List<Map<String, dynamic>> _fallbackTransactions = [
    {
      'reason': 'Daily Login Bonus',
      'type': 'earn',
      'amount': 50,
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'reason': 'Mega Quiz League Entry Fee',
      'type': 'spend',
      'amount': 200,
      'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'reason': 'Science Quiz Won',
      'type': 'earn',
      'amount': 120,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'reason': 'General Knowledge Quiz Won',
      'type': 'earn',
      'amount': 100,
      'createdAt': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    },
    {
      'reason': 'Car Racing Battle Entry Fee',
      'type': 'spend',
      'amount': 30,
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Read from WalletProvider
    final wallet = context.watch<WalletProvider>();
    
    // Convert WalletProvider transactions to list maps if any exist
    List<Map<String, dynamic>> listData = [];
    
    if (wallet.transactions.isNotEmpty) {
      for (var tx in wallet.transactions) {
        listData.add({
          'reason': tx.source,
          'type': tx.isCredit ? 'earn' : 'spend',
          'amount': tx.amount,
          'createdAt': tx.timestamp,
        });
      }
    } else {
      listData = _fallbackTransactions;
    }

    // Filter listData based on tab
    final filteredData = listData.where((tx) {
      if (_activeTab == 'Credit') return tx['type'] == 'earn';
      if (_activeTab == 'Debit') return tx['type'] == 'spend';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white70),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter toggled')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs Row (All, Credit, Debit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: ['All', 'Credit', 'Debit'].map((tab) {
                    final isSelected = tab == _activeTab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeTab = tab),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Transactions list
            Expanded(
              child: filteredData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_rounded, size: 60, color: Colors.white.withOpacity(0.2)),
                          const SizedBox(height: 12),
                          const Text(
                            'No transactions found',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final tx = filteredData[index];
                        final isEarn = tx['type'] == 'earn';
                        final amount = tx['amount'] as int;
                        final reason = tx['reason'] as String;
                        final date = tx['createdAt'] as DateTime;

                        // Date formatter
                        final dateStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                        final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              // Icon Indicator Left
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (isEarn ? AppTheme.successColor : AppTheme.errorColor).withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isEarn ? Icons.south_west_rounded : Icons.north_east_rounded,
                                  color: isEarn ? AppTheme.successColor : AppTheme.errorColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Text details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reason,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$dateStr • $timeStr',
                                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),

                              // Amount Right
                              Text(
                                '${isEarn ? '+' : '-'}$amount',
                                style: TextStyle(
                                  color: isEarn ? AppTheme.successColor : AppTheme.errorColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
