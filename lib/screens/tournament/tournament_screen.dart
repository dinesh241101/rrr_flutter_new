import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  String _activeTab = 'Upcoming';

  final List<Map<String, dynamic>> _upcomingTournaments = [
    {
      'id': 't1',
      'title': 'MEGA QUIZ LEAGUE',
      'prizePool': 5000,
      'entryFee': 200,
      'playersRegistered': 250,
      'playersMax': 500,
      'date': '12 May 2026',
      'time': '05:00 PM',
    },
    {
      'id': 't2',
      'title': 'BATTLE OF CHAMPIONS',
      'prizePool': 10000,
      'entryFee': 500,
      'playersRegistered': 120,
      'playersMax': 300,
      'date': '15 May 2026',
      'time': '08:00 PM',
    },
    {
      'id': 't3',
      'title': 'WEEKEND QUIZ CUP',
      'prizePool': 2500,
      'entryFee': 50,
      'playersRegistered': 300,
      'playersMax': 500,
      'date': '18 May 2026',
      'time': '09:00 PM',
    },
  ];

  final List<Map<String, dynamic>> _liveTournaments = [
    {
      'id': 't4',
      'title': 'MIDWEEK SPEEDRUN',
      'prizePool': 3000,
      'entryFee': 100,
      'playersRegistered': 180,
      'playersMax': 200,
      'date': 'Today',
      'time': 'Ongoing',
    },
  ];

  final List<Map<String, dynamic>> _completedTournaments = [
    {
      'id': 't5',
      'title': 'CHAMPIONS LEAGUE V1',
      'prizePool': 8000,
      'entryFee': 300,
      'playersRegistered': 400,
      'playersMax': 400,
      'date': '25 May 2026',
      'time': 'Finished',
    },
  ];

  void _joinTournament(Map<String, dynamic> tournament) {
    final wallet = context.read<WalletProvider>();
    final entryFee = tournament['entryFee'] as int;

    if (wallet.coins < entryFee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins to join this tournament!')),
      );
      return;
    }

    wallet.spendCoins(amount: entryFee, source: 'Tournament Entry: ${tournament['title']}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined ${tournament['title']}! - $entryFee coins'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activeList = _activeTab == 'Upcoming'
        ? _upcomingTournaments
        : (_activeTab == 'Live' ? _liveTournaments : _completedTournaments);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs Bar (Upcoming, Live, Completed)
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
                  children: ['Upcoming', 'Live', 'Completed'].map((tab) {
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

            // Tournament list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: activeList.length,
                itemBuilder: (context, index) {
                  final t = activeList[index];
                  final playersReg = t['playersRegistered'] as int;
                  final playersMax = t['playersMax'] as int;
                  final fillPercent = playersReg / playersMax;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.cardColor,
                          AppTheme.primaryColor.withOpacity(0.02),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.monetization_on, color: AppTheme.secondaryColor, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Win ${t['prizePool']} Coins',
                                        style: const TextStyle(
                                          color: AppTheme.secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Trophy Icon Right
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emoji_events_rounded,
                                color: AppTheme.secondaryColor,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Divider(color: Colors.white.withOpacity(0.05), height: 1),
                        const SizedBox(height: 14),

                        // Capacity and details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Entry Fee: ${t['entryFee']} Coins',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              'Players: $playersReg/$playersMax',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Progress bar for players capacity
                        LinearProgressIndicator(
                          value: fillPercent,
                          backgroundColor: Colors.white10,
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 4,
                        ),
                        const SizedBox(height: 16),

                        // Time and Join Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, color: Colors.white30, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  '${t['date']} • ${t['time']}',
                                  style: const TextStyle(color: Colors.white30, fontSize: 11),
                                ),
                              ],
                            ),
                            if (_activeTab == 'Upcoming')
                              GestureDetector(
                                onTap: () => _joinTournament(t),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryColor.withOpacity(0.4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Join Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
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
