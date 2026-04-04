# RRR Flutter App - Implementation Guide

## Overview
This document outlines all the improvements and new features implemented for the RRR Flutter application, including Supabase integration, responsive design, and new screens.

## Complete List of Changes

### 1. Supabase Integration ✅
**Files Created:**
- `lib/core/supabase_client.dart` - Supabase client initializer
- `lib/services/games_repository.dart` - Games data repository
- `lib/services/coins_repository.dart` - Coins transaction repository
- `lib/services/quizistan_repository.dart` - Quizistan quizzes repository
- `lib/services/tournament_repository.dart` - Tournament scores repository
- `lib/models/supabase_models.dart` - Data models for Supabase tables

**Configuration:**
- Added `supabase_flutter` package to `pubspec.yaml`
- Supabase URL: `https://xbbxhkemzrmdsyyclgya.supabase.co`
- API Key: `sb_publishable_fTjFumSU_n7cDxB8wrORpw_J9S10QP_`

**Models Available:**
- `GameScore` - User game scores
- `GameConfig` - Game configuration and rewards
- `CoinTransaction` - Coin earnings and spending
- `QuizistanQuiz` - Quiz information
- `QuizistanAttempt` - Quiz attempt results

### 2. Responsive Design System ✅
**Files Created:**
- `lib/core/responsive_helper.dart` - Responsive utility functions
- `lib/widgets/responsive_button.dart` - Responsive button components
- `lib/widgets/responsive_text.dart` - Responsive text components (Heading, Subheading, Body, Caption)

**Added Package:**
- Added `responsive_sizer: ^3.2.0` to `pubspec.yaml`

**Features:**
- Mobile, tablet, and desktop breakpoints
- Responsive font sizes
- Responsive padding calculations
- Flexible button and text widgets that adapt to screen size

### 3. Enhanced Home Screen ✅
**File Updated:**
- `lib/screens/app_shell.dart` - Updated AppBar with hamburger menu

**Changes:**
- Hamburger menu icon in top-left corner (using Builder and Scaffold.of to open drawer)
- Coins display is now clickable - navigates to `CoinsTransactionScreen`
- Proper import for coins transaction screen added

### 4. New Screens Created ✅

#### Coins Transaction Screen
**File:** `lib/screens/coins_transaction_screen.dart`
- Shows user's complete coin transaction history
- Displays earning and spending transactions
- Shows transaction reasons and amounts
- Responsive design with transaction cards

#### Game Scores Screen
**File:** `lib/screens/game_scores_screen.dart`
- Displays all user game scores
- Groups scores by game type
- Shows statistics: Best score, Average score, Total attempts
- Recent scores with timestamps
- Responsive layout

### 5. Games Module Enhancements ✅
**File Updated:**
- `lib/screens/games/games_screen.dart`

**New Widget:**
- `lib/widgets/game_cards.dart` - GameListCard and GameTileCard components

**Features:**
- List view and Tile view toggle using icons
- Responsive grid layout for tile view
- Easy-to-scan list layout
- Play buttons on each game
- Responsive padding and sizing

### 6. Quizistan Module Refactored ✅
**File Updated:**
- `lib/screens/quizistan/quizistan_screen.dart`

**Changes:**
- Complete refactor to use Supabase API integration
- Changed from StatelessWidget to StatefulWidget
- Fetches active quizzes from `quizistan_quizzes` table
- List view and Tile view toggle
- Quiz browsing interface with:
  - Quiz title, description, and question count
  - Entry fee display
  - Play button for each quiz
  - Loading state with spinner
  - Empty state UI
- Start quiz functionality with coin deduction
- Responsive design supporting mobile and tablet

### 7. New Provider Created ✅
**File:** `lib/providers/profile_provider.dart`
- `UserProfile` model with user information
- `ProfileProvider` for managing user profile state
- Methods for setting, updating, and clearing profile data
- Tracks login state

## Database Integration Details

### Tables Used:
1. **game_scores** - Records all game attempts
2. **game_configs** - Game settings and reward tiers
3. **coin_transactions** - Complete transaction history
4. **quizistan_quizzes** - Available quizzes
5. **quizistan_attempts** - Quiz attempt history
6. **tournament_participants** - Tournament rankings
7. **tournaments** - Tournament information
8. **user_coins** - User coin balance

## Setup Instructions

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Initialize Supabase
The `SupabaseClientManager` is automatically initialized when needed. You can manually initialize in `main.dart`:

```dart
import 'package:rrr_flutter_new/core/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientManager.initialize();
  await AdsService.instance.initialize();
  runApp(const RunRewardRiftApp());
}
```

### Step 3: Update main.dart (if needed)
Ensure Supabase is initialized before the app runs:
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientManager.initialize();
  await AdsService.instance.initialize();
  await _initializeProviders();
  runApp(const RunRewardRiftApp());
}
```

### Step 4: Add Providers to App
Make sure the app initializes these providers:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => WalletProvider()),
    ChangeNotifierProvider(create: (_) => SessionProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    // ... other providers
  ],
  child: const MyApp(),
)
```

## Usage Examples

### Fetching Games
```dart
import 'package:rrr_flutter_new/services/games_repository.dart';

// Get user's recent game scores
final scores = await GamesRepository.getUserRecentGameScores(
  userId: userId,
  limit: 5,
);

// Submit a new game score
await GamesRepository.submitGameScore(
  userId: userId,
  gameId: 'plinko',
  gameName: 'Plinko',
  score: 1500,
  timeTaken: 45000,
);
```

