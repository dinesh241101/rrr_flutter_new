# Quick Reference Guide

## Common Tasks

### Navigate to Coins Transaction Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CoinsTransactionScreen(userId: userId),
  ),
);
```

### Fetch User Game Scores
```dart
import 'package:rrr_flutter_new/services/games_repository.dart';

final scores = await GamesRepository.getUserGameScores(userId);
```

### Display Responsive Button
```dart
import 'package:rrr_flutter_new/widgets/responsive_button.dart';

ResponsiveButton(
  label: 'Play Game',
  onPressed: () => playGame(),
  backgroundColor: Colors.blueAccent,
)
```

### Display Responsive Text
```dart
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

ResponsiveHeading('My Title');
ResponsiveSubheading('Subtitle');
ResponsiveBody('Regular text');
ResponsiveCaption('Small text');
```

### Get Coin Transactions
```dart
import 'package:rrr_flutter_new/services/coins_repository.dart';

final transactions = await CoinsRepository.getUserTransactions(
  userId: userId,
  limit: 50,
);
```

### Fetch Active Quizzes
```dart
import 'package:rrr_flutter_new/services/quizistan_repository.dart';

final quizzes = await QuizistanRepository.getActiveQuizzes();
```

### Submit Quiz Score
```dart
await QuizistanRepository.submitQuizAttempt(
  userId: userId,
  quizId: quizId,
  score: score,
  correctAnswers: correct,
  totalQuestions: total,
  coinsEarned: coins,
);
```

### Check Screen Size (Responsive Design)
```dart
import 'package:rrr_flutter_new/core/responsive_helper.dart';

if (ResponsiveHelper.isMobile(context)) {
  // Mobile layout
} else if (ResponsiveHelper.isTablet(context)) {
  // Tablet layout
} else {
  // Desktop layout
}
```

### Get Responsive Font Size
```dart
final fontSize = ResponsiveHelper.getResponsiveFontSize(
  context,
  mobileSize: 14,
  tabletSize: 16,
  desktopSize: 18,
);
```

### Get Responsive Padding
```dart
final padding = ResponsiveHelper.getResponsivePadding(
  context,
  mobilePadding: 16,
  tabletPadding: 24,
  desktopPadding: 32,
);
```

### Update User Profile
```dart
import 'package:rrr_flutter_new/providers/profile_provider.dart';

final profile = UserProfile(
  id: 'user_123',
  username: 'Player Name',
  email: 'email@example.com',
  createdAt: DateTime.now(),
);

context.read<ProfileProvider>().setProfile(profile);
```

### Access Supabase Client
```dart
import 'package:rrr_flutter_new/core/supabase_client.dart';

final userId = SupabaseClientManager.userId;
final isAuthenticated = SupabaseClientManager.isAuthenticated;
final client = SupabaseClientManager.client;
```

### Handle API Errors
```dart
try {
  final data = await GamesRepository.getUserGameScores(userId);
} catch (e) {
  print('Error: $e');
  // Show error to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error loading data')),
  );
}
```

### Game List/Tile View Pattern
```dart
bool _isListView = false;

