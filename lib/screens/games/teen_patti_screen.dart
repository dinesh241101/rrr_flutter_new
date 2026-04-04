import 'package:flutter/material.dart';
import 'dart:math';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class TeenPattiScreen extends StatefulWidget {
  const TeenPattiScreen({super.key});

  @override
  State<TeenPattiScreen> createState() => _TeenPattiScreenState();
}

class _TeenPattiScreenState extends State<TeenPattiScreen> {
  List<String> playerCards = [];
  List<String> computerCards = [];
  String result = '';
  int playerMoney = 5000;
  int computerMoney = 5000;
  int betAmount = 0;
  int minBet = 100;
  bool gameInProgress = false;
  String gameMessage = '';

  final List<String> suits = ['♠', '♥', '♦', '♣'];
  final List<String> ranks = [
    'A',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K',
  ];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      playerCards = [];
      computerCards = [];
      result = '';
      gameInProgress = false;
      gameMessage = 'Ready to play? Post a blind!';
      betAmount = 0;
    });
  }

  String _generateCard() {
    return '${ranks[Random().nextInt(ranks.length)]}${suits[Random().nextInt(suits.length)]}';
  }

  void _startGame(int bet) {
    if (bet < minBet) {
      setState(() {
        gameMessage = 'Bet must be at least $minBet!';
      });
      return;
    }

    if (playerMoney < bet || computerMoney < bet) {
      setState(() {
        gameMessage = 'Not enough money for this bet!';
      });
      return;
    }

    setState(() {
      gameInProgress = true;
      betAmount = bet;
      playerCards = [_generateCard(), _generateCard(), _generateCard()];
      computerCards = [_generateCard(), _generateCard(), _generateCard()];
      gameMessage = 'Cards dealt! Your move.';
    });
  }

  void _callBet() {
    _evaluateHands();
  }

  void _raiseBet(int amount) {
    if (playerMoney >= amount && computerMoney >= amount) {
      setState(() {
        betAmount += amount;
        gameMessage = 'Computer matching your raise...';
      });
      Future.delayed(const Duration(seconds: 1), _evaluateHands);
    }
  }

  void _fold() {
    setState(() {
      computerMoney += betAmount;
      gameMessage = 'You folded! Computer wins!';
      gameInProgress = false;
      result = 'FOLD - Computer Wins!';
    });
  }

  void _evaluateHands() {
    int playerScore = _calculateHandScore(playerCards);
    int computerScore = _calculateHandScore(computerCards);

    setState(() {
      if (playerScore > computerScore) {
        playerMoney += betAmount;
        result = 'YOU WIN! 🎉';
        gameMessage = 'You won \$$betAmount!';
      } else if (computerScore > playerScore) {
        computerMoney += betAmount;
        result = 'COMPUTER WINS!';
        gameMessage = 'You lost \$$betAmount.';
      } else {
        result = 'TIE!';
        gameMessage = 'Tie game - bets returned.';
      }
      gameInProgress = false;
    });

    if (playerMoney <= 0 || computerMoney <= 0) {
      Future.delayed(const Duration(seconds: 2), () {
        _showGameOverDialog();
      });
    }
  }

  int _calculateHandScore(List<String> cards) {
    // Simplified hand evaluation
    // Trail (three of a kind) > Pair > High Card
    List<String> ranks_ = cards.map((c) => c[0]).toList();

    if (ranks_[0] == ranks_[1] && ranks_[1] == ranks_[2]) {
      return 1000; // Trail
    }
    if (ranks_[0] == ranks_[1] ||
        ranks_[1] == ranks_[2] ||
        ranks_[0] == ranks_[2]) {
      return 500; // Pair
    }

    // High card
    int score = 0;
    for (String rank in ranks_) {
      score += _rankValue(rank);
    }
    return score;
  }

  int _rankValue(String rank) {
    return ranks.indexOf(rank) + 1;
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonTheme.darkBg2,
        title: ResponsiveSubheading(
          playerMoney > 0 ? 'You Won!' : 'Game Over!',
          color: playerMoney > 0 ? NeonTheme.neonLime : Colors.red,
        ),
        content: ResponsiveBody(
          playerMoney > 0
              ? 'Congratulations! You won \$${playerMoney}!'
              : 'You ran out of money!',
          color: Colors.white,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                playerMoney = 5000;
                computerMoney = 5000;
                _resetGame();
              });
            },
            child: ResponsiveBody('Play Again', color: NeonTheme.neonCyan),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Teen Patti', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Money Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ResponsiveBody('Your Stack', color: NeonTheme.neonLime),
                    ResponsiveHeading(
                      '\$$playerMoney',
                      color: NeonTheme.neonLime,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ResponsiveBody('Pot', color: Colors.yellow),
                    ResponsiveHeading(
                      '\$${betAmount * 2}',
                      color: Colors.yellow,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ResponsiveBody('Computer', color: NeonTheme.neonCyan),
                    ResponsiveHeading(
                      '\$$computerMoney',
                      color: NeonTheme.neonCyan,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Game Message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: NeonTheme.neonCyan),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ResponsiveBody(
                gameMessage,
                color: NeonTheme.neonCyan,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Result Display
            if (result.isNotEmpty)
              ResponsiveSubheading(
                result,
                color: result.contains('WIN')
                    ? NeonTheme.neonLime
                    : result.contains('FOLD') || result.contains('COMPUTER')
                    ? Colors.red
                    : Colors.yellow,
              ),
            const SizedBox(height: 24),

            // Computer Cards
            ResponsiveBody('Dealer Cards', color: NeonTheme.neonCyan),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: computerCards
                  .map((card) => _buildCard(card, NeonTheme.neonCyan))
                  .toList(),
            ),
            const SizedBox(height: 32),

            // Your Cards
            ResponsiveBody('Your Cards', color: NeonTheme.neonLime),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: playerCards
                  .map((card) => _buildCard(card, NeonTheme.neonLime))
                  .toList(),
            ),
            const SizedBox(height: 32),

            // Betting Options
            if (!gameInProgress) ...[
              ResponsiveBody('Select Blind Amount', color: Colors.white),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [100, 500, 1000, 2000]
                    .map(
                      (bet) => ElevatedButton(
                        onPressed: () => _startGame(bet),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                          side: BorderSide(color: NeonTheme.neonCyan),
                        ),
                        child: ResponsiveBody(
                          '\$$bet',
                          color: NeonTheme.neonCyan,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ] else ...[
              // Game Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _fold,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.2),
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const ResponsiveSubheading(
                      'Fold',
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _callBet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                      side: BorderSide(color: NeonTheme.neonCyan),
                    ),
                    child: ResponsiveSubheading(
                      'Call',
                      color: NeonTheme.neonCyan,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _raiseBet(betAmount ~/ 2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeonTheme.neonLime.withOpacity(0.2),
                      side: BorderSide(color: NeonTheme.neonLime),
                    ),
                    child: ResponsiveSubheading(
                      'Raise',
                      color: NeonTheme.neonLime,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String card, Color color) {
    return Container(
      width: 60,
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: NeonTheme.darkBg2,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveBody(card.substring(0, card.length - 1), color: color),
            ResponsiveBody(card.substring(card.length - 1), color: color),
          ],
        ),
      ),
    );
  }
}