### Managing Coins
```dart
import 'package:rrr_flutter_new/services/coins_repository.dart';

// Get user's coin balance
final balance = await CoinsRepository.getUserCoinBalance(userId);

// Add a coin transaction
await CoinsRepository.addCoinTransaction(
  userId: userId,
  amount: 100,
  type: 'earn',
  reason: 'Won plinko game',
  gameId: 'plinko',
  gameName: 'Plinko',
);

// Get transaction history
final transactions = await CoinsRepository.getUserTransactions(
  userId: userId,
  limit: 50,
);
```

### Quizistan Integration
```dart
import 'package:rrr_flutter_new/services/quizistan_repository.dart';

// Get active quizzes
final quizzes = await QuizistanRepository.getActiveQuizzes();

// Get quizzes by genre
final sportQuizzes = await QuizistanRepository.getQuizzesByGenre('sports');

// Submit quiz attempt
await QuizistanRepository.submitQuizAttempt(
  userId: userId,
  quizId: quizId,
  score: 850,
  correctAnswers: 8,
  totalQuestions: 10,
  coinsEarned: 150,
  timeTaken: 120,
  tierName: 'Gold',
);
```

### Tournament Integration
```dart
import 'package:rrr_flutter_new/services/tournament_repository.dart';

// Get tournament leaderboard
final leaderboard = await TournamentRepository.getTopTournamentPlayers(limit: 50);

// Join tournament
await TournamentRepository.joinTournament(
  userId: userId,
  tournamentId: tournamentId,
  entryFee: 50,
);

// Submit tournament score
await TournamentRepository.submitTournamentScore(
  userId: userId,
  tournamentId: tournamentId,
  score: 2500,
);
```

## Navigation Flow

### From App Shell (Top Navigation)
- **Home Screen**: Shows profile, featured games, and quick navigation
  - Clicking coins icon → Takes to `CoinsTransactionScreen`
  - Hamburger menu → Opens `AppDrawer`
  
- **Games Screen**: Browse and play games
  - Toggle between list and tile view
  - List view for quick scanning
  - Tile view for visual browsing
  
- **Tournament Screen**: Join and compete in tournaments
  - Data sourced from Supabase `tournaments` table
  
- **Quizistan Screen**: Browse and play quizzes
  - Fetch quizzes from Supabase
  - Toggle between list and tile view
  - Entry fees deducted when starting a quiz

## Responsive Design Breakpoints

- **Mobile**: < 600px (phones)
- **Tablet**: 600px - 1200px (tablets)
- **Desktop**: >= 1200px (large screens)

Font sizes scale accordingly:
- Mobile: Smaller (12-24px)
- Tablet: Medium (14-28px)
- Desktop: Larger (16-32px)

## Important Notes

1. **Authentication**: The app currently uses mock user IDs. Implement proper authentication using Supabase Auth for production.

2. **Error Handling**: All repository functions include try-catch blocks. Handle errors appropriately in UI.

3. **Loading States**: Screens with API calls show loading indicators while fetching data.

4. **Empty States**: Proper empty state UI when no data is available.

5. **Offline Support**: Consider adding offline support using local caching for better UX.

6. **Rate Limiting**: Tournament and quiz submission have rate limiting rules in database - check timestamps before allowing submissions.

## Next Steps / TODO

1. Connect login screen with profile section (currently not linked)
2. Implement user authentication flow
3. Add real-time updates using Supabase subscriptions
4. Implement offline caching with Hive or Drift
5. Add push notifications for tournaments and quizzes
6. Create admin panel for managing quizzes and games
7. Implement payment integration for coin purchases
8. Add detailed analytics

## Testing

### API Testing URLs
- Supabase Dashboard: https://app.supabase.com/
- Project: xbbxhkemzrmdsyyclgya

### Test User Flow
1. Start at Login Screen
2. Enter email/password (mock auth)
3. Navigate to Home Screen
4. View featured games
5. Check coins transaction by clicking coins
6. Browse games with list/tile toggle
7. Browse quizzes with list/tile toggle
8. Submit scores to tournament

## Support & Troubleshooting

### Common Issues

**Issue**: Quizzes not loading
- Solution: Check Supabase connection and network
- Check if `quizistan_quizzes` table has active quizzes
- Verify `is_active = true`

**Issue**: Coins not updating
- Solution: Ensure `user_coins` table exists and has entry for user
- Check transaction history in database
- Verify coin repository functions

**Issue**: Responsive layout not adapting
- Solution: Check screen size with `ResponsiveHelper`
- Verify `MediaQuery.of(context).size` is accurate
- Test on different device orientations

## Performance Considerations

1. Queries are limited to specific fields where needed
2. Pagination implemented with limit parameter
3. AsMap() conversions minimize overhead
4. Error handling prevents app crashes
5. Loading states prevent multiple simultaneous requests

## Supabase Connection Test

To verify Supabase is connected:
```dart
// In main.dart or anywhere after initialization
print(SupabaseClientManager.isAuthenticated);
print(SupabaseClientManager.userId);
```

---

**Last Updated**: 2026-04-04
**Version**: 1.0.0
**Status**: Ready for Development