if (!_isListView) {
  // Show GridView with GameTileCard
  GridView.builder(...)
} else {
  // Show ListView with GameListCard
  ListView.builder(...)
}
```

### Handle Loading State
```dart
FutureBuilder<List<GameScore>>(
  future: GamesRepository.getUserGameScores(userId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    final data = snapshot.data ?? [];
    return ListView(...)
  },
)
```

---

## Navigation Routes

| Screen | Route | Import |
|--------|-------|--------|
| Coins Transactions | `CoinsTransactionScreen(userId)` | `lib/screens/coins_transaction_screen.dart` |
| Game Scores | `GameScoresScreen(userId)` | `lib/screens/game_scores_screen.dart` |
| Games | Tab navigation (Games tab) | Built-in |
| Quizistan | Tab navigation (Quizistan tab) | Built-in |
| Tournament | Tab navigation (Tournament tab) | Built-in |

---

## Debugging Tips

### Enable Verbose Logging
```bash
flutter run -v
```

### Check Supabase Connection
```dart
print('Connected: ${SupabaseClientManager.isAuthenticated}');
print('User ID: ${SupabaseClientManager.userId}');
```

### Inspect API Response
Add print statements in repository methods:
```dart
print('Response: $response');
print('Response type: ${response.runtimeType}');
```

### Hot Reload
- Save file → Automatic reload
- Press 'r' in terminal
- Or Ctrl+\ (Cmd+\) in IDE

### Clear App Data
```bash
flutter clean
flutter pub get
```

---

## Performance Tips

1. **Use const** constructors where possible
2. **Avoid rebuilds** with Consumer widgets
3. **Limit API responses** with limit parameter
4. **Cache results** when possible
5. **Use images wisely** - compress before adding

---

## Common Errors & Solutions

### "Supabase not initialized"
**Solution**: Ensure `SupabaseClientManager.initialize()` called in main.dart

### "Network error"
**Solution**: Check internet connection and Supabase project status

### "Empty list returned"
**Solution**: Check RLS policies, ensure data exists in database

### "Type mismatch"
**Solution**: Check `fromJson()` mapping matches database schema

### "Hot reload shows old code"
**Solution**: Use hot restart (Ctrl+Shift+F5) or flutter restart

---

## Database Query Examples

### Get Transactions
```
SELECT * FROM coin_transactions 
WHERE user_id = '<user_id>' 
ORDER BY created_at DESC 
LIMIT 50
```

### Get Game Scores
```
SELECT * FROM game_scores 
WHERE user_id = '<user_id>' 
ORDER BY created_at DESC
```

### Get Active Quizzes
```
SELECT * FROM quizistan_quizzes 
WHERE is_active = true 
ORDER BY created_at DESC
```

### Get Tournament Leaderboard
```
SELECT * FROM tournament_participants 
ORDER BY score DESC, rank ASC 
LIMIT 50
```

---

## Environment Setup

### Flutter Version Check
```bash
flutter --version
```

### Doctor Check
```bash
flutter doctor
```

### Upgrade Flutter
```bash
flutter upgrade
```

---

## Useful Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Run with profile
flutter run --profile

# Build release
flutter build apk
flutter build app-bundle  # iOS
flutter build ios         # iOS

# Run tests
flutter test

# Format code
flutter format lib/

# Analyze code
flutter analyze
```

---

## Widget Tree Structure

```
MaterialApp
├── AppShell (Scaffold)
│   ├── AppBar
│   │   ├── Hamburger Menu (leading)
│   │   ├── Title (page name)
│   │   └── Action Buttons
│   │       ├── Coins (clickable)
│   │       └── Account
│   ├── Body
│   │   └── IndexedStack
│   │       ├── HomeScreen
│   │       ├── GamesScreen
│   │       ├── TournamentScreen
│   │       └── QuizistanScreen
│   ├── Drawer
│   │   └── AppDrawer
│   └── BottomNavigationBar
│       └── 4 Navigation Items
```

---

## File Locations Quick Reference

### New Screens
- Coins: `lib/screens/coins_transaction_screen.dart`
- Game Scores: `lib/screens/game_scores_screen.dart`

### Services/Repositories
- Games: `lib/services/games_repository.dart`
- Coins: `lib/services/coins_repository.dart`
- Quizistan: `lib/services/quizistan_repository.dart`
- Tournament: `lib/services/tournament_repository.dart`

### Components
- Responsive Buttons: `lib/widgets/responsive_button.dart`
- Responsive Text: `lib/widgets/responsive_text.dart`
- Game Cards: `lib/widgets/game_cards.dart`

### Core
- Supabase Client: `lib/core/supabase_client.dart`
- Responsive Helper: `lib/core/responsive_helper.dart`

### Models
- Supabase Models: `lib/models/supabase_models.dart`
- Profile: `lib/providers/profile_provider.dart`

---

## Testing Checklist

- [ ] App launches without errors
- [ ] Hamburger menu opens drawer
- [ ] Coins click navigates to transaction screen
- [ ] Games display in both list and tile views
- [ ] Toggle between views works smoothly
- [ ] Quizzes load from API
- [ ] Quiz list and tile views toggle correctly
- [ ] Responsive design works on 3+ screen sizes
- [ ] No console errors
- [ ] All buttons are clickable

---

**Last Updated**: 2026-04-04
**Quick Reference v1.0**
